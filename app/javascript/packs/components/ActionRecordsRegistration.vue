<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>行動記録</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <div class="form-group row">
                <label for="action_day" class="col-md-4 col-form-label text-md-right">日付</label>
                <input type="date" id="action_day" class="form-control col-md-6" @change="chengeDate" v-model.trim="ActionDay">
                <span v-if="!validationActionDay" class="col-md-6 offset-md-4 text-warning">{{ actionDayValidateMessage }}</span>
              </div>
              <div class="form-group row">
                <label for="task" class="col-md-4 col-form-label text-md-right">習慣</label>
                <select id="task" class="form-control col-md-6" v-model.trim="selectTask" @change="chengeTask" name="selectTask">
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
                <input type="text" id="action" class="form-control col-md-6" v-model.trim.number="action">
                <span v-if="!validationAction" class="col-md-6 offset-md-4 text-warning">{{ actionValidateMessage }}</span>
                <span v-if="!!actionRecordValidateMessage" class="col-md-6 offset-md-4 text-warning">{{ actionRecordValidateMessage }}</span>
                <span v-if="!!actionRecordSuccessMessage" class="mt-3 mb-0 mx-auto alert alert-primary">{{ actionRecordSuccessMessage }}</span>
              </div>
              <div class="row">
                    <button class="btn btn-primary my-1 mx-auto d-block" :disabled="!validation" @click="registerActionRecord(); progressBarModalPosition()" data-toggle="modal" data-target="#progress-bar-modal" data-backdrop="false">登録</button>
              </div>
              <div class="mx-auto text-center">
                <router-link to="/mypage">マイページ</router-link>
              </div>
            </div>
            <div class="modal col-12" id="progress-bar-modal" tabindex="-1" role="dialog" aria-labelledby="basic-modal" aria-hidden="true">
              <div class="modal-dialog modal-xl mx-auto">
                <div class="modal-content">
                  <div class="modal-body">
                    <button type="button" class="close" aria-label="Close" data-dismiss="modal">
                      <span aria-hidden="true">&times;</span>
                    </button>
                    <div class="col-12" id="progress-content">
                        <label for="progress-bar" class="text-center">Level: {{ before_level }}</label>
                        <progress v-bind:value="state" max="100" class="text-center">{{ state }}%</progress>
                    </div>
                  </div>
                </div>
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
        actionRecordId: '',
        action_experience_point: '',
        updateFlg: false,
        actionDayValidateMessage: '',
        taskValidateMessage: '',
        actionValidateMessage: '',
        actionRecordValidateMessage: '',
        actionRecordSuccessMessage: '',
        startState: '',
        before_level: '',
        after_level: '',
        state: '',
        endState: '',
        intervalId: '',
        stateFlg: ''
      }
    },
    mounted: function () {
      this.getToday()
      this.fetchTasks()
      this.fetchActionRecord()
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
        var today = new Date()
        today.setDate(today.getDate())
        var yyyy = today.getFullYear()
        var mm = ("0" + (today.getMonth() + 1)).slice(-2)
        var dd = ("0" + today.getDate()).slice(-2)
        this.ActionDay = yyyy + '-' + mm+'-' + dd
      },
      fetchTasks: function () {
        axios.get('/api/tasks', 
                  { headers: this.headers }
        ).then((response) => {
          for(var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i])
          }
        }, (error) => {
          console.log(error)
        });
      },
      fetchActionRecord: function () {
        axios.get('/api/action_records', 
                  { headers: this.headers }
        ).then((response) => {
          for(var i = 0; i < response.data.action_records.length; i++) {
            this.ActionRecords.push(response.data.action_records[i])
          }
        }, (error) => {
          console.log(error)
        })
      },
      chengeDate: function () {
        if (this.selectTask) {
          this.searchAction()
        }
      },
      chengeTask: function () {
        for (var i = 0; i < this.tasks.length; i++) {
          if (this.tasks[i].id == this.selectTask) {
            this.goal = this.tasks[i].goal
            this.unit = this.tasks[i].unit
          }
        }
        this.searchAction()
      },
      searchAction: function () {
        this.action = ''
        this.updateFlg = false

        for (var i = 0; i < this.ActionRecords.length; i++) {
          if (this.ActionRecords[i].action_day == this.ActionDay
              && this.ActionRecords[i].task_id == this.selectTask
              && this.ActionRecords[i].user_id == localStorage.getItem('user_id')) {
            this.actionRecordId = this.ActionRecords[i].id
            this.action = this.ActionRecords[i].action
            this.updateFlg = true
          }
        }
      },
      culculateActionExperiencePoint: function () {
        this.action_experience_point = (Math.round(this.action * 100) / 100) / (Math.round(this.goal * 100) / 100) * 100
      },
      registerActionRecord: function () {
        this.culculateActionExperiencePoint()

        if (this.updateFlg) {
          this.updateActionRecord()
        } else {
          this.createActionRecord()
          this.updateFlg = true
        }
      },
      createActionRecord: function () {
        axios.post('/api/action_records', 
                  { action_record: { action_day: this.ActionDay, action: Number(this.action), 
                    action_experience_point: this.action_experience_point, user_id: localStorage.getItem('user_id'), task_id: this.selectTask }},
                  { headers: this.headers }
        ).then((response) => {
          this.actionRecordSuccessMessage = '行動を記録しました'
          this.actionRecordValidateMessage = ''
          this.actionRecordId = response.data.level_up_data['action_record_id']
          this.before_level = response.data.level_up_data['before_level']
          this.after_level = response.data.level_up_data['after_level']
          this.state = response.data.level_up_data['before_experience_point_percent']
          this.endState = response.data.level_up_data['after_experience_point_percent']

          this.updateLevel()
          this.fetchActionRecord()
        }, (error) => {
          console.log(error)
          this.actionRecordSuccessMessage = ''
          this.actionRecordValidateMessage = '登録に失敗しました'
          if (error.response.data && error.response.data.errors) {
            var errors = error.response.data.errors
            if (!!errors['action_day']) {
              this.actionRecordValidateMessage = errors['action_day'][0].replace('Action_day', '日付')
            } else if (!!errors['action']) {
              this.actionRecordValidateMessage = errors['action'][0].replace('Action', '実績')
            }
          }
        })
      },
      updateActionRecord: function () {
        axios.put('/api/action_records/' + this.actionRecordId, 
                  { action_record: { id: this.actionRecordId, action_day: this.ActionDay, action: Number(this.action), 
                    action_experience_point: this.action_experience_point, user_id: localStorage.getItem('user_id'), task_id: this.selectTask } },
                  { headers: this.headers }
        ).then((response) => {
          this.actionRecordSuccessMessage = '行動を記録しました'
          this.actionRecordValidateMessage = ''
          this.before_level = response.data.level_up_data['before_level']
          this.after_level = response.data.level_up_data['after_level']
          this.state = response.data.level_up_data['before_experience_point_percent']
          this.endState = response.data.level_up_data['after_experience_point_percent']

          this.updateLevel()
          this.fetchActionRecord()
        }, (error) => {
          console.log(error)
          this.actionRecordSuccessMessage = ''
          this.actionRecordValidateMessage = '登録に失敗しました'
          if (error.response.data && error.response.data.errors) {
            var errors = error.response.data.errors
            if (!!errors['action_day']) {
              this.actionRecordValidateMessage = errors['action_day'][0].replace('Action_day', '日付')
            } else if (!!errors['action']) {
              this.actionRecordValidateMessage = errors['action'][0].replace('Action', '実績')
            }
          }
        })
      },
      updateLevel: function () {
        if (this.after_level - this.before_level == 0) {
            // レベルアップ・ダウンなしの場合
            if (this.endState > this.state) {
              this.stateFlg = true
            } else {
              this.stateFlg = false
            }
            this.intervalId = setInterval(this.updateProgress, 30)
          } else if (this.after_level - this.before_level > 0) {
            // レベルアップありの場合
            this.stateFlg = true
            this.intervalId = setInterval(this.updateProgressLevelUp, 30)
          } else {
            // レベルダウンの場合
            this.stateFlg = false
            this.intervalId = setInterval(this.updateProgressLevelDown, 30)
          }
      },
      updateProgress: function () {
        if (this.stateFlg) {
          this.state += 1
        } else {
          this.state -= 1
        }

        if (this.state == this.endState) {
          clearInterval(this.intervalId)
        }
      },
      updateProgressLevelUp: function () {
        this.state += 1
        
        if (this.state == 100) {
          this.state = 0
          this.before_level += 1

          if (this.after_level == this.before_level) {
            clearInterval(this.intervalId)
            this.intervalId = setInterval(this.updateProgress, 30)
          }
        }

      },
      updateProgressLevelDown: function () {
        this.state -= 1

        if (this.state == 0) {
          this.state = 100
          this.before_level -= 1
          
          if (this.after_level == this.before_level) {
            clearInterval(this.intervalId)
            this.intervalId = setInterval(this.updateProgress, 30)
          }
        }
      },
      progressBarModalPosition: function () {
        var windowHeight = window.innerHeight
        document.getElementById('progress-bar-modal').style.top = (windowHeight - 94) + 'px'
      }
    }
  }
</script>

<style scoped>
.modal {
  top: auto
}

progress {
  width: 80%;
  margin-top: 5px;
  float: left;
}

#progress-content label {
  float: left;
  margin-right: 5px;
}
</style>