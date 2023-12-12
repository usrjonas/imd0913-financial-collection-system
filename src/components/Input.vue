<template>
  <div>
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
import { Button, Col, Row, Input } from "ant-design-vue";

export default {
  props: {
    options: {
      type: Array,
      required: true,
    },
  },
  components: {
    AButton: Button,
    ARow: Row,
    ACol: Col,
    AInput: Input,
  },
  data() {
    return {
      selectedOption: "",
    };
  },
  methods: {
    handleOptionChange() {
      this.$emit("optionSelected", this.selectedOption);
    },
  },
};
</script>

<style scoped>
/* Your menu component styling goes here */
label {
  margin-right: 10px;
}
</style>
