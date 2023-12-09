<script setup></script>

<template>
  <div>
    <!-- <a-row v-if="!connected">
      <a-col :span="24"> </a-col>
    </a-row> -->
    <div>
      <a-menu
        mode="horizontal"
        theme="dark"
        :default-selected-keys="selectedKeys"
      >
        <!-- <a-menu-item @click="connectWallet">Connect wallet</a-menu-item> -->
        <a-menu-item :key="1"
          >Home<router-link to="/"></router-link
        ></a-menu-item>
        <a-menu-item :key="2"
          ><router-link to="/about">About</router-link></a-menu-item
        >
        <a-menu-item @click="connectWallet" :key="3"
          >Connect wallet</a-menu-item
        >
      </a-menu>

      <router-view></router-view>
      <!-- <header>
        <h1>Your App Name</h1>
        <Option />
        <Menu :options="headerOptions" @optionSelected="handleOptionSelected" />
      </header>

      <router-view></router-view>

      <p v-if="selectedOption">Selected Option: {{ selectedOption }}</p> -->
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
import contractAddress from "./constants/ContractAddress";
import ABI from "./constants/ABI.js";
import Menu from "./components/Menu.vue";
import Option from "./components/Option.vue";

export default {
  name: "App",
  components: {
    Menu,
    Option,
  },

  data() {
    return {
      connected: false,
      contract: {},
      accountAddress: "",

      headerOptions: ["Option 1", "Option 2", "Option 3"],
      selectedOption: null,
    };
  },

  methods: {
    handleOptionSelected(option) {
      // Do something with the selected option
      console.log("Selected Option:", option);
      this.selectedOption = option;
    },

    async connectWallet() {
      if (window.ethereum) {
        try {
          await window.ethereum
            .request({
              method: "eth_requestAccounts",
            })
            .then(() => {
              this.connected = true;
              this.callContract();
            });
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
      this.contract = new web3.eth.Contract(ABI, contractAddress);
    },

    async existAccount() {
      console.log(this.accountAddress);
    },

    async getAccountInformation() {},

    async createAccount() {},

    async depositValue() {},

    async withdrawValue() {},

    async getManagerProfitAndDestructContract() {
      this.contract.methods
        .getManagerProfitAndDestructContract()
        .call()
        .then((result) => console.log(result));
    },
  },
};
</script>

<!-- <style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style> -->
