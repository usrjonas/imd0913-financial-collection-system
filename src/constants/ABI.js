const ABI = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "creatorInformation",
        type: "string",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "timestamp",
        type: "uint256",
      },
    ],
    name: "AccountCreated",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
      {
        internalType: "string",
        name: "securityKey",
        type: "string",
      },
      {
        internalType: "string",
        name: "description",
        type: "string",
      },
      {
        internalType: "string",
        name: "creatorInformation",
        type: "string",
      },
      {
        internalType: "bool",
        name: "earlyWithdrawal",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "expirationDate",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "depositTarget",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "minDeposit",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "maxDeposit",
        type: "uint256",
      },
    ],
    name: "createAccount",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
      {
        indexed: false,
        internalType: "address",
        name: "depositor",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "deposit",
        type: "uint256",
      },
    ],
    name: "DepositMade",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
    ],
    name: "depositValue",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "getManagerProfit",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
      {
        indexed: false,
        internalType: "address",
        name: "withdrawer",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "WithdrawalMade",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
      {
        internalType: "string",
        name: "securityKey",
        type: "string",
      },
    ],
    name: "withdrawValue",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
    ],
    name: "existsAccount",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "uniqueIdentifier",
        type: "string",
      },
    ],
    name: "getAccountInformation",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export default ABI;
