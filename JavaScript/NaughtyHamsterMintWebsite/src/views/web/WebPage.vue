<template>
  <div id="main-container">
    <nav>
      <ul>
        <li><a href="#mint">MINT</a></li>
        <li><a href="#road-map">Road Map</a></li>
        <li><a href="#faq">FAQ</a></li>
        <li class="logo"></li>
        <li>
          <a href="https://twitter.com/naughtyDAOweb3" target="_blank"
            >Twitter</a
          >
        </li>
        <li>
          <a href="https://discord.gg/ErHRUU5eXd" target="_blank">Discord</a>
        </li>
        <li
          v-if="account === null"
          class="connect"
          @click="showDialog({ id: 'connect' })"
        >
          CONNECT
        </li>
        <li v-else class="account-wrap">
          <span :title="account">{{ account }}</span>
          <img class="account" :src="getAssetsFile('web/account.png')" alt="" />
          <img
            class="logout"
            :src="getAssetsFile('web/logout.png')"
            alt=""
            @click="disconnectWallet"
          />
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
            <span class="mint" @click="publicMint"></span>
          </div>
        </div>
      </section>
    </header>
    <div class="banner"></div>
    <main>
      <div id="road-map" class="road-map"></div>
      <div class="road-map-content">
        <ul class="top">
          <li>Phase One</li>
          <li>Phase Two</li>
          <li>Phase Three</li>
          <li>Phase Four</li>
        </ul>
        <ul class="center">
          <li>Completed</li>
          <li>In progress</li>
          <li>Not started</li>
          <li>Not started</li>
        </ul>
        <ul class="bottom">
          <li>Publish 5000 NFT in different styles for sale.</li>
          <li>
            Develop the marketplace with our followers and start a Naughty DAO.
          </li>
          <li>In collaboration with game、social、clothes、food.</li>
          <li>
            Create the latest series from Naughty universe, expand its
            boundaries into animation and movie.
          </li>
        </ul>
      </div>
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
              <p>
                contract address:0x7a4d1b54dd21dde804c18b7a830b5bc6e586a7f6s
                <a
                  class="copy"
                  href="#"
                  @click="
                    copyHandle('0x7a4d1b54dd21dde804c18b7a830b5bc6e586a7f6s')
                  "
                  >COPY</a
                >
              </p>
            </div>
          </section>
        </li>
      </ul>
    </main>
    <footer>
      <section>
        <span class="copyright">Copyright ©2023 Naughty Group LLC</span>
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
      </section>
    </footer>
  </div>
  <el-backtop :right="100" :bottom="100" />
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
import { ref, computed, onMounted } from "vue";
import { getAssetsFile, copyHandle } from "@/utils/tools";
import abi from "@/utils/NaughtyHamsterNFT.json";
import { ethers } from "ethers";
import { useAccountStore } from "@/stores/account";
import { storeToRefs } from "pinia";
import { getTotalSupply } from "@/api";
import initMapDialog from "@/components/dialog";
import DialogConnect from "./Connect.vue";
import DialogError from "./Error.vue";
// 弹窗相关
const { dialog, showDialog, Dialog } = initMapDialog();

// 计数器
const count = ref(1);
// 进度条读数
const totalSupply = ref(1);
const mintMaxSize = ref(5000);

// Contract Address & ABI
const contractAddress = "0x0CD057EC2f2D56b0A8d4881022Bf409d1Cc129Ba";
const contractABI = abi.abi;

// 获取状态
const userStore = useAccountStore();
const { account } = storeToRefs(userStore);
const { setAccount } = userStore;

// 进度条
const progress = async () => {
  try {
    //
    let provider = ethers.getDefaultProvider("goerli");
    console.log(provider);
    let contract = new ethers.Contract(contractAddress, contractABI, provider);
    console.log(contract);

    // totalSupply.value = await getTotalSupply();
    totalSupply.value = await contract.totalSupply();
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
      setAccount(accounts[0]);
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
    showDialog({
      id: "error",
    });
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

<style scoped lang="scss">
#main-container {
  background-image: url("@/assets/web/main-bg-1920.png");
  background-position: center 0;
  background-repeat: no-repeat;
  background-size: cover;
  padding: 30px 0;

  > nav {
    width: 1440px;
    margin: 0 auto;

    ul {
      display: flex;
      flex-flow: row nowrap;
      justify-content: space-between;
      align-items: center;

      > li {
        font-weight: 600;
        font-size: 18px;

        &.logo {
          background: url("@/assets/web/logo.png") 0 0 no-repeat;
          width: 88px;
          height: 91px;
        }

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
    width: 1440px;
    margin: 0 auto;

    .animate-left-icon {
      position: absolute;
      top: 137px;
      left: -97px;
      width: 150px;
    }

    .animate-right-icon {
      position: absolute;
      top: 54px;
      right: -70px;
      width: 150px;
    }

    > section.title {
      > h3 {
        margin: 30px 0;
        text-align: center;
        font-family: "MontserratAlternates-BlackItalic";
        font-weight: normal;
        font-size: 55px;

        .nfts {
          display: inline-block;
          background: url("@/assets/web/nfcs.png") 0 0 no-repeat;
          width: 199px;
          height: 101px;
          margin-left: 20px;
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
      display: flex;
      flex-flow: row nowrap;
      justify-content: center;

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

          .mint {
            float: right;
            width: 320px;
            height: 100%;
            cursor: pointer;
          }
        }
      }
    }
  }

  .banner {
    background: url("@/assets/web/banner.png") center center no-repeat;
    background-size: auto 100%;
    height: 223px;
    margin: 70px 0;
  }

  > main {
    .road-map {
      background: url("@/assets/web/road-map.png") center center no-repeat;
      height: 49px;
    }

    .road-map-content {
      position: relative;
      background: url("@/assets/web/road-map-content.png") center center
        no-repeat;
      width: 1600px;
      height: 734px;
      margin: 0 auto;

      .top {
        position: absolute;
        top: 70px;
        left: 226px;
        font-family: "MontserratAlternates-BlackItalic";
        font-size: 36px;

        > li {
          float: left;
          width: 318px;

          &:nth-child(2) {
            margin-top: -10px;
          }

          &:nth-child(3) {
            margin-top: -20px;
            color: #ebd6ca;
          }

          &:nth-child(4) {
            margin-top: -45px;
            color: #ebd6ca;
          }
        }
      }

      .center {
        position: absolute;
        top: 300px;
        left: 226px;

        > li {
          float: left;
          width: 318px;
          font-size: 28px;
          font-weight: 600;
        }
      }

      .bottom {
        position: absolute;
        top: 460px;
        left: 164px;

        > li {
          float: left;
          width: 318px;
          padding: 20px;
          font-size: 18px;
          font-weight: 600;

          &:nth-child(2) {
            margin-top: 40px;
          }

          &:nth-child(3) {
            margin-top: 80px;
          }

          &:nth-child(4) {
            margin-top: 100px;
          }
        }
      }
    }

    .faq {
      background: url("@/assets/web/faq.png") center center no-repeat;
      height: 49px;
      margin-bottom: 80px;
    }

    .faq-panels {
      width: 1220px;
      margin: 0 auto;

      > li {
        margin-bottom: 50px;

        > section {
          background-image: url("@/assets/web/faq-panel-icon.png");
          background-position: 70px 80px;
          background-repeat: no-repeat;
          padding: 71px 0 94px 222px;

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
            overflow: hidden;

            > .content {
              width: 513px;
            }

            .bg-image {
              background: url("@/assets/web/faq-panel-bg-1.png") 0 0 no-repeat;
              position: absolute;
              right: -139px;
              bottom: -74px;
              width: 670px;
              height: 501px;
            }
          }
        }

        &:nth-child(2) {
          > section {
            > .content {
              width: 883px;

              > ul {
                display: flex;
                flex-flow: row nowrap;
                justify-content: space-evenly;

                > li {
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
                > a {
                  float: left;
                  width: 212px;
                  height: 62px;
                  margin-right: 30px;

                  &.twitter {
                    background: url("@/assets/web/faq-twitter.png") center
                      center no-repeat;
                  }

                  &.discord {
                    background: url("@/assets/web/faq-discord.png") center
                      center no-repeat;
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
                display: inline-block;
                width: 85px;
                height: 44px;
                line-height: 44px;
                margin-left: 27px;
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
      flex-flow: row nowrap;
      justify-content: space-between;
      align-items: center;
      width: 1440px;
      height: 168px;
      line-height: 168px;
      margin: 0 auto;

      .copyright {
        font-size: 14px;
        font-weight: 600;
        color: #ffffff;
      }

      .footer-logo {
        background: url("@/assets/web/footer-logo.png") center center no-repeat;
        width: 58px;
        height: 59px;
      }

      .link-list {
        display: flex;
        flex-flow: row nowrap;

        > a {
          width: 32px;
          height: 22px;
          margin-right: 27px;

          &.footer-youtube {
            background: url("@/assets/web/footer-youtube.png") center center
              no-repeat;
          }

          &.footer-instagram {
            background: url("@/assets/web/footer-instagram.png") center center
              no-repeat;
          }

          &.footer-twitter {
            background: url("@/assets/web/footer-twitter.png") center center
              no-repeat;
          }

          &.footer-discord {
            background: url("@/assets/web/footer-discord.png") center center
              no-repeat;
          }
        }
      }
    }
  }
}
</style>
