<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header">
            <h1 class="text-md-center">タスク設定</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <table class="table">
                <thead>
                  <tr>
                    <th scope="col">タスク名</th>
                    <th scope="col">1週間の目標</th>
                    <th scope="col"></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="task in tasks" v-bind:key="task.id" scope="row">
                    <td>{{ task.task }}</td>
                    <td>{{ task.goal }} {{ task.unit }}</td>
                    <td>
                      <button class="btn btn-primary" @click="editLink(task.id)">修正</button>
                      <button class="btn btn-primary" @click="deleteTask(task.id)">削除</button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div class="card-text mx-auto">
                <router-link to="/task/new">new</router-link>
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
  import axios from 'axios';

  export default {
    data: function () {
      return {
        tasks: [],
        headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                }
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks', 
                  { headers: this.headers }
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