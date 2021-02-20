<template>
<div>
    <h1>新規登録画面</h1>
    <form>
      <div>
        <label for="name">
          ユーザ名
        </label>
        <input v-model="user.name" id="name" type="text" placeholder="name">
      </div>
      <div>
        <label for="email">
          メールアドレス
        </label>
        <input v-model="user.email" id="Email" type="text" placeholder="email">
      </div>
      <div>
        <label for="password">
          パスワード
        </label>
        <input v-model="user.password" id="password" type="password" placeholder="password">
      </div>
      <div>
        <label for="password">
          パスワード(確認用)
        </label>
        <input v-model="user.password_confirmation" id="password_confirmation" type="password" placeholder="password_confirmation">
      </div>
      <button @click="registerUser">
        Sign Up
      </button>
    </form>
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