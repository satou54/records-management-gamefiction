<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1 >習慣新規作成</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <div class="form-group row">
                  <label for="task" class="col-md-4 col-form-label text-md-right">習慣</label>
                  <input type="text" id="task" class="form-control col-md-6" v-model.trim="task" placeholder="習慣">
                  <span v-if="!validationTask" class="col-md-6 offset-md-4 text-warning">{{ taskValidateMessage }}</span>
              </div>
              <div class="from-group row">
                <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                <input type="text" id="goal" class="form-control col-md-6" v-model.trim="goal" placeholder="目標">
                <span v-if="!validationGoal" class="col-md-6 offset-md-4 text-warning">{{ goalValidateMessage }}</span>
              </div>
              <div class="from-group row">
                <label for="unit" class="col-md-4 col-form-label text-md-right">目標の単位</label>
                <input type="text" id="unit" class="form-control col-md-6" v-model.trim="unit" placeholder="例)km、分">
                <span v-if="!!taskNewValidateMessage" class="mt-3 mb-0 mx-auto alert alert-danger">{{ taskNewValidateMessage }}</span>
                <span v-if="!!taskNewSuccessMessage" class="mt-3 mb-0 mx-auto alert alert-primary">{{ taskNewSuccessMessage }}</span>
              </div>
              <div class="row">
                <button class="btn btn-primary mt-1 mx-auto d-block" :disabled="!validation" v-on:click="createTask">新規作成</button>
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
      taskValidateMessage: '',
      goalValidateMessage: '',
      taskNewValidateMessage: '',
      taskNewSuccessMessage: ''
    }
  },
  computed: {
    validation: function () {
      return (this.validationTask && this.validationGoal)
    },
    validationTask: function () {
      if (!this.task) {
        this.taskValidateMessage = '習慣が空です。'
        return false
      } else if (this.task.length > 30) {
        this.taskValidateMessage = '習慣は30文字以内で入力してください'
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
    createTask: function () {
      axios.post('/api/tasks', 
                { task: { task: this.task, goal: this.goal, unit: this.unit, user_id: localStorage.getItem('user_id') } }, 
                { headers: this.headers }
      ).then((response) => {
        alert('新規登録しました。')
        this.taskValidateMessage = ''
        this.taskNewSuccessMessage = '習慣を新規登録しました'
      }, (error) => {
        console.log(error);
        this.taskNewSuccessMessage = ''
        this.taskNewValidateMessage = '習慣の登録に失敗しました'
        if (error.response.data && error.response.data.errors) {
          var errors = error.response.data.errors
          if (!!errors['task']) {
            this.taskNewValidateMessage = errors['task'][0].replace('Task', '習慣')
          } else if (!!errors['goal']) {
            this.taskNewValidateMessage = errors['goal'][0].replace('Goal', '目標')
          }
        }
      });
    }
  }
}
</script>
<style scoped>
.row {
  margin-bottom: 10px;
}
</style>