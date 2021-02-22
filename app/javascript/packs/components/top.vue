<template>
  <div>
    <div class="jumbotron test">
      <div class="container-fluid">
        <div class="row">
          <p>アプリ名</p>
          <p>目標設定×行動記録×ゲームフィケーションで習慣をつくろう</p>
          <p>jumbotronを使って背景に画像入れる</p>
          <p>アプリ名とコメントを真ん中に配置</p>
        </div>
      </div>
    </div>
    <div class="content1-wrapper">
      <div class="container-fluid">
        <div class="row">
          <p>アプリ説明</p>
          <p>アプリ概要</p>
          <p></p>
        </div>
      </div>
    </div>
    <div class="content2-wrapper">
      <div class="container-fluid">
        <div class="row">
          <p>目標設定</p>
        </div>
        <div class="row">
          <p>行動記録</p>
        </div>
        <div class="row">
          <p>ゲームフィケーション</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
  }
</script>

<style scoped>
.test {
  height: 500px;
  margin-bottom: 0;
}
.top-wrapper {
  height: 500px;
  background-color: lightgreen;
}
.content1-wrapper {
  height: 500px;
  background-color: lightpink;
}
.content2-wrapper {
  height: 500px;
  background-color: lightskyblue;
}
</style>