<script setup></script>

<template>
  <a-row v-if="!connected">
    <a-col :span="24">
      <a-button @click="connectWallet">Connect wallet</a-button>
    </a-col>
  </a-row>
  <div v-else>
    <a-row>
      <a-col :span="4">
        <a-input v-model="accountAddress"></a-input>
      </a-col>
      <a-col :span="4">
        <a-button type="primary" @click="existAccount">Exist Account</a-button>
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="4">
        <a-input></a-input>
      </a-col>
      <a-col :span="4">
        <a-button type="primary" @click="getAccountInformation"
          >Account Information</a-button
        >
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="4">
        <a-input></a-input>
      </a-col>
      <a-col :span="4">
        <a-button type="primary" @click="createAccount"
          >Create Account</a-button
        >
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="4">
        <a-input></a-input>
      </a-col>
      <a-col :span="4">
        <a-button type="primary" @click="depositValue">Deposit Value</a-button>
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="4">
        <a-input></a-input>
      </a-col>
      <a-col :span="4">
        <a-button type="primary" @click="withdrawValue"
          >Withdraw Value</a-button
        >
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="4"></a-col>
      <a-col :span="4">
        <a-button type="primary" @click="getManagerProfitAndDestructContract"
          >Destroy Contract</a-button
        >
      </a-col>
    </a-row>
  </div>
</template>

<script>
import Web3 from "web3";
import contractAddress from "./constants/ContractAddress";
import ABI from "./constants/ABI.js";
import { Button, Col, Row, Input } from "ant-design-vue";

export default {
  name: "App",
  components: {
    AButton: Button,
    ARow: Row,
    ACol: Col,
    AInput: Input,
  },

  data() {
    return {
      connected: false,
      contract: {},
      accountAddress: "",
    };
  },

  methods: {
    async connectWallet() {
      if (window.ethereum) {
        try {
          const accounts = await window.ethereum
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
