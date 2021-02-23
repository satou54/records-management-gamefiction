<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">ユーザ登録</div>
          <div class="card-body">
            <form>
              <div class="form-group row">
                <label for="name" class="col-md-4 col-form-label text-md-right">ユーザ名</label>
                <input v-model="user.name" id="name" class="form-control col-md-6" type="text" placeholder="name">
              </div>
              <div v-if="nameValidate">
                <p class="alert alert-danger">{{ nameValidate }}</p>
              </div>
              <div class="form-group row">
                <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
                <input v-model="user.email" id="Email" class="form-control col-md-6" type="text" placeholder="email">
              </div>
              <div v-if="emailValidate">
                <p class="alert alert-danger">{{ emailValidate }}</p>
              </div>
              <div class="from-group row">
                <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
                <input v-model="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
              </div>
              <div v-if="passwordValidate">
                <p class="alert alert-danger">{{ passwordValidate }}</p>
              </div>
              <div class="form-group row">
                <label for="passwordConfirmation" class="col-md-4 col-form-label text-md-right">パスワード(確認)</label>
                <input v-model="user.passwordConfirmation" id="passwordConfirmation" class="form-control col-md-6" type="password" placeholder="passwordConfirmation">
              </div>
              <div v-if="passwordConfirmValidate">
                <p class="alert alert-danger">{{ passwordConfirmValidate }}</p>
              </div>
              <div v-if="signUpValidate">
                <p class="alert alert-danger">{{ signUpValidate }}</p>
              </div>
              <div class="row">
                <div class="col-md-8 offset-md-4">
                  <button @click="registerUser" class="btn btn-primary">登録</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'

  export default {
    data: function () {
      return {
        user: {
          name: '',
          email: '',
          password: '',
          passwordConfirmation: ''
        },
        signUpFlg: false,
        nameValidate: '',
        emailValidate: '',
        passwordValidate: '',
        passwordConfirmValidate: '',
        signUpValidate: ''
      }
    },
    methods: {
      registerUser: function () {
        // バリデーション
        this.signUpFlg = false
        this.nameValidate= ''
        this.emailValidate = ''
        this.passwordValidate = ''
        this.passwordConfirmValidate = ''
        this.signUpValidate = ''

        const emailRegExp = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
        const passwordRegExp = /^[0-9a-zA-Z]*$/

        if (!this.user.name) {
          this.nameValidate = 'ユーザ名が空です。'
        } else {
          this.signUpFlg = true
        }

        if (!this.user.email) {
          this.emailValidate = 'メールアドレスが空です。'
          this.signUpFlg = false
        } else if (!emailRegExp.test(this.user.email)) {
          this.emailValidate = 'メールアドレスの形式が間違っています。'
          this.signUpFlg = false
        }

        if (!this.user.password) {
          this.passwordValidate = 'パスワードが空です'
          this.signUpFlg = false
        } else if (!passwordRegExp.test(this.user.password)) {
          this.passwordValidate = 'パスワードは半角英数字で入力してください。'
          this.signUpFlg = false
        } else if (this.user.password.length < 6) {
          this.passwordValidate = 'パスワードは6文字以上です。'
        }

        if (!this.user.passwordConfirmation) {
          this.passwordConfirmValidate = 'パスワード(確認)が空です。'
        } else if (this.user.password !== this.user.passwordConfirmation) {
          this.passwordConfirmValidate = 'パスワードが一致しません。'
        }
        
        alert('チェック用')

        if (this.signUpFlg) {
          axios.post('api/auth', this.user ).then((response) => {
            localStorage.setItem('access-token', response.headers['access-token'])
            localStorage.setItem('client', response.headers.client)
            localStorage.setItem('uid', response.headers.uid)
            localStorage.setItem('token-type', response.headers['token-type'])
            localStorage.setItem('user_id', response.data['data'].id)
            localStorage.setItem('email', response.data['data'].email)
            localStorage.setItem('name', response.data['data'].name)
            axios.post('api/user_levels', { level: 1, total_experience_point: 0, 
                                            user_id: localStorage.getItem('user_id') 
                                          }).then((response) => {
            }, (error) => {
              console.log(error)
            })
            location.href = "http://localhost:3000/mypage"
            return response
          }, (error) => {
            console.log(error)
            if (error.response.status == 422) {
              this.signUpValidate = "登録に失敗しました。もう一度試してください。"
              alert('登録に失敗しました。もう一度試してみてください。')
            }
          })
        }
      }
    }
  }
</script>