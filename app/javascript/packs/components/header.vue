<template>
  <nav class="navbar navbar-expand-sm navbar-dark bg-primary">
    <a href="#" class="navbar-brand">Navbar</a>
    <button class="navbar-toggler" type="button"
        data-toggle="collapse"
        data-target="#navmenu1"
        aria-controls="navmenu1"
        aria-expanded="false"
        aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navmenu1">
    <div class="navbar-nav">
      <router-link to="/" class="nav-item nav-link text-white">TOP</router-link>
      <router-link to="/login" class="nav-item nav-link text-white">ログイン</router-link>
      <router-link to="/signup" class="nav-item nav-link text-white">新規登録</router-link>
      <router-link to="/mypage" class="nav-item nav-link text-white">マイページ</router-link>
      <router-link to="/logout" class="nav-item nav-link text-white">ログアウト</router-link>
    </div>
  </div>
  </nav>
</template>