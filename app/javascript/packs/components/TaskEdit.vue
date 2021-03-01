<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>習慣編集画面</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <div class="form-group row">
                <label for="task" class="col-md-4 col-form-label text-md-right">習慣</label>
                <input type="text" id="task" class="form-control col-md-6" v-model="task" placeholder="習慣">
                <span v-if="!validationTask" class="col-md-6 offset-md-4 text-warning">{{ taskValidateMessage }}</span>
              </div>
              <div class="form-group row">
                <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                <input type="text" id="goal" class="form-control col-md-6" v-model="goal" placeholder="目標">
                <span v-if="!validationGoal" class="col-md-6 offset-md-4 text-warning">{{ goalValidateMessage }}</span>
              </div>
              <div class="form-group row">
                <label for="unit" class="col-md-4 col-form-label text-md-right">目標の単位</label>
                <input type="text" id="unit" class="form-control col-md-6" v-model="unit" placeholder="例)km、分">
                <span v-if="!!taskEditValidateMessage" class="col-md-6 offset-md-4 text-warning">{{ taskEditValidateMessage }}</span>
                <span v-if="!!taskEditSuccessMessage" class="mt-3 mb-0 mx-auto alert alert-primary">{{ taskEditSuccessMessage }}</span>
              </div>
              <div class="row">
                <button class="btn btn-primary mt-1 mx-auto d-block" :disabled="!validation" v-on:click="updateTask">目標修正</button>
              </div>
            </div>
            <div class="card-text mx-auto text-center">
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
      userId: '',
      taskValidateMessage: '',
      goalValidateMessage: '',
      taskEditValidateMessage: '',
      taskEditSuccessMessage: ''
    }
  },
  mounted: function () {
    this.fetchTasks();
  },
  computed: {
    validation: function () {
      return (this.validationTask && this.validationGoal)
    },
    validationTask: function () {
      if (!this.task) {
        this.taskValidateMessage = '習慣が空です。'
        return false
      }
      return true
    },
    validationGoal: function () {
      if (!this.goal) {
        this.goalValidateMessage = '目標が空です。'
        return false
      } else if (!(/^\d+?(\.\d+)?$/).test(this.goal)) {
        this.goalValidateMessage = '目標は半角数字で入力してください。'
        return false
      }
      return true
    }
  },
  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks/' + this.id, 
                { headers: this.headers }
      ).then((response) => {
        this.task = (response.data.task['task']);
        this.goal = (response.data.task['goal']);
        this.unit = (response.data.task['unit']);
        this.userId = (response.data.task['user_id']);
      }, (error) => {
        console.log(error);
      });
    },
    updateTask: function () {
      axios.put('/api/tasks/' + this.id, 
                { task: { task: this.task, goal: this.goal, unit: this.unit, user_id: this.userId } }, 
                { headers: this.headers }
      ).then((response) => {
        this.taskEditSuccessMessage = '習慣を編集しました'
        this.taskEditValidateMessage = ''
      }, (error) => {
        console.log(error);
        if (error.response.data && error.response.data.errors) {
          var errors = error.response.data.errors
          if (!!errors['task']) {
            this.taskValidateMessage = errors['task'][0]
          } else if (!!errors['goal']) {
            this.goalValidateMessage = errors['goal'][0]
          }
        } else {
          this.taskEditValidateMessage = '習慣の修正に失敗しました。'
        }
      });
    }
  }
}
</script>
