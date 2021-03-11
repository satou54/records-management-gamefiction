<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header text-center">
            <h1>ログイン</h1>
          </div>
          <div class="card-body">
            <div class="form-group row">
              <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
              <input v-model.trim="user.email" id="email" class="form-control col-md-6" type="text" placeholder="email">
              <span v-if="!validationEmail" class="col-md-6 offset-md-4 text-warning">{{ emailValidateMessage }}</span>
            </div>
            <div class="form-group row">
              <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
              <input v-model.trim="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
              <span v-if="!validationPassword" class="col-md-6 offset-md-4 text-warning">{{ passwordValidateMessage }}</span>
              <span v-if="!!loginValidateMessage" class="mt-3 mb-0 mx-auto alert alert-danger">{{ loginValidateMessage }}</span>
            </div>
            <div class="row">
              <button @click="loginUser" :disabled="!validation" class="btn btn-primary mt-1 mx-auto d-block">ログイン</button>
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
          email: '',
          password: ''
        },
        emailValidateMessage: '',
        passwordValidateMessage: '',
        loginValidateMessage: ''
      }
    },
    computed: {
      validation: function () {
        return (this.validationEmail && this.validationPassword)
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
      }
    },
    methods: {
      loginUser: function () {
        axios.post('api/auth/sign_in', this.user).then((response) => {
          localStorage.setItem('access-token', response.headers['access-token'])
          localStorage.setItem('client', response.headers.client)
          localStorage.setItem('uid', response.headers.uid)
          localStorage.setItem('token-type', response.headers['token-type'])
          localStorage.setItem('user_id', response.data['data'].id)
          localStorage.setItem('email', response.data['data'].email)
          localStorage.setItem('name', response.data['data'].name)
          llocation.href = "/mypage"
          return response
        }, (error) => {
          console.log(error)
          error.response.data.errors
          if (error.response.status == 401) {
            this.loginValidateMessage = "メールアドレスかパスワードが間違っています"
          }
        })
      }
    }
  }
</script>