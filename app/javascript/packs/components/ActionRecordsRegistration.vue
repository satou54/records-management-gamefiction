<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>行動記録</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <form>
                <div class="form-group row">
                  <label for="action_day" class="col-md-4 col-form-label text-md-right">日付</label>
                  <input type="date" id="action_day" class="form-control col-md-6" @change="chengeDate" v-model="ActionDay">
                  <span v-if="!validationActionDay" class="col-md-6 offset-md-4 text-warning">{{ actionDayValidateMessage }}</span>
                </div>
                <div class="form-group row">
                  <label for="task" class="col-md-4 col-form-label text-md-right">習慣</label>
                  <select id="task" class="form-control col-md-6" v-model="selectTask" @change="chengeTask" name="selectTask">
                    <option v-for="task in tasks" :key="task.id" v-bind:value="task.id">{{ task.task }}</option>
                  </select>
                  <span v-if="!validationTask" class="col-md-6 offset-md-4 text-warning">{{ taskValidateMessage }}</span>
                </div>
                <div class="form-group row">
                  <label for="goal" class="col-md-4 col-form-label text-md-right">1週間の目標</label>
                  <output id="goal" class="form-control col-md-6">{{ goal }} {{ unit }}</output>
                </div>
                <div class="form-group row">
                  <label for="action" class="col-md-4 col-form-label text-md-right">実績</label>
                  <input type="text" id="action" class="form-control col-md-6" v-model="action">
                  <span v-if="!validationAction" class="col-md-6 offset-md-4 text-warning">{{ actionValidateMessage }}</span>
                  <span v-if="!!actionRecordValidateMessage" class="col-md-6 offset-md-4 text-warning">{{ actionRecordValidateMessage }}</span>
                </div>
                <div class="row">
                      <button class="btn btn-primary mt-1 mx-auto d-block" :disabled="!validation" @click="createActionRecord">登録</button>
                </div>
              </form>
              <div class="card-text mx-auto text-center">
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
        selectTask: '',
        goal: '',
        unit: '',
        ActionRecords: [],
        ActionDay: '',
        action: '',
        action_experience_point: '',
        actionDayValidateMessage: '',
        taskValidateMessage: '',
        actionValidateMessage: '',
        actionRecordValidateMessage: ''
      }
    },
    mounted: function () {
      this.getToday();
      this.fetchTasks();
      this.fetchActionRecord();
    },
    computed: {
      validation: function () {
        return (this.validationActionDay && this.validationTask && this.validationAction)
      },
      validationActionDay: function () {
        if (!this.ActionDay) {
          this.actionDayValidateMessage = '日付が入力されていません。'
          return false
        }
        return true
      },
      validationTask: function () {
        if (!this.selectTask) {
          this.taskValidateMessage = '習慣が選択されていません。'
          return false
        }
        return true
      },
      validationAction: function () {
        if (!this.action) {
          this.actionValidateMessage = '実績が入力されていません。'
          return false
        } else if (!(/^\d+?(\.\d+)?$/).test(this.action)) {
          this.actionValidateMessage = '実績は半角数字で入力してください。'
          return false
        }
        return true
      }
    },
    methods: {
      getToday: function () {
        var today = new Date();
        today.setDate(today.getDate());
        var yyyy = today.getFullYear();
        var mm = ("0" + (today.getMonth() + 1)).slice(-2);
        var dd = ("0" + today.getDate()).slice(-2);
        this.ActionDay = yyyy + '-' + mm+'-' + dd;
      },
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
      fetchActionRecord: function () {
        axios.get('/api/action_records', 
                  { headers: this.headers }
        ).then((response) => {
          for(var i = 0; i < response.data.action_records.length; i++) {
            this.ActionRecords.push(response.data.action_records[i]);
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
            this.unit = this.tasks[i].unit
          }
        }
        this.searchAction();
      },
      searchAction: function () {
        this.action = ''

        for (var i = 0; i < this.ActionRecords.length; i++) {
          if (this.ActionRecords[i].action_day == this.ActionDay
              && this.ActionRecords[i].task_id == this.selectTask
              && this.ActionRecords[i].user_id == localStorage.getItem('user_id')) {
            this.action = this.ActionRecords[i].action
          }
        }
      },
      culculateActionExperiencePoint: function () {
        this.action_experience_point = (Math.round(this.action * 100) / 100) / (Math.round(this.goal * 100) / 100) * 100
      },
      createActionRecord: function () {
        this.culculateActionExperiencePoint();
        axios.post('/api/action_records/createOrUpdate', 
                  { action_record: { action_day: this.ActionDay, action: Number(this.action), 
                    action_experience_point: this.action_experience_point, user_id: localStorage.getItem('user_id'), task_id: this.selectTask }},
                  { headers: this.headers }
        ).then((response) => {
          alert('登録しました。')
        }, (error) => {
          console.log(error)
          if (error.response.data && error.response.data.errors) {
            var errors = error.response.data.errors
            if (!!errors['action_day']) {
              this.actionDayValidateMessage = this.errors = errors['action_day'][0]
            } else if (!!errors['action']) {
              this.actionValidateMessage = errors['action'][0]
            }
          } else {
            this.actionRecordValidateMessage = '登録に失敗しました。'
          }
        })
      }
    }
  }
</script>