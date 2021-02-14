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
            <button @click="editLink(task.id)">修正</button>
            <button @click="deleteTask(task.id)">削除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <router-link to="/task/new">new</router-link>
    <router-link to="/">マイページ</router-link>
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
        axios.get('/api/tasks', 
                  { headers: {
                    'access-token': localStorage.getItem('access-token'),
                    uid: localStorage.getItem('uid'),
                    client: localStorage.getItem('client') 
                  }}
        ).then((response) => {
          for(var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      deleteTask: function (task_id) {
        const params = { id: task_id }
        axios.delete('/api/tasks/' + task_id, { params: params }).then((response) => {
          location.reload();
        }, (error) => {
          console.log(error);
        })
      },
      editLink: function (task_id) {
        this.$router.push({
          name: 'task-edit',
          params: { id: task_id }
        })
      }
    }
  }
</script>