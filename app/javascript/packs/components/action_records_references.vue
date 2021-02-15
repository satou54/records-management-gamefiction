<template>
  <div>
    <h1>行動参照</h1>
    <label id="interval">期間</label>
    <select class="interval_list"  v-model="interval">
      <option value="thisMonth" selected>今月</option>
      <option value="lastMonth">先月</option>
      <option value="lastThreeMonth">過去3ヶ月</option>
      <option value="lastSixMonth">過去6ヶ月</option>
    </select>
    <button @click="getReferencesData">参照</button>
    <table>
      <thead>
        <tr>
          <th>タスク名</th>
          <th>期間内の総目標</th>
          <th>期間内の総実績</th>
          <th>達成率(%)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="reference_data in references_data" :key="reference_data.id">
          <td>{{ reference_data.task }}</td>
          <td>{{ reference_data.total_goal }}</td>
          <td>{{ reference_data.total_action }}</td>
          <td>{{ reference_data.achievement_rate }}</td>
        </tr>
      </tbody>
    </table>
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
      references_data: []
    }
  },
  mounted: function () {
    this.getReferencesData();
  },
  methods: {
    getReferencesData: function () {
      axios.get('/api/action_records/actionRecordReferences', 
                { params: { interval: this.interval } ,
                  headers: this.headers
                }
      ).then((response) => {
        this.references_data.splice(0)
        for(var i = 0; i <response.data.references_data.length; i++) {
            this.references_data.push(response.data.references_data[i]);
        }
      }, (error) => {
        console.log(error);
      });
    }
  }
}
</script>