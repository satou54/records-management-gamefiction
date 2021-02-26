<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>マイページ</h1>
          </div>
          <div class="card-body">
            <div class="card-text user-info">
              <p>名前：{{ name }}</p>
              <p>level: {{ level }}</p>
            </div>
            <div class="card-text">
              <table class="table table-borderless">
                <thead>
                  <tr>
                    <th scope="col">タスク名</th>
                    <th scope="col">1週間の目標</th>
                    <th scope="col">今週の実績</th>
                    <th scope="col">達成率(%)</th>
                </tr>
                </thead>
                <tbody>
                  <tr v-for="referenceData in referencesData" :key="referenceData.id" scope="row">
                    <td>{{ referenceData.task }}</td>
                    <td>{{ referenceData.total_goal }} {{ referenceData.unit }}</td>
                    <td>{{ referenceData.total_action }} {{referenceData.unit }}</td>
                    <td>{{ referenceData.achievement_rate }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="card-text mx-auto text-center">
              <router-link to="/tasks">目標設定</router-link>
              <router-link to="/action_records">行動記録</router-link>
              <router-link to="/action_records/references">行動参照</router-link>
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
        name: localStorage.getItem('name'),
        level: '',
        referencesData: [],
        headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
      }
    },
    mounted: function () {
      this.fetchReferencesData();
      this.fetchUserLevel();
    },
    methods: {
      fetchReferencesData: function () {
        axios.get('/api/action_records/actionRecordReferences', 
                  { params: { interval: "thisWeek" },
                    headers: this.headers
                  }
      ).then((response) => {
        this.referencesData.splice(0)
        for(var i = 0; i <response.data.references_data.length; i++) {
            this.referencesData.push(response.data.references_data[i]);
        }
      }, (error) => {
        console.log(error);
      });
      },
      fetchUserLevel: function () {
        axios.get('/api/user_levels',
                  { params: { user_id: localStorage.getItem('user_id') },
                    headers: this.headers
                  }
        ).then((response) => {
          this.level = response.data.user_level.level
        }, (error) => {
          console.log(error)
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

<style scoped>
.user-info p {
  padding-left: 20px;
}
</style>