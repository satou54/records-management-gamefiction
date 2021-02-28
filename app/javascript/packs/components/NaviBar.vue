<template>
  <nav class="navbar navbar-expand-sm">
    <router-link to="/" class="navbar-brand">しゅうかん+</router-link>
    <button class="navbar-toggler" type="button" id="navbar-toggler"
        data-toggle="collapse"
        data-target="#navmenu"
        aria-controls="navmenu"
        aria-expanded="false"
        aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navmenu">
    <div class="navbar-nav">
      <router-link to="/" class="nav-item nav-link text-right" @click.native="closeToggle()">TOP</router-link>
      <router-link to="/login" class="nav-item nav-link text-right" @click.native="closeToggle()" v-if="!userLoginFlg">ログイン</router-link>
      <router-link to="" class="nav-item nav-link text-right" @click.native="loginGestUser(); closeToggle()" v-if="!userLoginFlg">ゲストログイン</router-link>
      <router-link to="/signup" class="nav-item nav-link text-right" @click.native="closeToggle()" v-if="!userLoginFlg">新規登録</router-link>
      <router-link to="/mypage" class="nav-item nav-link text-right" @click.native="closeToggle()" v-if="userLoginFlg">マイページ</router-link>
      <router-link to="" class="nav-item nav-link text-right" @click.native="logoutUser(); closeToggle()" v-if="userLoginFlg">ログアウト</router-link>
    </div>
  </div>
  </nav>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function () {
      return {
        userLoginFlg: false,
        headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
      }
    },
    mounted: function () {
      this.userAuthentication();
    },
    methods: {
      userAuthentication: function () {
        if (!localStorage.getItem('access-token')) {
          this.userLoginFlg = false
        } else {
          this.userLoginFlg = true
        }
      },
      loginGestUser: function () {
        axios.post('api/auth/sign_in', {email: "test@example.com", password: "password"} ).then((response) => {
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
      },
      closeToggle: function () {
        document.getElementById("navbar-toggler").click();
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