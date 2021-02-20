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
              <div class="form-group row">
                <label for="email" class="col-md-4 col-form-label text-md-right">メールアドレス</label>
                <input v-model="user.email" id="Email" class="form-control col-md-6" type="text" placeholder="email">
              </div>
              <div class="from-group row">
                <label for="password" class="col-md-4 col-form-label text-md-right">パスワード</label>
                <input v-model="user.password" id="password" class="form-control col-md-6" type="password" placeholder="password">
              </div>
              <div class="form-group row">
                <label for="password" class="col-md-4 col-form-label text-md-right">パスワード(確認用)</label>
                <input v-model="user.password_confirmation" id="password_confirmation" class="form-control col-md-6" type="password" placeholder="password_confirmation">
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
          password_confirmation: ''
        }
      }
    },
    methods: {
      registerUser: function () {
        axios.post('api/auth', this.user ).then((response) => {
          console.log('ユーザー登録完了！')
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
            console.log('失敗')
            console.log(error)
          })
          location.href = "http://localhost:3000/mypage"
          return response
        }, (error) => {
          console.log(error)
        })
      }
    }
  }
</script>