import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
import Top from '../components/TopPage.vue'
import Mypage from '../components/UserMyPage.vue'
import SignUp from '../components/UserSignUp.vue'
import Login from '../components/UserLogin.vue'
import Account from '../components/AccountDetail.vue'
import TaskIndex from '../components/TaskIndex.vue'
import TaskNew from '../components/TaskNew.vue'
import TaskEdit from '../components/TaskEdit.vue'
import ActionRecordsRegistration from '../components/ActionRecordsRegistration.vue'
import ActionRecordsReferences from '../components/ActionRecordsReferences.vue'

Vue.use(VueRouter)

export default new VueRouter ({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Top,
      meta: { isPublic: true }
    },
    {
      path: '/signup',
      component: SignUp,
      meta: { isPublic: true }
    },
    {
      path: '/login',
      component: Login,
      meta: { isPublic: true }
    },
    {
      path: '/account',
      component: Account
    },
    {
      path: '/mypage',
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
      component: ActionRecordsRegistration
    },
    {
      path: '/action_records/references',
      component: ActionRecordsReferences
    }
  ]
})