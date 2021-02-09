import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
import Mypage from '../components/mypage.vue'
import TaskIndex from '../components/task_index.vue'
import TaskNew from '../components/task_new.vue'
import TaskEdit from '../components/task_edit.vue'
import ActionRecordsIndex from '../components/action_records_index.vue'

Vue.use(VueRouter)

export default new VueRouter ({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Mypage
    },
    {
      path: '/tasks',
      component: TaskIndex
    },
    {
      path: '/task/new/',
      component: TaskNew
    },
    {
      path: '/task/:id/edit',
      name: "task-edit",
      props: true,
      component: TaskEdit
    },
    {
      path: '/action_records',
      component: ActionRecordsIndex
    }
  ]
})