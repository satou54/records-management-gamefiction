<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">ログイン</div>
            <dif class="card-body">
              <form>
                <div class="form-group row">
                  <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
                  <input v-model="user.email" id="email" class="form-control col-md-6" type="text" placeholder="email">
                </div>
                <div class="form-group row">
                  <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
                  <input v-model="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
                </div>
                <div class="row">
                  <div class="col-md-8 offset-md-4">
                    <button @click="loginUser" class="btn btn-primary">ログイン</button>
                  </div>
                </div>
              </form>
            </dif>
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
        }
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
        })
      }
    }
  }
</script>