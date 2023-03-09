<template>
  <div id="main-container">
    <header>
      <div class="logo"></div>
    </header>
    <div class="banner"></div>
    <ul class="panel-list">
      <li class="panel-bg">
        <p>Whitelist Dedicated to MINT users.</p>
        <div class="button-box">
          <div
            v-if="account === null"
            class="connect"
            @click="showDialog({ id: 'connect' })"
          >
            CONNECT
          </div>
          <div v-else class="account-wrap">
            <span :title="account">{{ account }}</span>
            <img
              class="account"
              :src="getAssetsFile('web/account.png')"
              alt=""
            />
            <img
              class="logout"
              :src="getAssetsFile('web/logout.png')"
              alt=""
              @click="disconnectWallet"
            />
          </div>
        </div>
      </li>
      <li class="panel-bg">
        <p>Common whitelist.</p>
        <div class="mint" @click="normalWhiteListMint">MINT</div>
      </li>
      <li class="panel-bg">
        <p>Creator Collaborator whitelist</p>
        <div class="mint" @click="devWhiteListMint">MINT</div>
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
    <!--  错误    -->
    <DialogError
      style="width: 856px"
      v-if="dialog.id === 'error'"
      @hideDialog="hideDialog"
    ></DialogError>
  </Dialog>
</template>

<script setup>
import { onMounted } from "vue";
import { getAssetsFile } from "@/utils/tools";
import abi from "@/utils/NaughtyHamsterNFT.json";
import { ethers } from "ethers";
import whiteList from "@/utils/whiteList.json";
import initMapDialog from "@/components/dialog";
import DialogConnect from "./Connect.vue";
import DialogError from "./Error.vue";
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
const { setAccount } = userStore;

// Wallet connection logic
const isWalletConnected = async () => {
  try {
    const { ethereum } = window;

    const accounts = await ethereum.request({ method: "eth_accounts" });
    console.log("accounts: ", accounts);

    if (accounts.length > 0) {
      setAccount(accounts[0]);
      console.log("wallet is connected! " + account);
      console.log("wallet is connected! " + account.value);
    } else {
      console.log("make sure MetaMask is connected");
    }
  } catch (error) {
    console.log("error: ", error);
  }
};

// 登出
const disconnectWallet = async () => {
  setAccount(null);
};

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
    const claimingAddr = keccak256(account.value);
    var hexProof = merkletree.getHexProof(claimingAddr);
    return hexProof;
    // return merkletree.getHexProof(claimingAddr);
  } catch (error) {
    console.log(error);
  }
}

function inWhiteList(whiteList) {
  var addrList = Object.values(whiteList);
  for (var idx in addrList) {
    if (addrList[idx].toLowerCase() == account.value) {
      return true;
    }
  }
  return false;
}

const devWhiteListMint = async () => {
  try {
    const { ethereum } = window;

    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum, "any");

      let network = await provider.getNetwork()
      console.log("您当前所连接的以太坊网络为:", network.name, ", chainID:", network.chainId);
      if (network.name != "goerli") {
          console.error("请切换正确的以太坊网络！");
          return
      }

      const signer = provider.getSigner();
      const mintContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );

      if (!inWhiteList(whiteList.dev)) {
        showDialog({
          id: "error",
        });
        return;
      }

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
      
      let network = await provider.getNetwork()
      console.log("您当前所连接的以太坊网络为:", network.name, ", chainID:", network.chainId);
      if (network.name != "goerli") {
          console.error("请切换正确的以太坊网络！");
          return
      }

      const signer = provider.getSigner();
      const mintContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );

      if (!inWhiteList(whiteList.normal)) {
        showDialog({
          id: "error",
        });
        return;
      }

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

// 页面加载完成时执行
onMounted(() => {
  // 判断登录状态
  isWalletConnected();
});
</script>

<style scoped lang="scss">
#main-container {
  background-image: url("@/assets/web/main-bg-1920.png");
  background-position: center 0;
  background-repeat: no-repeat;
  background-size: cover;
  height: 100%;
  padding: 30px 0;
  header {
    position: relative;
    width: 1440px;
    height: 91px;
    margin: 0 auto;
    overflow: hidden;

    > .logo {
      background: url("@/assets/web/logo.png") 0 0 no-repeat;
      position: absolute;
      top: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 88px;
      height: 91px;
    }
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
      > .button-box {
        width: 272px;
        margin: 0 auto;
        font-size: 18px;
        > .connect {
          background: url("@/assets/web/connect.png") 0 0 no-repeat;
          background-size: contain;
          width: 100%;
          height: 70px;
          line-height: 70px;
          padding-left: 50px;
          color: #ffffff;
          font-size: 27px;
          cursor: pointer;
        }
        > .account-wrap {
          background: #febb9e;
          display: flex;
          flex-flow: row nowrap;
          justify-content: space-between;
          align-items: center;
          width: 100%;
          height: 70px;
          line-height: 70px;
          border-radius: 26px;
          padding-left: 25px;
          padding-right: 6px;

          > span {
            width: 150px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
          }

          > .logout {
            cursor: pointer;
          }
        }
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
