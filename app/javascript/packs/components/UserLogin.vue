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
                <span v-if="!validationEmail" class="text-warning">{{ emailValidateMessage }}</span>
                <div class="form-group row">
                  <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
                  <input v-model="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
                </div>
                <span v-if="!validationPassword" class="text-warning">{{ passwordValidateMessage }}</span>
                <span v-if="!!loginValidateMessage" class="text-warning">{{ loginValidateMessage }}</span>
                <div class="row">
                  <div class="col-md-8 offset-md-4">
                    <button @click="loginUser" :disabled="!validation" class="btn btn-primary">ログイン</button>
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
          this.emailValidateMessage = 'メールアドレスが空です。'
          return false
        } else if (!emailRegExp.test(this.user.email)) {
          this.emailValidateMessage = 'メールアドレスの形式が間違っています。'
          return false
        }
        return true
      },
      validationPassword: function () {
        const passwordRegExp = /^[0-9a-zA-Z]*$/

        if (!this.user.password) {
          this.passwordValidateMessage = 'パスワードが空です。'
          return false
        } else if (!passwordRegExp.test(this.user.password)) {
          this.passwordValidateMessage = 'パスワードは半角英数字で入力してください。'
          return false
        } else if (this.user.password.length < 6) {
          this.passwordValidateMessage = 'パスワードは6文字以上です。'
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
          location.href = "http://localhost:3000/mypage"
          return response
        }, (error) => {
          console.log(error)
          if (error.response.status == 401) {
            this.loginValidateMessage = "メールアドレスかパスワードが間違っています。"
          }
        })
      }
    }
  }
</script>