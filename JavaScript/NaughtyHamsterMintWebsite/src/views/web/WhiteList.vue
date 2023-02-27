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
        <div class="mint" @click="normalWhiteListMint">MINT*1</div>
      </li>
      <li class="panel-bg">
        <p>Creator Collaborator whitelist</p>
        <div class="mint" @click="devWhiteListMint">MINT*10</div>
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
import abi from "@/utils/NaughtyHamsterNFT.json";
import { ethers } from "ethers";
import whiteList from "@/utils/whiteList.json";
import initMapDialog from "@/components/dialog";
import DialogConnect from "./Connect.vue";
import { storeToRefs } from "pinia";
import { useAccountStore } from "@/stores/account";
import { MerkleTree } from "merkletreejs/dist/index";
// 弹窗相关
const { dialog, showDialog, Dialog } = initMapDialog();

// Contract Address & ABI
const contractAddress = "0x0CD057EC2f2D56b0A8d4881022Bf409d1Cc129Ba";
const contractABI = abi.abi;
const keccak256 = window.keccak256;

// 获取状态
const userStore = useAccountStore();
const { account } = storeToRefs(userStore);
// const { setAccount } = userStore;

// 隐藏弹窗
const hideDialog = () => {
  dialog.visible = false;
};

function getDevProof(whitelist) {
  try {
    const leafNodes = whitelist.map((addr) => keccak256(addr));
    const merkletree = new MerkleTree(leafNodes, keccak256, {
      sortPairs: true,
    });
    const claimingAddr = keccak256(account);
    return merkletree.getHexProof(claimingAddr);
  } catch (error) {
    console.log(error);
  }
}

const devWhiteListMint = async () => {
  try {
    const { ethereum } = window;

    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum, "any");
      const signer = provider.getSigner();
      const mintContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );

      const proof = getDevProof(whiteList.dev);

      const whiteListMintTxn = await mintContract.whiteListMint(1, proof);

      await whiteListMintTxn.wait();

      console.log("dev mined ", whiteListMintTxn.hash);

      console.log("dev whiteListMint finished!");
    }
  } catch (error) {
    console.log(error);
  }
};

const normalWhiteListMint = async () => {
  try {
    const { ethereum } = window;

    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum, "any");
      const signer = provider.getSigner();
      const mintContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );

      const proof = getDevProof(whiteList.normal);

      const whiteListMintTxn = await mintContract.whiteListMint(1, proof);

      await whiteListMintTxn.wait();

      console.log("normal mined ", whiteListMintTxn.hash);

      console.log("normal whiteListMint finished!");
    }
  } catch (error) {
    console.log(error);
  }
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
        background: linear-gradient(270deg, #29e1f9 0%, #aaeca6 100%);
        width: 272px;
        height: 70px;
        line-height: 70px;
        margin: 0 auto;
        border-radius: 35px;
        font-size: 27px;
        font-weight: 600;
        text-align: center;
        cursor: pointer;
      }
    }
  }
}
</style>
