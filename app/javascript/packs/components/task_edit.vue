<template>
  <div>
    <h1>目標修正画面</h1>
    <div >
      <div>
        <label id="task">タスク</label>
        <input id="task" v-model="task" placeholder="タスク">
      </div>
      <div>
        <label id="goal">目標</label>
        <input id="goal" v-model="goal" placeholder="目標">
      </div>
      <div>
        <button v-on:click="updateTask">目標修正</button>
      </div>
    </div>
    <router-link to="/tasks">目標設定画面</router-link>
    <router-link to="/">マイページ</router-link>
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
      axios.get('/api/tasks/' + this.id).then((response) => {
        this.task = (response.data.task['task']);
        this.goal = (response.data.task['goal']);
        this.user_id = (response.data.task['user_id'])
      }, (error) => {
        console.log(error);
      });
    },
    updateTask: function () {
      axios.put('/api/tasks/' + this.id, { task: { task: this.task, goal: this.goal, user_id: this.user_id } }).then((response) => {
        console.log('目標修正OK')
      }, (error) => {
        console.log(error);
      });
    }
  }
}
</script>