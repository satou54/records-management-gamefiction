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
        <input type="text" id="action" v-model="action">
      </div>
      <button @click="createActionRecord">登録</button>
    </div>
    <router-link to="/mypage">マイページ</router-link>
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
      fetchActionRecord: function () {
        axios.get('/api/action_records', 
                  { headers: {
                    'access-token': localStorage.getItem('access-token'),
                    uid: localStorage.getItem('uid'),
                    client: localStorage.getItem('client') 
                  }}
        ).then((response) => {
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
        this.action = ''

        for (var i = 0; i < this.action_records.length; i++) {
          if (this.action_records[i].action_day == this.action_day
              && this.action_records[i].task_id == this.selectTask
              && this.action_records[i].user_id == localStorage.getItem('user_id')) {
            this.action = this.action_records[i].action
          }
        }
      },
      createActionRecord: function () {
        axios.post('/api/action_records/createOrUpdate', 
                  { action_record: { action_day: this.action_day, action: Number(this.action), 
                    action_experience_point: 10, user_id: localStorage.getItem('user_id'), task_id: this.selectTask }},
                  { headers: {
                    'access-token': localStorage.getItem('access-token'),
                    uid: localStorage.getItem('uid'),
                    client: localStorage.getItem('client') 
                  }}
        ).then((response) => {
          alert('登録しました。')
        }, (error) => {
          console.log(error)
        })
      }
    }
  }
</script>