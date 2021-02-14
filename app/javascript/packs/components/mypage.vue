<template>
  <div>
    <h1>マイページ</h1>
    <p>ユーザ名：</p>
    <p>level:</p>

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
          </td>
        </tr>
      </tbody>
    </table>

    <div>
      <router-link to="/tasks">目標設定</router-link>
      <router-link to="/action_records">行動記録</router-link>
      <router-link to="/aciton_record/show">行動参照</router-link>
    </div>
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
      editLink: function (task_id) {
        this.$router.push({
          name: 'task-edit',
          params: { id: task_id }
        })
      }
    }
  }
</script>