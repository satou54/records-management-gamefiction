import Vue from 'vue/dist/vue.esm.js'
import router from './router/router'
import Header from './components/header.vue'

router.beforeEach((to, from, next) => {
    // isPublicでない場合(=認証が必要な場合)、かつ、ローカルストレージにアクセストークンを保持していない場合
    if (to.matched.some(record => !record.meta.isPublic) && !localStorage.getItem('access-token')) {
      next({ path: '/login', query: { redirect: to.fullPath }});
    } else {
      next();
    }
});

var app = new Vue ({
  router,
  el: '#app',
  components: {
    'navbar' :Header,
  }
});