<template>
  <section class="main-content">
    <h3>SORRY</h3>
    <p>
      Please go to the website on PC for wallet login, or open the current web
      page in the built-in browser of Metamask APP to login
    </p>
    <a
      class="button"
      href="https://metamask.io/"
      target="_blank"
      @click="emit('hideDialog')"
      ><img :src="getAssetsFile('mobile/install.png')" alt="" />MetaMask</a
    >
  </section>
</template>

<script setup>
import { getAssetsFile } from "@/utils/tools";
const emit = defineEmits(["hideDialog"]);
</script>

<style scoped lang="scss">
.main-content {
  text-align: center;
  h3 {
    background: url("@/assets/web/error.png") 0 center no-repeat;
    background-size: 40px 40px;
    display: inline-block;
    padding-left: 60px;
    margin: 0;
    font-size: 36px;
    font-family: MontserratAlternates-BlackItalic;
    font-weight: normal;
  }
  > p {
    font-size: 21px;
  }
  .button {
    background: linear-gradient(90deg, #ea5cff 0%, #fb9b33 100%);
    display: block;
    width: 308px;
    height: 62px;
    line-height: 62px;
    margin: 20px 0 30px;
    font-size: 21px;
    color: #ffffff;
    text-align: center;
    cursor: pointer;
    > img {
      margin-right: 20px;
      vertical-align: text-top;
    }
  }
}
</style>
