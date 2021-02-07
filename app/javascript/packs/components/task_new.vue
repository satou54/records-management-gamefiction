<template>
  <div>
    <h1>目標新規作成画面</h1>
    <div>
      <div>
        <label id="task">タスク</label>
        <input id="task" v-model="task" placeholder="タスク">
      </div>
      <div>
        <label id="goal">目標</label>
        <input id="goal" v-model="goal" placeholder="目標">
      </div>
      <div>
        <button v-on:click="createTask">新規作成</button>
      </div>
    </div>
    <router-link to="/tasks">目標設定画面</router-link>
    <router-link to="/">マイページ</router-link>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data: function () {
    return {
      task: '',
      goal: ''
    }
  },
  methods: {
    createTask: function () {
      console.log('createTask')
      axios.post('/api/tasks', { task: { task: this.task, goal: this.goal, user_id: 2 } }).then((response) => {
        console.log('新規作成OK')
      }, (error) => {
        console.log(error);
      });
    }
  }
}
</script>