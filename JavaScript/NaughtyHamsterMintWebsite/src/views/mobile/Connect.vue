<template>
  <section class="main-content">
    <h3>Connect to a wallet</h3>
    <a href="#" class="button" @click="connectWallet">Metamask</a>
  </section>
  <Dialog v-model="dialog.visible" width="auto" :title="dialog.title">
    <!--  连接钱包    -->
    <DialogWallet
      v-if="dialog.id === 'wallet'"
      @hideDialog="hideDialog"
    ></DialogWallet>
  </Dialog>
</template>

<script setup>
import initMapDialog from "@/components/dialog";
import DialogWallet from "@/views/mobile/Wallet.vue";
import { useAccountStore } from "@/stores/account";

// 弹窗相关
const { dialog, showDialog, Dialog } = initMapDialog();
const emit = defineEmits(["hideDialog"]);
// 获取状态
const { setAccount } = useAccountStore();
// 连接
const connectWallet = async () => {
  try {
    const { ethereum } = window;

    if (!ethereum) {
      showDialog({
        id: "wallet",
      });
      return;
    }

    const accounts = await ethereum.request({
      method: "eth_requestAccounts",
    });

    setAccount(accounts[0]);
    emit("hideDialog");
  } catch (error) {
    console.log(error);
  }
};

// 隐藏弹窗
const hideDialog = () => {
  dialog.visible = false;
};
</script>

<style scoped lang="scss">
.main-content {
  text-align: center;

  h3 {
    font-size: 36px;
    font-family: MontserratAlternates-BlackItalic;
    font-weight: normal;
  }

  .button {
    background: url("@/assets/web/fox.png") 50px center no-repeat #ffffff;
    display: inline-block;
    width: 324px;
    height: 96px;
    line-height: 96px;
    padding-right: 50px;
    border-radius: 8px;
    border: 4px solid #fb9b33;
    margin-bottom: 50px;
    font-size: 24px;
    text-align: right;
  }
}
</style>
