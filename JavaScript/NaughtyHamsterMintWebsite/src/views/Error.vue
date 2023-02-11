<template>
  <section class="main-content">
    <h3>SORRY</h3>
    <p>At this stage,only whitelisted users can participate in MINT.</p>
    <p>Official opening date:    December  20,  2023</p>
    <div class="button" href="#">OK</div>
  </section>
</template>

<script lang="ts">
export default {
  name: "Connect"
}
</script>
<script lang="ts" setup>

</script>

<style scoped lang="scss">
.main-content {
  text-align: center;
  h3 {
    background: url("@/assets/web/error.png") 0 center no-repeat;
    background-size: 40px 40px;
    display: inline-block;
    padding-left: 60px;
    margin: 0 0 20px;
    font-size: 36px;
    font-family: MontserratAlternates-BlackItalic;
    font-weight: normal;
  }
  .button {
    background: #000000;
    display: inline-block;
    width: 212px;
    height: 62px;
    line-height: 62px;
    margin: 20px 0 50px;
    font-size: 21px;
    color: #ffffff;
    text-align: center;
    cursor: pointer;
  }
}
</style>