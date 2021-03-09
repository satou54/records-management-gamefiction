<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>習慣設定</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <table class="table table-borderless">
                <thead>
                  <tr>
                    <th scope="col">習慣</th>
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
                      <button class="btn btn-warning" @click="deleteTask(task.id)" onclick="return confirm('削除しますか?')">削除</button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div class="task-error text-center">
                <span v-if="!!taskErrorMessage" class="text-center">{{ taskErrorMessage }}</span>
              </div>
              <div class="card-text mx-auto text-center">
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
        headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
        tasks: [],
        taskErrorMessage: ''
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
        axios.delete('/api/tasks/' + task_id, 
                    { data: {id: task_id}, 
                      headers: this.headers 
                    }
        ).then((response) => {
          location.reload();
        }, (error) => {
          console.log(error);
          this.taskErrorMessage = "習慣の削除に失敗しました。"
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