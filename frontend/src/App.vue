<script setup>
import HelloWorld from './components/HelloWorld.vue'
import TheWelcome from './components/TheWelcome.vue'
const walletStore = useWalletStore();
</script>

<template>
  <div>
    <button v-if="!connected" @click="connectWallet">Connect wallet</button>
    <button v-if="connected" @click="callContract">Call contract</button>
    {{ contractResult }}
  </div>
</template>

<script>
import Web3 from 'web3'
export default {
  name: 'App',

  data() {
    return {
      connected: false,
      contractResult: '',
    }
  },

  mounted() {
    if (this.walletStore.walletData.address != '') {
      console.log('There is a wallet connected!');
      this.retrieveMessages();
    }
  },

  methods: {
    async connectWallet() {
      if (window.ethereum) {
        try {
          const accounts = await window.ethereum.request({
            method: 'eth_requestAccounts',
          }).then(() => {
            this.connected = true;
          })
          if (accounts.length > 0) {
            this.connected = true
          }
        } catch (err) {
          console.error(err)
        }
      }
    },

    async callContract() {
      const web3 = new Web3(window.ethereum);
      let contractAddress = '0xa5218F88C6cc0A84eC8bE488747D6DA76d97f5C1';
      // let abi = JSON.parse(`[{"inputs": [],"stateMutability": "nonpayable","type": "constructor"},{"inputs": [],"name": "greet","outputs": [{"internalType": "string","name": "","type": "string"}],"stateMutability": "view","type": "function"}]`);

      const contract = new web3.eth.Contract(
        [
          {
            inputs: [],
            name: 'get',
            outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
            stateMutability: 'view',
            type: 'function',
          },
        ],
        contractAddress
      )
      // console.log('teste');
      const result = await contract.methods.get().call()
      // console.log(result);
      // this.contractResult = result
    },
  },
}
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
