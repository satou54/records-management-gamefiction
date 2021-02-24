<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header">
            <h1 class="text-md-center">タスク修正画面</h1>
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
                <div class="form-group row">
                  <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                  <input id="goal" class="form-control col-md-6" v-model="goal" placeholder="目標">
                </div>
                <div v-if="taskValidate">
                  <p class="alert alert-danger">{{ goalValidate }}</p>
                </div>
                <div class="form-group row">
                  <label for="unit" class="col-md-4 col-form-label text-md-right">目標の単位</label>
                  <input id="unit" class="form-control col-md-6" v-model="unit" placeholder="目標">
                </div>
                <div class="row">
                  <div class="col-md-8 offset-md-4 justify-content-center">
                    <button class="btn btn-primary mt-1" v-on:click="updateTask">目標修正</button>
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
</template>

<script>
import axios from 'axios'

export default {
  props: {
    id: ''
  },
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
      user_id: '',
      taskEditFlg: '',
      taskValidate: '',
      goalValidate: '',
      taskEditValidate: ''
    }
  },
  mounted: function () {
    this.fetchTasks();
  },
  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks/' + this.id, 
                { headers: this.headers }
      ).then((response) => {
        this.task = (response.data.task['task']);
        this.goal = (response.data.task['goal']);
        this.unit = (response.data.task['unit']);
        this.user_id = (response.data.task['user_id']);
      }, (error) => {
        console.log(error);
      });
    },
    updateTask: function () {
      this.taskEditFlg = false
      this.taskValidate = false
      this.goalValidate = false
      this.taskEditValidate = false

      if (!this.task) {
        this.taskValidate = 'タスクが空です。'
      } else {
        this.taskEditFlg = true
      }

      if (!this.goal) {
        this.goalValidate = '目標が空です。'
        this.taskEditFlg = false
      } else if (!(/^\d+?(\.\d+)?$/).test(this.goal)) {
        this.goalValidate = '目標は半角数字で入力してください。'
        this.taskEditFlg = false
      }

      if (this.taskEditFlg) {
        axios.put('/api/tasks/' + this.id, 
                  { task: { task: this.task, goal: this.goal, unit: this.unit, user_id: this.user_id } }, 
                  { headers: this.headers }
        ).then((response) => {
          alert('修正しました。')
        }, (error) => {
          console.log(error);
          if (error.response.data && error.response.data.errors) {
            var errors = error.response.data.errors
            if (!!errors['task']) {
              this.taskValidate = this.errors = errors['task'][0]
            } else if (!!errors['goal']) {
              this.goalValidate = errors['goal'][0]
            }
          } else {
            this.taskEditValidate = 'タスクの修正に失敗しました。'
          }
        });
      }
    }
  }
}
</script>