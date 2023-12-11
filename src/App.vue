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
      <div v-if="connected">
        <a-col :span="8">
          <a-input
            placeholder="Account address"
            allowClear
            v-model:value="contractData.accountAddress"
          ></a-input>
        </a-col>
        <a-row :span="8">
          <a-col :span="4">
            <a-button
              type="primary"
              @click="existAccount"
              :disabled="existAccountIsDisabled"
              :loading="this.loadings.existAccount"
              >Exist Account</a-button
            >
          </a-col>
          <a-col>
            <a-button
              :span="4"
              type="primary"
              @click="getAccountInformation"
              :disabled="existAccountIsDisabled"
              :loading="this.loadings.accountInformation"
              >Account Information</a-button
            >
          </a-col>
        </a-row>

        <br /><br />
        <div v-if="connected">
          <a-col :span="4">
            <a-input
              placeholder="Unique Identifier"
              allowClear
              v-model:value="contractData.uniqueIdentifier"
            ></a-input>
          </a-col>
          <a-col :span="4">
            <a-input
              placeholder="Security Key"
              allowClear
              v-model:value="contractData.securityKey"
            ></a-input>
          </a-col>
          <a-col :span="4">
            <a-input
              placeholder="Description"
              allowClear
              v-model:value="contractData.description"
            ></a-input>
          </a-col>
          <a-col :span="4">
            <a-input
              placeholder="Creator Information"
              allowClear
              v-model:value="contractData.creatorInformation"
            ></a-input>
          </a-col>
          <a-col :span="4">
            <a-space direction="vertical" :size="12">
              <a-date-picker
                placeholder="Withdrawal Date"
                format="DD-MM-YYYY HH:mm:ss"
                v-model:value="contractData.expirationDate"
              />
            </a-space>
          </a-col>
          <a-col :span="4">
            <a-input-number
              placeholder="Minimun deposit"
              id="minDeposit"
              v-model:value="contractData.minDeposit"
              :min="1"
            />
          </a-col>
          <a-col :span="4">
            <a-input-number
              placeholder="Maximum deposit"
              id="maxDeposit"
              v-model:value="contractData.maxDeposit"
              :min="1"
            />
          </a-col>
          <a-col :span="4">
            <a-checkbox v-model:checked="contractData.earlyWithdrawal"
              >Early Withdrawal</a-checkbox
            >
          </a-col>
          <a-col :span="4">
            <a-button
              type="primary"
              @click="createAccount"
              :disabled="createAccountIsDisabled"
              :loading="this.loadings.createAccount"
              >Create Account</a-button
            >
          </a-col>
        </div>
      </div>
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
import { ref } from "vue";

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
      account: "",
      loadings: {
        existAccount: false,
        accountInformation: false,
        createAccount: false,
      },
      contractData: {
        accountAddress: "",
        uniqueIdentifier: "",
        securityKey: "",
        description: "",
        creatorInformation: "",
        earlyWithdrawal: ref(false),
        expirationDate: null,
        minDeposit: null,
        maxDeposit: null,
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
            .then((accounts) => {
              this.callContract();
              this.connected = true;
              this.account = accounts[0];
            })
            .catch((err) => {
              console.log("Usuário negou acesso ao web3!");
              console.error(err);
            });

          window.ethereum.on("accountsChanged", (accounts) => {
            this.account = accounts[0];
          });
          console.log(this.account);
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
          "Verifing if this account " +
            this.contractData.accountAddress +
            " exist..."
        );

        this.contract.methods
          .existsAccount(this.contractData.accountAddress)
          .call()
          .then((result) => {
            console.log(result);
            result
              ? infoNotification("Account Exists", "Account exist!")
              : infoNotification("Account Not Exists", "Account Not exist!");
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Error", "Something Went Wrong! Try again!");
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
          "Getting information of this account " +
            this.contractData.accountAddress
        );

        this.contract.methods
          .getAccountInformation(this.contractData.accountAddress)
          .call()
          .then((result) => {
            console.log(result);
            successNotification("Account Information", result.data);
          })
          .catch((err) => {
            console.log("Account not exists");
            errorNotification("Error", "Account not exists!");
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("accountInformation", false);
      }
    },

    async createAccount() {
      try {
        this.setLoading("createAccount", true);
        console.log("Creating account...");
        console.log("account: " + this.account);

        await this.contract.methods
          .createAccount(
            this.contractData.uniqueIdentifier,
            this.contractData.securityKey,
            this.contractData.description,
            this.contractData.creatorInformation,
            this.contractData.earlyWithdrawal,
            this.contractData.expirationDate.unix(),
            this.contractData.minDeposit,
            this.contractData.maxDeposit
          )
          .send({ from: this.account })
          .then((result) => {
            console.log(result);
            successNotification("Account Created", "Account created!");
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Error", "Something Went Wrong! Try again!");
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("createAccount", false);
      }
    },

    depositValue() {
      console.log("date: " + this.contractData.expirationDate);
    },

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
      return this.contractData.accountAddress.length <= 0;
    },

    createAccountIsDisabled() {
      return (
        this.contractData.uniqueIdentifier.length <= 0 ||
        this.contractData.securityKey.length <= 0 ||
        this.contractData.description.length <= 0 ||
        this.contractData.creatorInformation.length <= 0 ||
        this.contractData.minDeposit === null ||
        this.contractData.maxDeposit === null ||
        (this.contractData.earlyWithdrawal &&
          this.contractData.expirationDate === null)
      );
    },

    // disabledDate(current) {
    //   // Can not select days before today and today
    //   return current && current < dayjs().endOf('day');
    // },

    // disabledDateTime() {
    //   return {
    //     disabledHours: () => range(0, 24).splice(4, 20),
    //     disabledMinutes: () => range(30, 60),
    //     disabledSeconds: () => [55, 56],
    //   };
    // },
  },
};

const infoNotification = (title, description) => {
  notification["info"]({
    message: title,
    description: description,
    duration: 5,
    placement: "top",
  });
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
