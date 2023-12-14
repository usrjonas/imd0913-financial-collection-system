<template>
  <div>
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
      </a-col>
    </a-row>
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
      loadings: {
        existAccount: false,
        accountInformation: false,
      },
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
          .then((account) =>
            successNotification(
              "Account Information",
              this.accountInformationToString(account)
            )
          )
          .catch((err) => {
            console.log("Account not exists");
            errorNotification("Error", "Account not exists!");
          });
      } finally {
        console.log("Fim da execução!");
        this.setLoading("accountInformation", false);
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
