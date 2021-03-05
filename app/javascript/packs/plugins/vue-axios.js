const VueAxiosPlugin = {}
export default VueAxiosPlugin.install = function(Vue, { axios }) {
  const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  
  if (localStorage.getItem('access-token')) {
    axios.defaults.headers.common = {
      "X-Requested-With": "XMLHttpRequest",
      "X-CSRF-Token": csrf_token,
      "access-token": localStorage.getItem('access-token'),
      "uid": localStorage.getItem('uid'),
      "client": localStorage.getItem('client')
    }
  } else {
    axios.defaults.headers.common = {
      "X-Requested-With": "XMLHttpRequest",
      "X-CSRF-Token": csrf_token
    }
  }

  Vue.axios = axios
  Object.defineProperties(Vue.prototype, {
    axios: {
      get () {
        return axios
      }
    }
  })
}