<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header">
            <h1 class="text-md-center">行動参照</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <div class="center-block">
                <label for="interval">期間:</label>
                <select id="interval" class="interval_list"  v-model="interval">
                  <option value="thisMonth" selected>今月</option>
                  <option value="lastMonth">先月</option>
                  <option value="lastThreeMonth">過去3ヶ月</option>
                  <option value="lastSixMonth">過去6ヶ月</option>
                </select>
                <button class="btn btn-primary mb-1 ml-1" @click="getReferencesData">参照</button>
              </div>
            </div>
            <div class="card-text">
              <table class="table">
                <thead>
                  <tr>
                    <th scope="col">タスク名</th>
                    <th scope="col">期間内の総目標</th>
                    <th scope="col">期間内の総実績</th>
                    <th scope="col">達成率(%)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="referenceData in referencesData" :key="referenceData.id" scope="row">
                    <td>{{ referenceData.task }}</td>
                    <td>{{ referenceData.total_goal }} {{ referenceData.unit }}</td>
                    <td>{{ referenceData.total_action }} {{ referenceData.unit }}</td>
                    <td>{{ referenceData.achievement_rate }}</td>
                  </tr>
                </tbody>
              </table>
              <div class="card-text mx-auto">
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
import axios from "axios"

export default {
  data: function () {
    return {
      interval: 'thisMonth',
      headers: {
                  'access-token': localStorage.getItem('access-token'),
                  uid: localStorage.getItem('uid'),
                  client: localStorage.getItem('client') 
                },
      referencesData: []
    }
  },
  mounted: function () {
    this.getReferencesData();
  },
  methods: {
    getReferencesData: function () {
      axios.get('/api/action_records/actionRecordReferences', 
                { params: { interval: this.interval },
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
    }
  }
}
</script>