<template>
  <div id="main-container">
    <div class="logo"></div>
    <div class="banner"></div>
    <ul class="panel-list">
      <li class="panel-bg">
        <p>Whitelist Dedicated to MINT users.</p>
        <div class="connect" @click="showDialog({ id: 'connect' })"></div>
      </li>
      <li class="panel-bg">
        <p>Common whitelist.</p>
        <div class="mint"></div>
      </li>
      <li class="panel-bg">
        <p>Creator Collaborator whitelist</p>
        <div class="mint"></div>
      </li>
    </ul>
  </div>
  <Dialog v-model="dialog.visible" width="auto" :title="dialog.title">
    <!--  连接    -->
    <DialogConnect
      style="width: 856px"
      v-if="dialog.id === 'connect'"
      @hideDialog="hideDialog"
    ></DialogConnect>
  </Dialog>
</template>

<script setup>
import initMapDialog from "@/components/dialog";
import DialogConnect from "./Connect.vue";
// 弹窗相关
const { dialog, showDialog, Dialog } = initMapDialog();
// 隐藏弹窗
const hideDialog = () => {
  dialog.visible = false;
};
</script>

<style scoped lang="scss">
#main-container {
  background-image: url("@/assets/web/main-bg-1920.png");
  background-position: center 0;
  background-repeat: no-repeat;
  background-size: cover;
  height: 100%;
  padding: 30px 0;
  > .logo {
    background: url("@/assets/web/logo.png") 0 0 no-repeat;
    width: 88px;
    height: 91px;
    margin: 0 auto;
  }
  > .banner {
    background: url("@/assets/web/whitelist-top-bg.png") center 100% no-repeat;
    height: 410px;
  }
  > .panel-list {
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    > li {
      width: 392px;
      height: 380px;
      padding: 30px;
      margin: 0 20px;
      > p {
        height: 133px;
        margin: 30px auto;
        font-size: 36px;
        font-family: MontserratAlternates-BlackItalic, MontserratAlternates;
        text-align: center;
      }
      > .connect {
        background: url("@/assets/web/whitelist-connect.png") 0 0 no-repeat;
        width: 272px;
        height: 70px;
        line-height: 70px;
        margin: 0 auto;
        cursor: pointer;
      }
      > .mint {
        background: url("@/assets/web/whitelist-mint.png") 0 0 no-repeat;
        width: 272px;
        height: 70px;
        line-height: 70px;
        margin: 0 auto;
        cursor: pointer;
      }
    }
  }
}
</style>
