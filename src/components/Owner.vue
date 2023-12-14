<template>
  <div>
    <div style="margin-bottom: 6vh"></div>
    <a-card title="Owner Section" :bordered="false">
      <a-row :span="4" justify="center" style="min-height: 4vh">
        <a-col :span="4">
          <a-input
            placeholder="Unique Identifier"
            allowClear
            v-model:value="contractData.uniqueIdentifierToWithdraw"
          ></a-input>
        </a-col>
      </a-row>
      <a-row :span="4" justify="center" style="min-height: 4vh">
        <a-col :span="4">
          <a-input-password
            placeholder="Key"
            allowClear
            v-model:value="contractData.withdrawKey"
          ></a-input-password>
        </a-col>
      </a-row>
      <a-row :span="8" justify="center" style="min-height: 4vh">
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

      <div style="margin-bottom: 6vh"></div>
      <a-row :span="4" justify="center">
        <a-col :span="4">
          <a-popconfirm
            placement="rightBottom"
            ok-text="Yes"
            cancel-text="No"
            @confirm="getManagerProfit"
          >
            <template #title>
              <div>
                {{ `Do you sure that you are the contract owner?` }}
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
    </a-card>
  </div>
</template>

<script>
import { infoNotification, errorNotification } from "../constants/Notification";

export default {
  name: "Owner",
  data() {
    return {
      contractData: {
        uniqueIdentifierToWithdraw: "",
        withdrawKey: "",
      },
      loadings: {
        withdrawValue: false,
        getManagerProfit: false,
      },
    };
  },

  methods: {
    async withdrawValue() {
      try {
        const account = this.$globalState.account;
        this.setLoading("withdrawValue", true);
        console.log("Withdrawing value...");

        const contract = this.$globalState.contract;
        await contract.methods
          .withdrawValue(
            this.contractData.uniqueIdentifierToWithdraw,
            this.contractData.withdrawKey
          )
          .send({ from: account })
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

        const contract = this.$globalState.contract;
        await contract.methods
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

    setLoading(property, state) {
      this.loadings[property] = state;
    },
  },

  computed: {
    withdrawIsDisabled() {
      return (
        this.contractData.uniqueIdentifierToWithdraw.length <= 0 ||
        this.contractData.withdrawKey.length <= 0
      );
    },
  },
};
</script>

<style scoped></style>
