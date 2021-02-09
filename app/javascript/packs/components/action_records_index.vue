<template>
  <div>
    <h1>行動記録画面</h1>
    <div>
      <div>
        <label id="action_day">日付</label>
        <input type="date" id="action_day" @change="chengeDate" v-model="action_day">
      </div>
      <div>
        <label id="task">タスク</label>
        <select id="task" v-model="selectTask" @change="chengeTask" name="selectTask">
          <option v-for="task in tasks" :key="task.id" v-bind:value="task.id">{{ task.task }}</option>
        </select>
      </div>
      <div>
        <label id="goal">目標</label>
        <output id="goal">{{ goal }}</output>
      </div>
      <div>
        <label id="action">実績</label>
        <input type="text" id="action" v-bind:value="action">
      </div>
      <button>送信</button>
    </div>
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
        selectTask: '',
        goal: '',
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
      chengeDate: function () {
        if (this.selectTask) {
          this.searchAction();
        }
      },
      chengeTask: function () {
        for (var i = 0; i < this.tasks.length; i++) {
          if (this.tasks[i].id == this.selectTask) {
            this.goal = this.tasks[i].goal
          }
        }
        this.searchAction();
      },
      searchAction: function () {
        for (var i = 0; i < this.action_records.length; i++) {
          if (this.action_records[i].action_day == this.action_day
              && this.action_records[i].task_id == this.selectTask) {
            this.action = this.action_records[i].action
          }
        }
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