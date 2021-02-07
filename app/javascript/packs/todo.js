import Vue from 'vue/dist/vue.esm.js'
import router from './router/router'
import Header from './components/header.vue'

var app = new Vue ({
  router,
  el: '#app',
  components: {
    'navbar' :Header,
  }
});