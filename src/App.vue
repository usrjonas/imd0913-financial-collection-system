<script setup></script>

<template>
  <div>
    <a-menu
      mode="horizontal"
      theme="dark"
      :default-selected-keys="selectedKeys"
    >
      <!-- <a-menu-item @click="connectWallet">Connect wallet</a-menu-item> -->
      <a-menu-item :key="1">Home<router-link to="/"></router-link></a-menu-item>
      <a-menu-item :key="2"
        ><router-link to="/about">About</router-link></a-menu-item
      >
      <a-menu-item @click="connectWallet" :key="3">Connect wallet</a-menu-item>
    </a-menu>
    <!-- <router-view></router-view> -->
    <div v-if="connected">
      <a-row :span="8">
        <a-col :span="4">
          <a-input
            placeholder="Unique Identifier"
            allowClear
            v-model:value="contractData.uniqueIdentifier"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="4">
        <a-col :span="2">
          <a-button
            type="primary"
            @click="existAccount"
            :disabled="existAccountIsDisabled"
            :loading="this.loadings.existAccount"
            style="width: 100%"
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
            style="width: 100%"
            >Account Information</a-button
          >
        </a-col>
      </a-row>

      <br /><br />
      <a-row :span="8">
        <a-col :span="4">
          <a-input
            placeholder="New Unique Identifier"
            allowClear
            v-model:value="contractData.newUniqueIdentifier"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-input
            placeholder="Security Key"
            allowClear
            v-model:value="contractData.securityKey"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-input
            placeholder="Description"
            allowClear
            v-model:value="contractData.description"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-input
            placeholder="Creator Information"
            allowClear
            v-model:value="contractData.creatorInformation"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-checkbox v-model:checked="contractData.earlyWithdrawal"
            >Early Withdrawal</a-checkbox
          >
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-space
            direction="vertical"
            :size="12"
            :hidden="contractData.earlyWithdrawal"
          >
            <a-date-picker
              placeholder="Withdrawal Date"
              format="DD-MM-YYYY HH:mm:ss"
              v-model:value="contractData.expirationDate"
            />
          </a-space>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-input-number
            placeholder="Minimun deposit"
            id="minDeposit"
            v-model:value="contractData.minDeposit"
            style="width: 100%"
            :min="1"
          />
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-input-number
            placeholder="Maximum deposit"
            id="maxDeposit"
            v-model:value="contractData.maxDeposit"
            style="width: 100%"
            :min="1"
          />
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-button
            type="primary"
            @click="createAccount"
            :disabled="createAccountIsDisabled"
            :loading="this.loadings.createAccount"
            style="width: 100%"
            >Create Account</a-button
          >
        </a-col>
      </a-row>

      <br /><br />
      <a-row :span="4">
        <a-col :span="4">
          <a-input
            placeholder="Unique Identifier"
            allowClear
            v-model:value="contractData.uniqueIdentifierToDeposit"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="4">
        <a-col :span="4">
          <a-input
            placeholder="Value to deposit"
            allowClear
            v-model:value="contractData.valueToDeposit"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="4">
        <a-col :span="4">
          <a-button
            type="primary"
            @click="depositValue"
            :disabled="createDepositIsDisabled"
            :loading="this.loadings.depositValue"
            style="width: 100%"
            >Deposit Value</a-button
          >
        </a-col>
      </a-row>

      <br /><br />
      <a-row :span="4">
        <a-col :span="4">
          <a-input
            placeholder="Unique Identifier"
            allowClear
            v-model:value="contractData.uniqueIdentifierToWithdraw"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="4">
        <a-col :span="4">
          <a-input
            placeholder="Key"
            allowClear
            v-model:value="contractData.withdrawKey"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8">
        <a-col :span="4">
          <a-button
            type="primary"
            @click="withdrawValue"
            :disabled="withdrawIsDisabled"
            :loading="this.loadings.withdrawValue"
            style="width: 100%"
            >Withdraw</a-button
          >
        </a-col>
      </a-row>

      <br /><br />
      <a-row :span="4">
        <a-col :span="4">
          <a-popconfirm
            placement="rightBottom"
            ok-text="Yes"
            cancel-text="No"
            @confirm="getManagerProfit"
          >
            <template #title>
              <div>
                {{ `Do you are sure that you are the contract owner?` }}
              </div>
            </template>
            <a-button
              danger
              :loading="this.loadings.getManagerProfit"
              style="width: 100%"
              >Withdraw Manager Profit</a-button
            >
          </a-popconfirm>
        </a-col>
      </a-row>
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
        depositValue: false,
        withdrawValue: false,
        getManagerProfit: false,
      },
      contractData: {
        uniqueIdentifier: "",
        newUniqueIdentifier: "",
        securityKey: "",
        description: "",
        creatorInformation: "",
        earlyWithdrawal: ref(true),
        expirationDate: null,
        minDeposit: null,
        maxDeposit: null,
        valueToDeposit: null,
        uniqueIdentifierToDeposit: "",
        uniqueIdentifierToWithdraw: "",
        withdrawKey: "",
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
            this.contractData.uniqueIdentifier +
            " exist..."
        );

        this.contract.methods
          .existsAccount(this.contractData.uniqueIdentifier)
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
            this.contractData.uniqueIdentifier
        );

        this.contract.methods
          .getAccountInformation(this.contractData.uniqueIdentifier)
          .call()
          .then((account) =>
            successNotification(
              "Account Information",
              this.accountInformationToString(account)
            )
          )
          .catch(() => {
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

        const data = this.contractData;

        await this.contract.methods
          .createAccount(
            data.newUniqueIdentifier,
            data.securityKey,
            data.description,
            data.creatorInformation,
            data.earlyWithdrawal,
            data.expirationDate ? data.expirationDate.unix() : 1704048876,
            data.minDeposit,
            data.maxDeposit
          )
          .send({ from: this.account })
          .then((result) => {
            console.log(result);
            successNotification("Account Created", "Account created!");
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Error", err.message);
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("createAccount", false);
      }
    },

    async depositValue() {
      try {
        this.setLoading("depositValue", true);
        console.log("Depositing value...");

        await this.contract.methods
          .depositValue(this.contractData.uniqueIdentifierToDeposit)
          .send({ from: this.account, value: this.contractData.valueToDeposit })
          .then(() => {
            const message =
              this.contractData.valueToDeposit +
              " wei deposited in " +
              this.contractData.uniqueIdentifierToDeposit +
              " account!";
            infoNotification("Success", message);
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Error", err.message);
          });
      } catch (err) {
        console.error(err);
        errorNotification("Error", err.message);
      } finally {
        console.log("Fim da execução!");
        this.setLoading("depositValue", false);
      }
    },

    async withdrawValue() {
      try {
        this.setLoading("withdrawValue", true);
        console.log("Withdrawing value...");

        await this.contract.methods
          .withdrawValue(
            this.contractData.uniqueIdentifierToWithdraw,
            this.contractData.withdrawKey
          )
          .send({ from: this.account })
          .then(() => {
            const message =
              "Value withdrawed from " +
              this.contractData.uniqueIdentifierToWithdraw +
              " account!";
            infoNotification("Success", message);
          })
          .catch((err) => {
            console.error(err);
            errorNotification("Error", err.message);
          });
      } catch (err) {
        console.error(err);
        errorNotification("Error", err.message);
      } finally {
        console.log("Fim da execução!");
        this.setLoading("withdrawValue", false);
      }
    },

    async getManagerProfit() {
      try {
        this.setLoading("getManagerProfit", true);
        console.log("Getting manager profit...");

        await this.contract.methods
          .getManagerProfit()
          .call()
          .then((result) => {
            const message = "Manager profit: " + result + " wei";
            infoNotification("Success", message);
          })
          .catch((err) => {
            console.error(err);
            errorNotification(
              "Error",
              "Only the manager can call this function!"
            );
          });
      } catch (err) {
        console.error(err);
        errorNotification("Error", err.message);
      } finally {
        console.log("Fim da execução!");
        this.setLoading("getManagerProfit", false);
      }
    },

    accountInformationToString(accountInformation) {
      return (
        "Unique Identifier: " +
        accountInformation[0] +
        "\n" +
        "Description: " +
        accountInformation[1] +
        "\n" +
        "Creator Information: " +
        accountInformation[2] +
        "\n" +
        "Balance: " +
        accountInformation[3].toString() +
        "\n" +
        "Expiration Date: " +
        accountInformation[4].toString() +
        "\n" +
        "Min Deposit: " +
        accountInformation[5].toString() +
        "\n" +
        "Max Deposit: " +
        accountInformation[6].toString() +
        "\n" +
        "Amount Deposited: " +
        accountInformation[7].toString() +
        "\n" +
        "Early Withdrawal: " +
        accountInformation[8]
      );
    },

    setLoading(propiert, state) {
      this.loadings[propiert] = state;
    },
  },

  computed: {
    existAccountIsDisabled() {
      return this.contractData.uniqueIdentifier.length <= 0;
    },

    createAccountIsDisabled() {
      return (
        this.contractData.newUniqueIdentifier.length <= 0 ||
        this.contractData.securityKey.length <= 0 ||
        this.contractData.description.length <= 0 ||
        this.contractData.creatorInformation.length <= 0 ||
        this.contractData.minDeposit === null ||
        this.contractData.maxDeposit === null ||
        (!this.contractData.earlyWithdrawal &&
          this.contractData.expirationDate === null)
      );
    },

    createDepositIsDisabled() {
      return (
        this.contractData.uniqueIdentifierToDeposit.length <= 0 ||
        this.contractData.depositValue === null
      );
    },

    withdrawIsDisabled() {
      return (
        this.contractData.uniqueIdentifierToWithdraw.length <= 0 ||
        this.contractData.withdrawKey.length <= 0
      );
    },
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

const contentStyle = {
  textAlign: "center",
  minHeight: 120,
  lineHeight: "120px",
  color: "#fff",
  backgroundColor: "#108ee9",
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
