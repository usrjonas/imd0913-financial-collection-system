<template>
  <div>
    <div style="margin-bottom: 6vh"></div>
    <a-card title="Account Informations" :bordered="false">
      <a-row :span="8" justify="center" style="min-height: 4vh">
        <a-col :span="8">
          <a-input
            placeholder="Unique Identifier"
            allowClear
            v-model:value="uniqueIdentifier"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="8" :gutter="8" justify="center">
        <a-col :span="4">
          <a-button
            type="primary"
            @click="existAccount"
            :disabled="existAccountIsDisabled"
            :loading="this.loadings.existAccount"
            style="width: 100%"
            >Exist Account</a-button
          >
        </a-col>
        <a-col :span="4">
          <a-button
            type="primary"
            @click="getAccountInformation"
            :disabled="existAccountIsDisabled"
            :loading="this.loadings.accountInformation"
            style="width: 100%"
            >Account Information</a-button
          >
          <a-modal
            v-model:open="modalOpen"
            v-model:title="accountTitle"
            :confirm-loading="this.loadings.accountInformation"
            :footer="null"
          >
            <div v-html="accountInformation"></div>
            <a-progress v-model:percent="percentDeposited" />
          </a-modal>
        </a-col>
      </a-row>
    </a-card>
  </div>
</template>

<script>
import {
  infoNotification,
  successNotification,
  errorNotification,
} from "../constants/Notification";

export default {
  name: "About",

  data() {
    return {
      uniqueIdentifier: "",
      accountTitle: "Account",
      percentDeposited: 0,
      accountInformation: null,
      loadings: {
        existAccount: false,
        accountInformation: false,
      },
      modalOpen: false,
    };
  },

  methods: {
    async existAccount() {
      try {
        this.setLoading("existAccount", true);
        console.log(
          "Verifing if this account " + this.uniqueIdentifier + " exist..."
        );

        const contract = this.$globalState.contract;
        await contract.methods
          .existsAccount(this.uniqueIdentifier)
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
          "Getting information of this account " + this.uniqueIdentifier
        );

        const contract = this.$globalState.contract;
        await contract.methods
          .getAccountInformation(this.uniqueIdentifier)
          .call()
          .then((account) => {
            this.modalOpen = true;
            this.accountTitle = "Account " + account[0];
            this.accountInformation = this.accountInformationToString(account);
            this.getPercentDeposited(account);
          })
          .catch((err) => {
            console.log("Account not exists");
            errorNotification("Error", err.message);
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("accountInformation", false);
      }
    },

    accountInformationToString(accountInformation) {
      let expirationDate;
      if (accountInformation[9] === true) {
        expirationDate = "Don't have expiration date";
      } else {
        expirationDate = this.formatDate(accountInformation[4]);
      }
      return `<p>Description: ${accountInformation[1]}</p>
      <p>Creator Information: ${accountInformation[2]}</p>
      <p>Expiration Date: ${expirationDate}</p>
      <p>Min Deposit: ${accountInformation[5].toString()} eth</p>
      <p>Max Deposit: ${accountInformation[6].toString()} eth</p>
      <p>Amount Deposited: ${accountInformation[7].toString()} eth</p>
      <p>Deposit Target: ${accountInformation[8].toString()} eth</p>
      <p>Balance: ${accountInformation[3].toString()} eth</p>
      <p>Early Withdrawal: ${accountInformation[9]}</p>`;
    },

    getPercentDeposited(accountInformation) {
      this.percentDeposited =
        Number(accountInformation[7] / accountInformation[8]) * 100;
    },

    formatDate(dateUnix) {
      let date = new Date(parseInt(dateUnix) * 1000);

      let formattedTime =
        date.getDate() + "-" + (date.getMonth() + 1) + "-" + date.getFullYear();

      return formattedTime;
    },

    handleOk(e) {
      console.log(e);
      this.modalOpen = false;
    },

    setLoading(property, state) {
      this.loadings[property] = state;
    },
  },

  computed: {
    existAccountIsDisabled() {
      return this.uniqueIdentifier.length <= 0;
    },
  },
};
</script>
