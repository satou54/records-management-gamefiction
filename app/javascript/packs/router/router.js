import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
import TaskIndex from '../components/task_index.vue'
import TaskNew from '../components/task_new.vue'
import TaskEdit from '../components/task_edit.vue'

Vue.use(VueRouter)

export default new VueRouter ({
  mode: 'history',
  routes: [
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
      component: TaskEdit
    }
  ]
})