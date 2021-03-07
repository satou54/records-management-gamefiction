<template>
  <div class="container">
    <div class="row justify-content-center mt-5">
      <div class="col-md-10">
        <div class="card">
          <div class="card-header text-center">
            <h1>行動参照</h1>
          </div>
          <div class="card-body">
            <div class="card-text">
              <div class="center-block text-center cp_ipselect cp_sl01">
                <label for="interval">期間:</label>
                <select id="interval" class="interval-list" @change="getReferencesData" v-model="interval">
                  <option value="thisMonth" selected>今月</option>
                  <option value="lastMonth">先月</option>
                  <option value="lastThreeMonth">過去3ヶ月</option>
                  <option value="lastSixMonth">過去6ヶ月</option>
                </select>
              </div>
            </div>
            <div class="card-text">
              <table class="table table-borderless">
                <thead>
                  <tr>
                    <th scope="col">習慣</th>
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
import axios from "axios"

export default {
  data: function () {
    return {
      interval: 'thisMonth',
      referencesData: []
    }
  },
  mounted: function () {
    this.getReferencesData();
  },
  methods: {
    getReferencesData: function () {
      axios.get('/api/action_records/actionRecordReferences', 
                { params: { interval: this.interval } }        
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

<style scoped>
/* セレクトメニュー */
.interval-list {
  cursor: pointer;
  text-overflow: ellipsis;
  outline: none;
  appearance: none;
  border: 1px solid #272343;
  border-radius: 2px;
  padding: 1px 15px 1px 15px;
  color: #272343;
}
</style>