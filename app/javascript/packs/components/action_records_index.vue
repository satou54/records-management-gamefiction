<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header">
            <h1 class="text-md-center">行動記録</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <form>
                <div class="form-group row">
                  <label for="action_day" class="col-md-4 col-form-label text-md-right">日付</label>
                  <input type="date" id="action_day" class="form-control col-md-6" @change="chengeDate" v-model="action_day">
                </div>
                <div class="form-group row">
                  <label for="task" class="col-md-4 col-form-label text-md-right">タスク</label>
                  <select id="task" class="form-control col-md-6" v-model="selectTask" @change="chengeTask" name="selectTask">
                    <option v-for="task in tasks" :key="task.id" v-bind:value="task.id">{{ task.task }}</option>
                  </select>
                </div>
                <div class="form-group row">
                  <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                  <output id="goal" class="form-control col-md-6">{{ goal }}</output>
                </div>
                <div class="form-group row">
                  <label for="action" class="col-md-4 col-form-label text-md-right">実績</label>
                  <input type="text" id="action" class="form-control col-md-6" v-model="action">
                </div>
                <div class="row">
                  <div class="col-md-8 offset-md-4 justify-content-center">
                    <button class="btn btn-primary mt-1" @click="createActionRecord">登録</button>
                  </div>
                </div>
              </form>
              <div class="card-text row">
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
        selectTask: '',
        goal: '',
        action_records: [],
        action_day: '',
        action: '',
        action_experience_point: ''
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
      culculateActionExperiencePoint: function () {
        this.action_experience_point = (Math.round(this.action * 100) / 100) / (Math.round(this.goal * 100) / 100) * 100
      },
      createActionRecord: function () {
        this.culculateActionExperiencePoint();
        axios.post('/api/action_records/createOrUpdate', 
                  { action_record: { action_day: this.action_day, action: Number(this.action), 
                    action_experience_point: this.action_experience_point, user_id: localStorage.getItem('user_id'), task_id: this.selectTask }},
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