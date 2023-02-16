<template>
    <div id="main-container">
        <nav>
            <div class="nav-top">
                <div class="nav-icon"></div>
            </div>
            <ul>
                <li
                        v-if="account === null"
                        class="connect"
                        @click="showDialog({ id: 'connect' })"
                >
                    CONNECT
                </li>
                <li v-else class="account-wrap">
                    <span>{{ account }}</span>
                    <img class="account" :src="getAssetsFile('web/account.png')" alt=""/>
                    <img
                            class="logout"
                            :src="getAssetsFile('web/logout.png')"
                            alt=""
                            @click="disconnectWallet"
                    />
                </li>
                <li><a href="#mint">MINT</a></li>
                <li><a href="#road-map">Road Map</a></li>
                <li><a href="#faq">FAQ</a></li>
                <li><a href="#">Twitter</a></li>
                <li><a href="#">Discord</a></li>
            </ul>
        </nav>
        <header>
            <img
                class="animate-left-icon"
                :src="getAssetsFile('web/animate-left-icon.png')"
                alt=""
            />
            <img
                class="animate-right-icon"
                :src="getAssetsFile('web/animate-right-icon.png')"
                alt=""
            />
            <section class="title">
                <h3>Naughty Hamster is a freehand<span class="nfts"></span></h3>
                <h4>Living on the Ethereum blockchain</h4>
            </section>
            <section class="content">
                <ul class="left-list">
                    <li>
                        <div class="label">Styles</div>
                        <div class="count">5000</div>
                    </li>
                    <li>
                        <div class="label">Themes</div>
                        <div class="count">11</div>
                    </li>
                    <li>
                        <div class="label">Expressions</div>
                        <div class="count">20</div>
                    </li>
                    <li>
                        <div class="label">Features</div>
                        <div class="count">120</div>
                    </li>
                </ul>
                <div class="right-content">
                    <p>
                        Naughty Hamster is the 1st generation of Naughty Group which take
                        aims at building an IP universe.
                    </p>
                    <div class="progress-box">
                        <div class="label">Chain:Ethereum</div>
                        <div class="progress">
                            <div
                                class="progress-stick"
                                :style="{
                  marginLeft: '-' + progressMargin + 'px',
                }"
                            ></div>
                            <div class="progress-text">
                                {{ totalSupply + ":" + mintMaxSize }}
                            </div>
                        </div>
                    </div>
                    <div class="price-box">
                        <span class="add" @click="handleCount('add')"></span>
                        <input
                            class="count"
                            type="text"
                            v-model="count"
                            @input="
                (e) => {
                  count = e.target.value.replace(/[^\d]/g, '');
                }
              "
                        />
                        <span class="reduce" @click="handleCount('reduce')"></span>
                        <span id="mint" @click="publicMint"></span>
                    </div>
                </div>
            </section>
        </header>
    </div>
    <el-backtop :right="100" :bottom="100"/>
    <Dialog v-model="dialog.visible" width="auto" :title="dialog.title">
        <!--  连接    -->
        <DialogConnect
                style="width: 856px"
                v-if="dialog.id === 'connect'"
        ></DialogConnect>
        <!--  错误    -->
        <DialogError
                style="width: 856px"
                v-if="dialog.id === 'error'"
        ></DialogError>
    </Dialog>
</template>

<script setup>
import {ref, computed, onMounted} from "vue";
import {getAssetsFile, copyHandle} from "@/utils/tools";
import abi from "@/utils/NaughtyHamsterNFT.json";
import {ethers} from "ethers";
import {useAccountStore} from "@/stores/account";
import { getTotalSupply } from "@/api";
import initMapDialog from "@/components/dialog";
import DialogConnect from "@/views/Connect.vue";
import DialogError from "@/views/Error.vue";
// 弹窗相关
const {dialog, showDialog, Dialog} = initMapDialog();

// 计数器
const count = ref(1);
// 进度条读数
const totalSupply = ref(1);
const mintMaxSize = ref(5000);

// Contract Address & ABI
const contractAddress = "0x0CD057EC2f2D56b0A8d4881022Bf409d1Cc129Ba";
const contractABI = abi.abi;

// 获取状态
const {account, setAccount} = useAccountStore();

// 进度条
const progress = async () => {
  try {
    //
    let provider = ethers.getDefaultProvider("goerli");
    console.log(provider)
    let contract = new ethers.Contract(contractAddress, contractABI, provider);
    console.log(contract)
    
    // totalSupply.value = await getTotalSupply();
    totalSupply.value = await mintContract.totalSupply();
  } catch (error) {
    console.log(error);
  }
};
const progressMargin = computed(() => {
    return (1 - totalSupply.value / mintMaxSize.value) * 412;
});

// Wallet connection logic
const isWalletConnected = async () => {
    try {
        const {ethereum} = window;

        const accounts = await ethereum.request({method: "eth_accounts"});
        console.log("accounts: ", accounts);

        if (accounts.length > 0) {
            const account = accounts[0];
            setAccount(account);
            console.log("wallet is connected! " + account);
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

// mint计数
const handleCount = (action) => {
    if (action === "add") {
        count.value++;
    } else if (action === "reduce") {
        if (count.value > 0) {
            count.value--;
        }
    }
};

// 付费mint(0.01ETH)
const publicMint = async () => {
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

      const publicMintTxn = await mintContract.publicMint(1, {
        value: parseEther((count.value * 0.01).toString()),
      });

      await publicMintTxn.wait();

      console.log("public mined ", publicMintTxn.hash);

      console.log("publicMint finished!");
    }
  } catch (error) {
    console.log(error);
    showDialog({
      id: "error",
    });
  }
};

// 页面加载完成时执行
onMounted(() => {
    // 判断登录状态
    isWalletConnected();
    // 获取进度
    progress();
});
</script>
<script lang="ts" setup></script>

<style scoped lang="scss">
#main-container {
  background-image: url("@/assets/web/main-bg-1920.png");
  background-position: center 0;
  background-repeat: no-repeat;
  background-size: cover;

  nav {
    background: #ffffff;

    .nav-top {
      background: url("@/assets/web/logo.png") center center no-repeat;
      background-size: 37px 38px;
      display: flex;
      flex-flow: column nowrap;
      justify-content: center;
      align-items: flex-end;
      height: 60px;

      > .nav-icon {
        width: 30px;
        height: 30px;
        border-top-width: 2px;
        border-right-width: 0;
        border-bottom-width: 2px;
        border-left-width: 0;
        border-style: solid;
        border-color: #000000;
        margin-right: 26px;
      }
    }

    ul {
      display: flex;
      flex-flow: column nowrap;
      align-items: center;

      > li {
        margin-bottom: 20px;
        font-size: 18px;
        font-weight: 600;

        &.connect {
          background: url("@/assets/web/connect.png") 0 0 no-repeat;
          width: 193px;
          height: 50px;
          line-height: 50px;
          padding-left: 35px;
          color: #ffffff;
          font-size: 18px;
          cursor: pointer;
        }

        &.account-wrap {
          background: #febb9e;
          display: flex;
          flex-flow: row nowrap;
          justify-content: space-between;
          align-items: center;
          width: 216px;
          height: 50px;
          line-height: 50px;
          border-radius: 26px;
          padding-left: 25px;
          padding-right: 6px;
          font-size: 14px;

          > span {
            width: 95px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
          }

          > .logout {
            cursor: pointer;
          }
        }
      }
    }
  }

  > header {
    position: relative;
    width: 100%;

    .animate-left-icon {
      position: absolute;
      top: 30px;
      left: 0;
      width: 74px;
    }

    .animate-right-icon {
      position: absolute;
      top: 0;
      right: 0px;
      width: 79px;
    }

    > section.title {
      > h3 {
        margin: 34px 0;
        text-align: center;
        font-family: "MontserratAlternates-BlackItalic";
        font-weight: normal;
        font-size: 32px;

        .nfts {
          display: inline-block;
          background: url("@/assets/web/nfcs.png") 0 0 no-repeat;
          background-size: contain;
          width: 63px;
          height: 38px;
          margin-left: 15px;
          vertical-align: middle;
        }
      }

      > h4 {
        margin: 0 0 65px 0;
        text-align: center;
        font-family: "MontserratAlternates-BlackItalic";
        font-weight: normal;
        font-size: 40px;
      }
    }

    > section.content {

      .left-list {
        display: flex;
        flex-flow: row wrap;
        align-content: space-between;

        > li {
          width: 50%;

          .label {
            font-size: 28px;
            font-weight: 600;
          }

          .count {
            font-family: Saira-Black;
            font-size: 66px;
            font-weight: 900;
          }
        }
      }

      .right-content {
        display: flex;
        flex-flow: column nowrap;
        width: 640px;

        > p {
          margin: 0 0 50px;
          font-size: 36px;
          font-weight: 600;
        }

        .progress-box {
          display: flex;
          flex-flow: row nowrap;
          align-items: center;
          margin-bottom: 22px;

          .label {
            margin-right: 20px;
            font-size: 28px;
            font-weight: 600;
          }

          .progress {
            background: #fde6d0;
            position: relative;
            display: inline-block;
            width: 412px;
            height: 40px;
            line-height: 40px;
            border-radius: 40px;
            text-align: center;
            overflow: hidden;

            > .progress-stick {
              background: url("@/assets/web/progress-stick.png") 0 center no-repeat;
              background-size: auto 100%;
              width: 100%;
              height: 100%;
              border-radius: 40px;
            }

            > .progress-text {
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              font-size: 28px;
              font-weight: 900;
            }
          }
        }

        .price-box {
          background: url("@/assets/web/price-box.png") 0 0 no-repeat;
          position: relative;
          height: 104px;

          .add {
            position: absolute;
            top: 31px;
            left: 38px;
            display: inline-block;
            width: 40px;
            height: 40px;
            cursor: pointer;
          }

          .count {
            background: none;
            position: absolute;
            top: 31px;
            left: 95px;
            display: inline-block;
            width: 129px;
            height: 40px;
            line-height: 40px;
            border: none;
            text-align: center;
            font-size: 28px;
            font-weight: 900;
            outline: none;
          }

          .reduce {
            position: absolute;
            top: 31px;
            left: 242px;
            display: inline-block;
            width: 40px;
            height: 40px;
            cursor: pointer;
          }

          #mint {
            float: right;
            width: 320px;
            height: 100%;
            cursor: pointer;
          }
        }
      }
    }
  }
}
</style>
