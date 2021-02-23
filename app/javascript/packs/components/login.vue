<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">ログイン</div>
            <div class="card-body">
              <form>
                <div class="form-group row">
                  <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
                  <input v-model="user.email" id="email" class="form-control col-md-6" type="text" placeholder="email">
                </div>
                <div v-if="emailValidate">
                  <p class="alert alert-danger">{{ emailValidate }}</p>
                </div>
                <div class="form-group row">
                  <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
                  <input v-model="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
                </div>
                <div v-if="passwordValidate">
                  <p class="alert alert-danger">{{ passwordValidate }}</p>
                </div>
                <div v-if="loginValidate">
                  <p class="alert alert-danger">{{ loginValidate }}</p>
                </div>
                <div class="row">
                  <div class="col-md-8 offset-md-4">
                    <button @click="loginUser" class="btn btn-primary">ログイン</button>
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
          email: '',
          password: ''
        },
        loginFlg: false,
        emailValidate: '',
        passwordValidate: '',
        loginValidate: ''
      }
    },
    methods: {
      loginUser: function () {
        this.loginFlg = false
        this.emailValidate = ''
        this.passwordValidate = ''
        this.loginValidate = ''

        const emailRegExp = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
        const passwordRegExp = /^[0-9a-zA-Z]*$/

        if (!this.user.email) {
          this.emailValidate = 'メールアドレスが空です。'
        } else if (!emailRegExp.test(this.user.email)) {
          this.emailValidate = 'メールアドレスの形式が間違っています。'
        } else {
          this.loginFlg = true
        }

        if (!this.user.password) {
          this.passwordValidate = 'パスワードが空です。'
          this.loginFlg = false
        } else if (!passwordRegExp.test(this.user.password)) {
          this.passwordValidate = 'パスワードは半角英数字で入力してください。'
          this.loginFlg = false
        } else if (this.user.password.length < 6) {
          this.passwordValidate = 'パスワードは6文字以上です。'
          this.loginFlg = false
        } else {
          this.loginFlg = true
        }

        alert('チェック用')

        if (this.loginFlg) {
          axios.post('api/auth/sign_in', this.user).then((response) => {
            localStorage.setItem('access-token', response.headers['access-token'])
            localStorage.setItem('client', response.headers.client)
            localStorage.setItem('uid', response.headers.uid)
            localStorage.setItem('token-type', response.headers['token-type'])
            localStorage.setItem('user_id', response.data['data'].id)
            localStorage.setItem('email', response.data['data'].email)
            localStorage.setItem('name', response.data['data'].name)
            location.href = "http://localhost:3000/mypage"
            return response
          }, (error) => {
            console.log(error)
            if (error.response.status == 401) {
              this.loginValidate = "メールアドレスかパスワードが間違っています。"
              alert('メールアドレスかパスワードが間違っています。')
            }
          })
        }
      }
    }
  }
</script>