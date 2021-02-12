<template>
  <div>
    <h1>ログアウト画面</h1>
    <button @click="logoutUser">
      ログアウト
    </button>
    </p>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  methods: {
    logoutUser: function () {
      axios.delete('/api/auth/sign_out', { headers: 
        { 'access-token': localStorage.getItem('access-token'),
          uid: localStorage.getItem('uid'),
          client: localStorage.getItem('client') }} ).then((response) => {
            localStorage.clear()
      }, (error) => {
        console.log(error)
      })
    }
  }  
}
</script>