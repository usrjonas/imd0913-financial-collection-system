<template>
  <div>
    <div>
      <a-menu mode="horizontal" theme="dark">
        <a-menu-item @click="connectWallet" :key="3" :disabled="connected">{{
          walletStatus
        }}</a-menu-item>
      </a-menu>

      <div v-if="connected" style="background: #ececec; padding: 30px">
        <About />
        <Deposit />
        <Home />
        <Owner />
      </div>
      <a-layout v-else class="layout">
        <a-layout-content class="content">
          <div class="centered-content">
            <img
              src="./assets/undraw_love_it_xkc2.svg"
              alt="Image"
              class="centered-image"
            />
            <h1 class="centered-h1">Connect your wallet to start!</h1>
          </div>
        </a-layout-content>
      </a-layout>
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
import contractAddress from "./constants/ContractAddress";
import ABI from "./constants/ABI.js";
import Home from "./components/Home.vue";
import About from "./components/About.vue";
import Deposit from "./components/Deposit.vue";
import Owner from "./components/Owner.vue";
import {
  successNotification,
  infoNotification,
  errorNotification,
} from "./constants/Notification";

export default {
  name: "App",

  data() {
    return {
      connected: false,
      accountAddress: "",
      walletStatus: "Connect wallet",
    };
  },

  components: {
    Home,
    About,
    Deposit,
    Owner,
  },

  methods: {
    async connectWallet() {
      if (window.ethereum) {
        await window.ethereum
          .request({
            method: "eth_requestAccounts",
          })
          .then((accounts) => {
            this.callContract();
            this.connected = true;
            this.walletConnected();
            this.$globalState.account = accounts[0];
            successNotification("Wallet connected", accounts[0]);
          })
          .catch((err) => {
            console.log("Usuário negou acesso ao web3!");
            console.error(err);
            errorNotification("Failed to connect wallet", err.message);
          });

        window.ethereum.on("accountsChanged", (accounts) => {
          this.$globalState.account = accounts[0];
          this.connected = true;
          this.walletConnected();
        });
        // console.log(this.$globalState.account);
      } else {
        console.error("Instalar MetaMask!");
        infoNotification(
          "MetaMask doesn't installed",
          "https://metamask.io/download/"
        );
      }
    },

    async callContract() {
      const web3 = new Web3(window.ethereum);
      this.$globalState.contract = new web3.eth.Contract(ABI, contractAddress);
    },

    walletConnected() {
      this.connected
        ? (this.walletStatus = "Wallet connected")
        : (this.walletStatus = "Connect wallet");
    },
  },
};
</script>

<style>
.layout {
  min-height: 95vh;
  display: flex;
  align-items: center;
  justify-content: center;
}

.content {
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

.centered-content {
  max-width: 400px;
  margin: 0 auto;
}

.centered-image {
  width: 70%;
  height: auto;
}

.centered-h1 {
  color: #1890ff;
}
</style>
