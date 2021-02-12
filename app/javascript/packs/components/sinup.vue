<template>
<div>
    <h1>新規登録画面</h1>
    <div>
      <label for="name">
        Name
      </label>
      <input v-model="user.name" id="name" type="text" placeholder="name">
    </div>
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
    <div>
      <label for="password">
        Password(確認用)
      </label>
      <input v-model="user.password_confirmation" id="password_confirmation" type="password" placeholder="password_confirmation">
    </div>
    <button @click="registerUser">
      Sign Up
    </button>
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
        }, (error) => {
          console.log(error)
        })
      }
    }
  }
</script>