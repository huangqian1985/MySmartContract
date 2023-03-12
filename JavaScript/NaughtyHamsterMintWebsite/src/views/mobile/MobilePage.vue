<template>
  <div id="main-container">
    <nav>
      <div class="nav-top">
        <label for="burger" class="burger">
          <input
            id="burger"
            type="checkbox"
            @change="menuActive = !menuActive"
          />
          <span></span>
          <span></span>
          <span></span>
        </label>
      </div>
      <ul v-if="menuActive">
        <li
          v-if="account === null"
          class="connect"
          @click="showDialog({ id: 'connect' })"
        >
          CONNECT
        </li>
        <li v-else class="account-wrap">
          <span>{{ account }}</span>
          <img class="account" :src="getAssetsFile('web/account.png')" alt="" />
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
        <li>
          <a href="https://twitter.com/naughtyDAOweb3" target="_blank">Twitter</a>
        </li>
        <li>
          <a href="https://discord.gg/ErHRUU5eXd" target="_blank">Discord</a>
        </li>
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
      <section class="content" id="mint">
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
            <span class="text-underline">Naughty Hamster</span> is the 1st
            generation of
            <span class="text-underline">Naughty Group</span> which take aims at
            building an IP universe.
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
                  count = e.target.value.replace(/([^\d]|0)/g, '');
                }
              "
            />
            <span class="reduce" @click="handleCount('reduce')"></span>
            <span class="mint" @click="publicMint"></span>
          </div>
        </div>
      </section>
    </header>
    <div class="banner"></div>
    <main>
      <div id="road-map" class="road-map"></div>
      <ul class="road-map-content">
        <li>
          <div class="list-title active">Phase One</div>
          <div class="list-content">
            <div class="label one">Completed</div>
            <div clas="text">
              Publish 5000 NFT in different styles for sale.
            </div>
          </div>
        </li>
        <li>
          <div class="list-title active">Phase Two</div>
          <div class="list-content">
            <div class="label two">In progress</div>
            <div clas="text">
              Develop the marketplace with our followers and start a Naughty
              DAO.
            </div>
          </div>
        </li>
        <li>
          <div class="list-title">Phase Three</div>
          <div class="list-content">
            <div class="label three">Not started</div>
            <div clas="text">
              In collaboration with game、social、clothes、food.
            </div>
          </div>
        </li>
        <li>
          <div class="list-title">Phase Four</div>
          <div class="list-content">
            <div class="label four">Not started</div>
            <div clas="text">
              Create the latest series from Naughty universe, expand its
              boundaries into animation and movie.
            </div>
          </div>
        </li>
      </ul>
      <div id="faq" class="faq"></div>
      <ul class="faq-panels">
        <li class="panel-bg">
          <section>
            <div class="title">What is the Naughty hamster?</div>
            <div class="content">
              <p>
                Each Naughty Hamster is unique and programmatically generated
                from over 120possible traits, including expression, accessories,
                clothing and background.
              </p>
              <p>
                The Hamster are stored as ERC-721 tokens on the Ethereum
                blockchain and hosted on IPFS. The number is limited to 5000.
              </p>
              <p>Purchasing Naughty Hamster costs 0.01 ETH.</p>
            </div>
            <div class="bg-image"></div>
          </section>
        </li>
        <li class="panel-bg">
          <section>
            <div class="title">
              What are the benefits of the Naughty Hamster?
            </div>
            <div class="content">
              <p>
                Naughty Hamster owners can participate in exclusive clubs and
                areas of the Naughty DAO.
              </p>
              <p>
                When purchasing a Naughty Hamster, except getting the NFT, the
                holders become a member of the Naughty DAO, which includes the
                exclusive priority of participating in community activities,
                extra discount of Peripheral products, Airdrops of new IPs and
                more in future.
              </p>
              <ul>
                <li>
                  <div class="image"></div>
                  <div class="text">Community Activities</div>
                </li>
                <li>
                  <div class="image"></div>
                  <div class="text">IP Usufruct</div>
                </li>
                <li>
                  <div class="image"></div>
                  <div class="text">Community discount</div>
                </li>
                <li>
                  <div class="image"></div>
                  <div class="text">More in the future</div>
                </li>
              </ul>
            </div>
          </section>
        </li>
        <li class="panel-bg">
          <section>
            <div class="title">Where is the community entrance?</div>
            <div class="content">
              <p>
                You can follow Naughty DAO's twitter and join our discord to
                keep updated.
              </p>
              <div class="link-buttons">
                <a
                  href="https://twitter.com/naughtyDAOweb3"
                  class="twitter"
                  target="_blank"
                ></a>
                <a
                  href="https://discord.gg/ErHRUU5eXd"
                  class="discord"
                  target="_blank"
                ></a>
              </div>
            </div>
          </section>
        </li>
        <li class="panel-bg">
          <section>
            <div class="title">How does Naughty community works?</div>
            <div class="content">
              <p>
                Naughty community followed the rule of DAO,and NFT holders can
                participate in the decision-making of community.
              </p>
            </div>
          </section>
        </li>
        <li class="panel-bg">
          <section>
            <div class="title">Verified contract</div>
            <div class="content">
              <p>contract address:</p>
              <a
                class="copy"
                href="#"
                @click="
                  copyHandle('0x7a4d1b54dd21dde804c18b7a830b5bc6e586a7f6s')
                "
              >
                COPY
              </a>
            </div>
          </section>
        </li>
      </ul>
    </main>
    <footer>
      <section>
        <div class="footer-logo"></div>
        <div class="link-list">
          <!--          <a class="footer-youtube" href="#"></a>
                                        <a class="footer-instagram" href="#"></a>-->
          <a
            class="footer-twitter"
            href="https://twitter.com/naughtyDAOweb3"
            target="_blank"
          ></a>
          <a
            class="footer-discord"
            href="https://discord.gg/ErHRUU5eXd"
            target="_blank"
          ></a>
        </div>
        <span class="copyright">Copyright ©2023 Naughty Group LLC</span>
      </section>
    </footer>
  </div>
  <el-backtop :right="20" :bottom="20" />
  <Dialog v-model="dialog.visible" width="auto" :title="dialog.title">
    <!--  连接    -->
    <DialogConnect
      v-if="dialog.id === 'connect'"
      @hideDialog="hideDialog"
    ></DialogConnect>
    <!--  错误    -->
    <DialogError
      v-if="dialog.id === 'error'"
      :parentData="dialog.parentData"
      @hideDialog="hideDialog"
    ></DialogError>
  </Dialog>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { getAssetsFile, copyHandle } from "@/utils/tools";
import abi from "@/utils/NaughtyHamsterNFT.json";
import { ethers } from "ethers";
import { useAccountStore } from "@/stores/account";
import { storeToRefs } from "pinia";
import { getTotalSupply } from "@/api";
import initMapDialog from "@/components/dialog";
import DialogConnect from "@/views/mobile/Connect.vue";
import DialogError from "@/views/mobile/Error.vue";
// 弹窗相关
const { dialog, showDialog, Dialog } = initMapDialog();

// 菜单相关
const menuActive = ref(false);
// 计数器
const count = ref(1);
// 进度条读数
const totalSupply = ref(1);
const mintMaxSize = ref(5000);

// Contract Address & ABI
const contractAddress = "0xe3ed2048558220428611C6de33390cF5EdE7A2f9";
const contractABI = abi.abi;

// 获取状态
const userStore = useAccountStore();
const { account } = storeToRefs(userStore);
const { setAccount } = userStore;

// 进度条
const progress = async () => {
  try {
    totalSupply.value = await getTotalSupply();

    // let provider = ethers.getDefaultProvider("goerli");
    // console.log(provider);
    // let contract = new ethers.Contract(contractAddress, contractABI, provider);
    // console.log(contract);
    // totalSupply.value = await contract.totalSupply();
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
    const { ethereum } = window;

    const accounts = await ethereum.request({ method: "eth_accounts" });
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
  // 判断是否登录
  if (account.value === null) {
    showDialog({ id: "connect" });
    return;
  }
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

      const publicMintTxn = await mintContract.publicMint(1, {
        value: ethers.utils.parseEther((count.value * 0.01).toString()),
      });

      await publicMintTxn.wait();

      console.log("public mined ", publicMintTxn.hash);

      console.log("publicMint finished!");
    }
  } catch (error) {
    console.log(error);

    var code = error["code"]
    console.log(code, typeof code)

    if (code == "UNPREDICTABLE_GAS_LIMIT") {
      showDialog({
        id: "error", 
        parentData: {text: "NFT is not yet officially available for sale to the public, please wait patiently! "}
      })
    }
  }
};

// 隐藏弹窗
const hideDialog = () => {
  dialog.visible = false;
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
  background-color: #fdf7f7;

  nav {
    position: fixed;
    width: 100%;
    background: #ffffff;
    z-index: 1;

    .nav-top {
      background: url("@/assets/web/logo.png") center center no-repeat;
      background-size: 37px 38px;
      display: flex;
      flex-flow: column nowrap;
      justify-content: center;
      align-items: flex-end;
      height: 60px;

      .burger {
        position: relative;
        width: 20px;
        height: 20px;
        background: transparent;
        margin-right: 30px;
        cursor: pointer;

        input {
          display: none;

          &:checked {
            ~ span:nth-of-type(1) {
              transform: rotate(45deg);
              top: 0px;
              left: 3px;
            }

            ~ span:nth-of-type(2) {
              width: 0%;
              opacity: 0;
            }

            ~ span:nth-of-type(3) {
              transform: rotate(-45deg);
              top: 14px;
              left: 2px;
            }
          }
        }

        span {
          display: block;
          position: absolute;
          height: 4px;
          width: 100%;
          background: black;
          border-radius: 9px;
          opacity: 1;
          left: 0;
          transform: rotate(0deg);
          transition: 0.25s ease-in-out;

          &:nth-of-type(1) {
            top: 0px;
            transform-origin: left center;
          }

          &:nth-of-type(2) {
            top: 50%;
            transform: translateY(-50%);
            transform-origin: left center;
          }

          &:nth-of-type(3) {
            top: 100%;
            transform-origin: left center;
            transform: translateY(-100%);
          }
        }
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
          background-size: contain;
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
    padding-top: 60px;
    width: 100%;

    .animate-left-icon {
      position: absolute;
      top: 130px;
      left: 0;
      width: 74px;
    }

    .animate-right-icon {
      position: absolute;
      top: 280px;
      right: 0px;
      width: 79px;
    }

    > section.title {
      overflow: hidden;

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
        text-align: center;
        font-family: "MontserratAlternates-BlackItalic";
        font-weight: normal;
        font-size: 18px;
      }
    }

    > section.content {
      .left-list {
        display: flex;
        flex-flow: row wrap;
        align-content: space-between;
        width: 358px;
        margin: 0 auto;

        > li {
          width: 50%;
          padding: 0 0 20px 30px;

          .label {
            font-size: 24px;
            font-weight: 600;
          }

          .count {
            font-family: Saira-Black;
            font-size: 50px;
            font-weight: 900;
          }
        }
      }

      .right-content {
        display: flex;
        flex-flow: column nowrap;
        padding: 0 13px;

        > p {
          margin: 0 0 50px;
          font-size: 22px;
          font-weight: 600;
        }

        .progress-box {
          display: flex;
          flex-flow: row nowrap;
          align-items: center;
          margin-bottom: 22px;

          .label {
            margin-right: 20px;
            font-size: 18px;
            font-weight: 400;
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
              background: url("@/assets/web/progress-stick.png") 0 center
                no-repeat;
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
          background-size: contain;
          position: relative;
          width: 402px;
          height: 80px;
          margin: 0 auto;

          .add {
            position: absolute;
            top: 18px;
            left: 23px;
            display: inline-block;
            width: 28px;
            height: 28px;
            cursor: pointer;
          }

          .count {
            background: none;
            position: absolute;
            top: 18px;
            left: 55px;
            display: block;
            width: 90px;
            height: 28px;
            line-height: 28px;
            border: none;
            text-align: center;
            font-size: 18px;
            font-weight: 900;
            outline: none;
          }

          .reduce {
            position: absolute;
            top: 18px;
            left: 151px;
            display: inline-block;
            width: 28px;
            height: 28px;
            cursor: pointer;
          }

          .mint {
            float: right;
            width: 199px;
            height: 100%;
            cursor: pointer;
          }
        }
      }
    }
  }

  .banner {
    background: url("@/assets/web/banner.png") center center no-repeat;
    background-size: cover;
    height: 90px;
    margin: 10px 0 30px;
  }

  > main {
    .road-map {
      background: url("@/assets/web/road-map.png") center center no-repeat;
      height: 49px;
      margin-bottom: 50px;
    }

    .road-map-content {
      margin: 0 20px;

      > li {
        margin-bottom: 27px;

        > .list-title {
          background-image: url("@/assets/mobile/roadmap-step.png");
          background-position: 0 center;
          background-repeat: no-repeat;
          background-size: contain;
          padding-left: 50px;
          font-family: "MontserratAlternates-BlackItalic";
          font-size: 24px;

          &.active {
            background-image: url("@/assets/mobile/roadmap-step-active.png");
          }
        }

        > .list-content {
          padding-top: 36px;
          padding-left: 34px;
          margin-left: 13px;
          border-left: 2px dashed #e8a0d7;

          .label {
            background-position: 0 center;
            background-repeat: no-repeat;
            height: 56px;
            line-height: 56px;
            padding-left: 80px;
            margin-bottom: 26px;
            font-size: 28px;
            font-weight: 600;

            &.one {
              background-image: url("@/assets/mobile/roadmap-number1.png");
            }

            &.two {
              background-image: url("@/assets/mobile/roadmap-number2.png");
            }

            &.three {
              background-image: url("@/assets/mobile/roadmap-number3.png");
            }

            &.four {
              background-image: url("@/assets/mobile/roadmap-number4.png");
            }
          }

          .text {
            font-size: 18px;
            font-weight: 600;
          }
        }
      }
    }

    .faq {
      background: url("@/assets/web/faq.png") center center no-repeat;
      height: 49px;
      margin: 40px 0;
    }

    .faq-panels {
      padding: 0 20px;

      > li {
        margin-bottom: 30px;

        > section {
          background-image: url("@/assets/web/faq-panel-icon.png");
          background-position: center 40px;
          background-repeat: no-repeat;
          padding: 190px 30px 20px 30px;

          .title {
            font-size: 36px;
            font-family: "MontserratAlternates-BlackItalic";
          }

          .content {
            font-size: 21px;
            font-weight: 600;
          }
        }

        &:nth-child(1) {
          > section {
            position: relative;
            padding-bottom: 383px;
            overflow: hidden;

            .bg-image {
              background: url("@/assets/web/faq-panel-bg-1.png") center 100px
                no-repeat;
              position: absolute;
              left: 50%;
              transform: translateX(-50%);
              bottom: 0px;
              width: 670px;
              height: 501px;
            }
          }
        }

        &:nth-child(2) {
          > section {
            > .content {
              > ul {
                display: flex;
                flex-flow: column nowrap;
                align-items: center;

                > li {
                  margin-bottom: 36px;

                  .image {
                    width: 220px;
                    height: 157px;
                    margin-bottom: 17px;
                  }

                  .text {
                    text-align: center;
                    font-size: 21px;
                    font-weight: 600;
                  }

                  &:nth-child(1) {
                    > .image {
                      background: url("@/assets/web/faq-actities.png") center
                        center no-repeat;
                    }
                  }

                  &:nth-child(2) {
                    > .image {
                      background: url("@/assets/web/faq-ip.png") center center
                        no-repeat;
                    }
                  }

                  &:nth-child(3) {
                    > .image {
                      background: url("@/assets/web/faq-discount.png") center
                        center no-repeat;
                    }
                  }

                  &:nth-child(4) {
                    > .image {
                      background: url("@/assets/web/faq-future.png") center
                        center no-repeat;
                    }
                  }
                }
              }
            }
          }
        }

        &:nth-child(3) {
          > section {
            > .content {
              .link-buttons {
                display: flex;
                flex-flow: column nowrap;
                align-items: center;

                > a {
                  display: block;
                  width: 212px;
                  height: 62px;
                  margin-bottom: 20px;

                  &.twitter {
                    background: url("@/assets/web/faq-twitter.png") center
                      center no-repeat;
                    background-size: contain;
                  }

                  &.discord {
                    background: url("@/assets/web/faq-discord.png") center
                      center no-repeat;
                    background-size: contain;
                  }
                }
              }
            }
          }
        }

        &:nth-child(5) {
          > section {
            > .content {
              .copy {
                background: #000000;
                display: block;
                height: 62px;
                line-height: 62px;
                color: #ffffff;
                font-size: 21px;
                text-align: center;
                text-decoration: none;
              }
            }
          }
        }
      }
    }
  }

  > footer {
    background: #000102;

    > section {
      display: flex;
      flex-flow: column nowrap;
      align-items: center;
      padding: 40px 0;

      .footer-logo {
        background: url("@/assets/web/footer-logo.png") center center no-repeat;
        background-size: contain;
        width: 58px;
        height: 59px;
        margin-bottom: 40px;
      }

      .link-list {
        display: flex;
        flex-flow: row nowrap;
        margin-bottom: 40px;

        > a {
          background-position: center center;
          background-repeat: no-repeat;
          background-size: contain;
          width: 32px;
          height: 22px;
          margin-right: 27px;

          &.footer-youtube {
            background-image: url("@/assets/web/footer-youtube.png");
          }

          &.footer-instagram {
            background-image: url("@/assets/web/footer-instagram.png");
          }

          &.footer-twitter {
            background-image: url("@/assets/web/footer-twitter.png");
          }

          &.footer-discord {
            background-image: url("@/assets/web/footer-discord.png");
          }
        }
      }

      .copyright {
        font-size: 14px;
        font-weight: 600;
        color: #ffffff;
      }
    }
  }
}
</style>
