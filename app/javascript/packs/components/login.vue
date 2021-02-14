<template>
  <div>
    <form>
      <h1>ログイン画面</h1>
      <div>
        <label for="email">
          Email
        </label>
        <input v-model="user.email" id="Email" type="text" placeholder="email">
      </div>
      <div>
        <label for="password">
          Password
        </label>
        <input v-model="user.password" id="password" type="password" placeholder="password">
      </div>
      <button @click="loginUser">
        Login
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
          return response
        }, (error) => {
          console.log(error)
        })
      }
    }
  }
</script>