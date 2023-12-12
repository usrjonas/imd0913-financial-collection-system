<template>
  <div>
    <a-col :span="8">
      <a-input
        placeholder="Account address"
        allowClear
        v-model:value="accountAddress"
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
      accountAddress: "",
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
          "Verifing if this account " + this.accountAddress + " exist..."
        );

        const contract = this.$globalState.contract;
        await contract.methods
          .existsAccount(this.accountAddress)
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
          "Getting information of this account " + this.accountAddress
        );

        const contract = this.$globalState.contract;
        await contract.methods
          .getAccountInformation(this.accountAddress)
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

    setLoading(property, state) {
      this.loadings[property] = state;
    },
  },

  computed: {
    existAccountIsDisabled() {
      return this.accountAddress.length <= 0;
    },
  },
};
</script>
