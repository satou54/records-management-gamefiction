<template>
  <div>
    <h1>タスク設定画面</h1>
    <table>
      <thead>
        <tr>
          <td>タスク名</td>
          <td>目標</td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="task in tasks" v-bind:key="task.id">
          <td>{{ task.task }}</td>
          <td>{{ task.goal }}</td>
          <td>
            <router-link to="/task/edit">edit</router-link>
          </td>
        </tr>
      </tbody>
    </table>
    <router-link to="/task/new">new</router-link>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function () {
      return {
        tasks: [],
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks').then((response) => {
          for(var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
    }
  }
</script>