<script setup></script>

<template>
  <div>
    <button v-if="!connected" @click="connectWallet">Connect wallet</button>
    <button v-else @click="callContract">Call contract</button>
    {{ contractResult }}
  </div>
</template>

<script>
import Web3 from "web3";
import contractAddress from "./constants/ContractAddress";
import ABI from "./constants/ABI.js";

export default {
  name: "App",

  data() {
    return {
      connected: false,
    };
  },

  methods: {
    async connectWallet() {
      if (window.ethereum) {
        try {
          const accounts = await window.ethereum
            .request({
              method: "eth_requestAccounts",
            })
            .then(() => {
              this.connected = true;
            });
        } catch (err) {
          console.log("Usuário negou acesso ao web3!");
          console.error(err);
        }
      } else {
        console.error("Instalar MetaMask!");
        return;
      }
    },

    async callContract() {
      const web3 = new Web3(window.ethereum);

      const contract = new web3.eth.Contract(ABI, contractAddress);
      console.log("teste");
      contract.methods
        .greet()
        .call()
        .then((result) => console.log(result));
    },
  },
};
</script>

<style scoped>
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
</style>
