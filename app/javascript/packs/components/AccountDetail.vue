<template>
  <div>
    <h1>ユーザ詳細画面</h1>
    <div>
      <label id="name">名前：</label>
      <output id="name">名前</output>
      <output>修正</output>
    </div>
    <div>
      <label id="email">メールアドレス：</label>
      <output id="email">メールアドレス</output>
      <output>修正</output>
    </div>
    <div>
      <label>パスワード：</label>
      <output>パスワード変更</output>
    </div>
    <button>設定</button>
    <br>
    <router-link to="/mypage">マイページ</router-link>
  </div>
</template>