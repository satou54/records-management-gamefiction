<template>
  <div>
      <div class="container-fluid" id="top">
        <div class="row">
          <div class="col-12" id="title-content">
            <h1 class="text-center">しゅうかん+</h1>
            <h3 class="text-center">新しい習慣をつくって人生をかえよう</h3>
            <button class="btn btn-primary mx-auto d-block" @click="loginGestUser" v-if="!userLoginFlg">ゲストログイン</button>
          </div>
        </div>
      </div>
      <div class="container-fluid" id="app-summary">
        <div class="row">
          <div class="col-12">
            <h3 class="text-center mt-4">4つの機能で習慣化をサポート</h3>
            <div class="card">
              <div class="card-header">
                <img src="/assets/meditation.png">
                目標設定
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p>習慣化したいことの目標を設定することができます。</p>
                </div>
              </div>
            </div>
            <div class="card">
              <div class="card-header">
                <img src="/assets/record.png">
                行動記録
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p>毎日の行動を1日単位で記録することができます。</p>
                </div>
              </div>
            </div>
            <div class="card">
              <div class="card-header">
                <img src="/assets/muscle.png">
                ゲームフィケーション
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p>目標達成、行動記録によって経験値が増加し、レベルアップします。</p>
                </div>
              </div>
            </div>
            <div class="card mb-4">
              <div class="card-header">
                <img src="/assets/reference.png">
                行動参照
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p>過去の行動記録を参照することができます。</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="container-fluid" id="app-function">
        <div class="row">
          <div class="col-12 mt-5">
            <div class="card">
              <div class="card-header">
                <h3 class="text-center mt-4">目標を設定しよう</h3>
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p class="text-center">習慣化したいことの目標を設定します。1週間単位の目標を設定することができます。</p>
                  <img src="/assets/task_new.png" class="site-image">
                </div>
              </div>
            </div>
            <div class="card">
              <div class="card-header">
                <h3 class="text-center mt-4">行動を記録しよう</h3>
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p class="text-center">行動した日の記録をします。当日だけでなく過去に振り返って記録することもできます。</p>
                  <img src="/assets/action_record_registration.png" class="site-image">
                </div>
              </div>
            </div>
            <div class="card">
              <div class="card-header">
                <h3 class="text-center mt-4">レベル機能で楽しく習慣化</h3>
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p class="text-center">
                    1週間の目標達成、行動記録で経験値が増加し、必要経験値が溜まるとレベルアップします。
                    ゲームフィケーションを用いることで習慣化する可能性が高くなります。
                  </p>
                  <img src="/assets/progress_bar.png" class="site-image">
                </div>
              </div>
            </div>
            <div class="card">
              <div class="card-header">
                <h3 class="text-center mt-4">行動を振り返ろう</h3>
              </div>
              <div class="card-body">
                <div class="card-text">
                  <p class="text-center">過去の行動を振り返ることができます。一定期間ごとに振り返って自分の行動を確認しよう。</p>
                  <img src="/assets/action_records_references.png" class="site-image">
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="container-fluid" id="closing">
        <div class="row">
          <div class="col-12" id="closing-content">
            <h3 class="text-center">さっそく始めよう</h3>
            <p class="text-center">新しい習慣をつくって人生をかえよう</p>
            <button class="btn btn-primary mx-auto d-block" @click="loginGestUser" v-if="!userLoginFlg">ゲストログイン</button>
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
        userLoginFlg: false
      }
    },
    mounted: function () {
      this.userAuthentication();
    },
    methods: {
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
      userAuthentication: function () {
        if (!localStorage.getItem('access-token')) {
          this.userLoginFlg = false
        } else {
          this.userLoginFlg = true
        }
      }
    }
  }
</script>

<style scoped>
h1 {
  font-size: 6vw;
}

h3 {
  font-size: 4vw;
}

@media (min-width: 640px) {
  h1 {
    font-size: 45px;
  }
  h3 {
    font-size: 30px;
  }
}

button {
  margin-top: 20px;
}

#top {
  height: 400px;
}

#title-content {
  margin-top: 100px;
}

@media (max-width: 400px) {
  #top {
    height: 300px;
  }
  #title-content {
    margin-top: 60px;
  }
}

#app-summary {
  background-color: #fffffe;
}

#app-function {
  height: auto;
}

#closing {
  height: 150;
  margin-bottom: 50px;
}

#closing-content {
  margin-top: 30px;
}

#app-summary .card {
  margin-bottom: 0;
}

#app-summary .card-body {
  padding-bottom: 0;
}

#app-summary img {
  float: left;
  width: 20px;
  height: 20px;
  margin-right: 5px;
}

#app-function .card-header {
  border-bottom: none;
}

#app-function .card-body {
  margin-top: 0;
}

#app-function p {
  font-size: 2vw;
}

@media (min-width: 640px) {
  #app-function p {
    font-size: 16px;
  }
}

#app-function img {
  width: 100%;
  height: 100%;
  border-radius: 10px;
}

#closing p {
  font-size: 2vw;
}

@media (min-width: 640px) {
  #closing p {
    font-size: 16px;
  }
}

</style>