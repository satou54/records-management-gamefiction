<template>
  <nav class="navbar navbar-expand-sm navbar-dark bg-primary">
    <a href="#" class="navbar-brand">Navbar</a>
    <button class="navbar-toggler" type="button"
        data-toggle="collapse"
        data-target="#navmenu1"
        aria-controls="navmenu1"
        aria-expanded="false"
        aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navmenu1">
    <div class="navbar-nav">
      <router-link to="/" class="nav-item nav-link text-white text-right">TOP</router-link>
      <router-link to="/login" class="nav-item nav-link text-white text-right" v-if="!user_login_flg">ログイン</router-link>
      <router-link to="/signup" class="nav-item nav-link text-white text-right" v-if="!user_login_flg">新規登録</router-link>
      <router-link to="/mypage" class="nav-item nav-link text-white text-right" v-if="user_login_flg">マイページ</router-link>
      <router-link to="" class="nav-item nav-link text-white text-right" v-if="user_login_flg" @click.native="logoutUser">ログアウト</router-link>
    </div>
  </div>
  </nav>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function () {
      return {
        user_login_flg: false,
        headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
      }
    },
    mounted: function () {
      this.user_login();
    },
    methods: {
      user_login: function () {
        if (!localStorage.getItem('access-token')) {
          this.user_login_flg = false
        } else {
          this.user_login_flg = true
          /* axios.get('api/auth/validate_token',
                    { headers: this.headers}
          ).then((response) => {
            this.user_login_flg = true
          }, (error) => {
            console.log('認証失敗')
            this.user_login_flg = false
            console.log(error)
          }) */
        }
      },
      logoutUser: function () {
        axios.delete('/api/auth/sign_out', 
                    { headers: this.headers } 
        ).then((response) => {
            localStorage.clear()
            location.href = "http://localhost:3000/"
        }, (error) => {
          console.log(error)
        })
      }
    }
  }
</script>