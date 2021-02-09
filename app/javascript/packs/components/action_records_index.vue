<template>
  <div>
    <h1>行動記録画面</h1>
    <label id="action_day">日付</label>
    <input type="date" id="action_day" v-model="action_day">
    <table>
      <thead>
        <tr>
          <td>タスク名</td>
          <td>目標</td>
          <td>実績</td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="task in tasks" v-bind:key="task.id">
          <td>{{ task.task }}</td>
          <td>{{ task.goal }}</td>
          <td>{{ action }}</td>
          <td>
            <button @click="editLink(task.id)">修正</button>
          </td>
        </tr>
      </tbody>
    </table>
    <router-link to="/action-records/new">new</router-link>
    <router-link to="/">マイページ</router-link>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function () {
      return {
        tasks: [],
        action_records: [],
        action_day: '',
        action: ''
      }
    },
    mounted: function () {
      this.getToday();
      this.fetchTasks();
      this.fetchActionRecord();
    },
    methods: {
      getToday: function () {
        var today = new Date();
        today.setDate(today.getDate());
        var yyyy = today.getFullYear();
        var mm = ("0" + (today.getMonth() + 1)).slice(-2);
        var dd = ("0" + today.getDate()).slice(-2);
        this.action_day = yyyy + '-' + mm+'-' + dd;
      },
      fetchTasks: function () {
        axios.get('/api/tasks').then((response) => {
          for(var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      fetchActionRecord: function () {
        axios.get('/api/action_records').then((response) => {
          for(var i = 0; i < response.data.action_records.length; i++) {
            this.action_records.push(response.data.action_records[i]);
          }
        }, (error) => {
          console.log(error);
        })
      },
      /* searchActionRecord: function() {
        for (var i = 0; i < this.action_records.length; i++) {
          var action_record = this.action_records[i]
          console.log('action_record:' + action_record)
          console.log('action_day:' + action_record.action_day)
          if (action_record.action_day == this.action_day &&
              action_record.task_id == 1) {
            this.action = action_record.action
          }
        }
      }, */
      editLink: function (task_id) {
        this.$router.push({
          name: 'task-edit',
          params: { id: task_id }
        })
      }
    }
  }
</script>