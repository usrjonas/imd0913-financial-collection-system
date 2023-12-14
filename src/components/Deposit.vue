<template>
  <div>
    <div style="margin-bottom: 6vh"></div>
    <a-row :span="4" justify="center" style="min-height: 4vh">
      <a-col :span="4">
        <a-input
          placeholder="Unique Identifier"
          allowClear
          v-model:value="uniqueIdentifierToDeposit"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="4" justify="center" style="min-height: 4vh">
      <a-col :span="4">
        <a-input
          placeholder="Value to deposit"
          allowClear
          v-model:value="valueToDeposit"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="4" justify="center" style="min-height: 4vh">
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
  </div>
</template>

<script>
import { infoNotification, errorNotification } from "../constants/Notification";

export default {
  data() {
    return {
      uniqueIdentifierToDeposit: "",
      valueToDeposit: null,
      loadings: {
        depositValue: false,
      },
    };
  },

  methods: {
    async depositValue() {
      try {
        const account = this.$globalState.account;
        this.setLoading("depositValue", true);
        console.log("Depositing value...");

        const contract = this.$globalState.contract;
        await contract.methods
          .depositValue(this.uniqueIdentifierToDeposit)
          .send({ from: account, value: this.valueToDeposit })
          .then(() => {
            const message =
              this.valueToDeposit +
              " wei deposited in " +
              this.uniqueIdentifierToDeposit +
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

    setLoading(property, state) {
      this.loadings[property] = state;
    },
  },

  computed: {
    createDepositIsDisabled() {
      return (
        this.uniqueIdentifierToDeposit.length <= 0 ||
        this.valueToDeposit === null
      );
    },
  },
};
</script>

<style scoped></style>
