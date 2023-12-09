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

      <!-- <router-view></router-view> -->

      <a-row v-if="connected">
        <a-col :span="4">
          <a-input
            placeholder="account address"
            allowClear
            v-model:value="accountAddress"
          ></a-input>
        </a-col>
        <a-col :span="3">
          <a-button
            type="primary"
            @click="existAccount"
            :disabled="existAccountIsDisabled"
            :loading="this.loadings.existAccount"
            >Exist Account</a-button
          >
        </a-col>
        <a-col :span="4">
          <a-button
            type="primary"
            @click="getAccountInformation"
            :disabled="existAccountIsDisabled"
            :loading="this.loadings.accountInformation"
            >Account Information</a-button
          >
        </a-col>
      </a-row>
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
import { notification } from "ant-design-vue";

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
      loadings: {
        existAccount: false,
        accountInformation: false,
      },

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
      try {
        this.setLoading("existAccount", true);
        console.log(
          "Verifing if this account " + this.accountAddress + " exist..."
        );

        this.contract.methods
          .existsAccount(this.accountAddress)
          .call()
          .then((result) => {
            console.log(result);
            successNotification("Account Exists", "Account exist!");
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Account Exists", "Account not found!");
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("existAccount", false);
      }
    },

    async getAccountInformation() {
      try {
        this.setLoading("accountInformation", true);
        console.log(
          "Getting information of this account " + this.accountAddress
        );

        this.contract.methods
          .getAccountInformation(this.accountAddress)
          .call()
          .then((result) => {
            console.log(result);
            successNotification("Account Information", result.data);
          })
          .catch(() => {
            console.log("Account not found!");
            errorNotification("Account Information", "Account not found!");
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("accountInformation", false);
      }
    },

    async createAccount() {},

    async depositValue() {},

    async withdrawValue() {},

    async getManagerProfitAndDestructContract() {
      this.contract.methods
        .getManagerProfitAndDestructContract()
        .call()
        .then((result) => console.log(result));
    },

    setLoading(propiert, state) {
      this.loadings[propiert] = state;
    },
  },

  computed: {
    existAccountIsDisabled() {
      return this.accountAddress.length <= 0;
    },
  },
};

const successNotification = (title, description) => {
  notification["success"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
};

const errorNotification = (title, description) => {
  notification["error"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
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
