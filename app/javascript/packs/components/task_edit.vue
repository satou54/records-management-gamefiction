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
                <div class="form-group row">
                  <label for="goal" class="col-md-4 col-form-label text-md-right">目標</label>
                  <input id="goal" class="form-control col-md-6" v-model="goal" placeholder="目標">
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
      task: '',
      goal: '',
      user_id: ''
    }
  },
  mounted: function () {
    this.fetchTasks();
  },
  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks/' + this.id, 
                { headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                } }
      ).then((response) => {
        this.task = (response.data.task['task']);
        this.goal = (response.data.task['goal']);
        this.user_id = (response.data.task['user_id'])
      }, (error) => {
        console.log(error);
      });
    },
    updateTask: function () {
      axios.put('/api/tasks/' + this.id, 
                { task: { task: this.task, goal: this.goal, user_id: this.user_id } }, 
                { headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                } }
      ).then((response) => {
        alert('修正しました。')
      }, (error) => {
        console.log(error);
      });
    }
  }
}
</script>