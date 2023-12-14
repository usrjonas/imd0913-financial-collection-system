<template>
  <div>
    <div>
      <a-menu mode="horizontal" theme="dark">
        <!-- <a-menu-item :key="1"
          >Home<router-link to="/"></router-link
        ></a-menu-item>
        <a-menu-item :key="2"
          ><router-link to="/about">About</router-link>
        </a-menu-item>
        <a-menu-item :key="3"
          ><router-link to="/deposit">Deposit</router-link>
        </a-menu-item>
        <a-menu-item :key="4"
          ><router-link to="/owner">Owner</router-link>
        </a-menu-item> -->
        <a-menu-item @click="connectWallet" :key="3" :disabled="connected">{{
          walletStatus
        }}</a-menu-item>
      </a-menu>

      <div v-if="connected">
        <Home />
        <About />
        <Deposit />
        <Owner />
      </div>
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
        try {
          await window.ethereum
            .request({
              method: "eth_requestAccounts",
            })
            .then((accounts) => {
              this.callContract();
              this.connected = true;
              this.walletConnected();
              this.$globalState.account = accounts[0];
            })
            .catch((err) => {
              console.log("Usuário negou acesso ao web3!");
              console.error(err);
            });

          window.ethereum.on("accountsChanged", (accounts) => {
            this.$globalState.account = accounts[0];
            this.connected = true;
            this.walletConnected();
          });
          console.log(this.$globalState.account);
        } catch (err) {
          console.log("Usuário negou acesso ao web3!");
          console.error(err);
        }
      } else {
        console.error("Instalar MetaMask!");
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
