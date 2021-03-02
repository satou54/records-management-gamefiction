<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header text-center">
            <h1>ユーザ新規登録</h1>
          </div>
          <div class="card-body">
            <div class="form-group row">
              <label for="name" class="col-md-4 col-form-label text-md-right">ユーザ名</label>
              <input v-model.trim="user.name" id="name" class="form-control col-md-6" type="text" placeholder="name">
              <span v-if="!validationName" class="col-md-6 offset-md-4 text-warning">{{ nameValidateMessage }}</span>
            </div>
            <div class="form-group row">
              <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
              <input v-model.trim="user.email" id="Email" class="form-control col-md-6" type="text" placeholder="email">
              <span v-if="!validationEmail" class="col-md-6 offset-md-4 text-warning">{{ emailValidateMessage }}</span>
            </div>
            <div class="from-group row">
              <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
              <input v-model.trim="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
              <span v-if="!validationPassword" class="col-md-6 offset-md-4 text-warning">{{ passwordValidateMessage }}</span>
            </div>
            <div class="form-group row">
              <label for="passwordConfirmation" class="col-md-4 col-form-label text-md-right">パスワード(確認)</label>
              <input v-model.trim="user.passwordConfirmation" id="passwordConfirmation" class="form-control col-md-6" type="password" placeholder="passwordConfirmation">
              <span v-if="!validationPasswordConfirm" class="col-md-6 offset-md-4 text-warning">{{ passwordConfirmValidateMessage }}</span>
              <span v-if="!!signUpValidateMessage" class="mt-3 mb-0 mx-auto alert alert-danger">{{ signUpValidateMessage }}</span>
            </div>
            <div class="row">
              <button @click="registerUser" :disabled="!validation" class="btn btn-primary mt-1 mx-auto d-block">登録</button>
            </div>
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
        nameValidateMessage: '',
        emailValidateMessage: '',
        passwordValidateMessage: '',
        passwordConfirmValidateMessage: '',
        signUpValidateMessage: ''
      }
    },
    computed: {
      validation: function () {
        return (this.validationName && this.validationEmail 
                && this.validationPassword && this.validationPasswordConfirm)
      },
      validationName: function () {
        if (!this.user.name) {
          this.nameValidateMessage = 'ユーザ名が空です'
          return false
        } else if (this.user.name.length > 25) {
          this.nameValidateMessage = 'ユーザ名は25文字以内で入力してください'
        }
        return true
      },
      validationEmail: function () {
        const emailRegExp = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/

        if (!this.user.email) {
          this.emailValidateMessage = 'メールアドレスが空です'
          return false
        } else if (!emailRegExp.test(this.user.email)) {
          this.emailValidateMessage = 'メールアドレスの形式が間違っています'
          return false
        } else if (this.user.email.length > 255) {
          this.emailValidateMessage = 'メールアドレスは255文字以内で入力してください'
          return false
        }
        return true
      },
      validationPassword: function () {
        const passwordRegExp = /^[0-9a-zA-Z]*$/

        if (!this.user.password) {
          this.passwordValidateMessage = 'パスワードが空です'
          return false
        } else if (!passwordRegExp.test(this.user.password)) {
          this.passwordValidateMessage = 'パスワードは半角英数字で入力してください'
          return false
        } else if (this.user.password.length < 6) {
          this.passwordValidateMessage = 'パスワードは6文字以上です'
          return false
        }
        return true
      },
      validationPasswordConfirm: function () {
        if (!this.user.passwordConfirmation) {
          this.passwordConfirmValidateMessage = 'パスワード(確認)が空です'
          return false
        } else if (this.user.password !== this.user.passwordConfirmation) {
          this.passwordConfirmValidateMessage = 'パスワードと一致しません'
          return false
        }
        return true
      }
    },
    methods: {
      registerUser: function () {
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
            this.signUpValidateMessage = "登録に失敗しました。もう一度試してください"
          }
        })
      }
    }
  }
</script>