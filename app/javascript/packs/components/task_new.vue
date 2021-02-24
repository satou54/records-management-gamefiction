<template>
  <div>
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-10">
          <div class="card">
            <div class="card-header">
              <h1 class="text-md-center">タスク新規作成</h1>
            </div>
            <div class="card-body">
              <div class="card-text">
                <form>
                  <div class="form-group row">
                      <label for="task" class="col-md-4 col-form-label text-md-right">タスク</label>
                      <input id="task" class="form-control col-md-6" v-model="task" placeholder="タスク">
                  </div>
                  <div v-if="taskValidate">
                    <p class="alert alert-danger">{{ taskValidate }}</p>
                  </div>
                  <div class="from-group row">
                    <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                    <input id="goal" class="form-control col-md-6" v-model="goal" placeholder="目標">
                  </div>
                  <div v-if="goalValidate">
                    <p class="alert alert-danger">{{ goalValidate }}</p>
                  </div>
                  <div class="from-group row">
                    <label for="unit" class="col-md-4 col-form-label text-md-right">目標の単位</label>
                    <input id="unit" class="form-control col-md-6" v-model="unit" placeholder="目標">
                  </div>
                  <div v-if="taskNewValidate">
                    <p class="alert alert-danger">{{ taskNewValidate }}</p>
                  </div>
                  <div class="row">
                    <div class="col-md-8 offset-md-4 justify-content-center">
                      <button class="btn btn-primary mt-1" v-on:click="createTask">新規作成</button>
                    </div>
                  </div>
                </form>
              </div>
              <div class="card-text row">
                <router-link to="/tasks">目標設定画面</router-link>
                <router-link to="/mypage">マイページ</router-link>
              </div>
            </div>
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
      headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
      task: '',
      goal: '',
      unit: '',
      taskNewflg: false,
      taskValidate: '',
      goalValidate: '',
      taskNewValidate: ''
    }
  },
  methods: {
    createTask: function () {
      this.taskNewflg = false
      this.taskValidate = ''
      this.goalValidate = ''
      this.taskNewValidate = ''

      if (!this.task) {
        this.taskValidate = 'タスクが空です'
      } else {
        this.taskNewflg = true
      }

      if (!this.goal) {
        this.goalValidate = '目標が空です。'
        this.taskNewflg = false
      } else if (!(/^\d+?(\.\d+)?$/).test(this.goal)) {
        this.goalValidate = '目標は半角数字で入力してください。'
        this.taskNewflg = false
      }

      if (this.taskNewflg) {
        axios.post('/api/tasks', 
                  { task: { task: this.task, goal: this.goal, unit: this.unit, user_id: localStorage.getItem('user_id') } }, 
                  { headers: this.headers }
        ).then((response) => {
          alert('新規登録しました。')
        }, (error) => {
          console.log(error);
          this.taskNewValidate = 'タスクの登録に失敗しました。'
        });
      }
    }
  }
}
</script>