<template>
  <div>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input
          placeholder="New Unique Identifier"
          allowClear
          v-model:value="contractData.newUniqueIdentifier"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input
          placeholder="Security Key"
          allowClear
          v-model:value="contractData.securityKey"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input
          placeholder="Description"
          allowClear
          v-model:value="contractData.description"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input
          placeholder="Creator Information"
          allowClear
          v-model:value="contractData.creatorInformation"
        ></a-input>
      </a-col>
    </a-row>
    <a-row :span="8" justify="center">
      <a-col :span="8" align="middle" style="min-height: 3vh">
        <a-checkbox v-model:checked="contractData.earlyWithdrawal"
          >Early Withdrawal</a-checkbox
        >
      </a-col>
    </a-row>
    <a-row :span="8" justify="center">
      <a-col :span="8" align="middle" style="min-height: 4vh">
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
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input-number
          placeholder="Minimun deposit"
          id="minDeposit"
          v-model:value="contractData.minDeposit"
          style="width: 100%"
          :min="1"
        />
      </a-col>
    </a-row>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
        <a-input-number
          placeholder="Maximum deposit"
          id="maxDeposit"
          v-model:value="contractData.maxDeposit"
          style="width: 100%"
          :min="1"
        />
      </a-col>
    </a-row>
    <a-row :span="8" justify="center" style="min-height: 4vh">
      <a-col :span="8">
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
  </div>
</template>

<script>
import { ref } from "vue";
import {
  successNotification,
  errorNotification,
} from "../constants/Notification";

export default {
  name: "Home",

  data() {
    return {
      contractData: {
        newUniqueIdentifier: "",
        securityKey: "",
        description: "",
        creatorInformation: "",
        earlyWithdrawal: ref(false),
        expirationDate: null,
        minDeposit: null,
        maxDeposit: null,
      },
      loadings: {
        createAccount: false,
      },
    };
  },

  methods: {
    async createAccount() {
      try {
        const account = this.$globalState.account;
        this.setLoading("createAccount", true);
        console.log("Creating account...");
        console.log("account: " + account);

        const data = this.contractData;

        const contract = this.$globalState.contract;
        await contract.methods
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
          .send({ from: account })
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

    setLoading(property, state) {
      this.loadings[property] = state;
    },
  },

  computed: {
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
  },
};
</script>
