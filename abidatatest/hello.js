module.exports = {
    "contractName": "VerifySig",
    "abi": [
    {
        "inputs": [
        {
            "internalType": "address",
            "name": "_signer",
            "type": "address"
        },
        {
            "internalType": "string",
            "name": "_message",
            "type": "string"
        },
        {
            "internalType": "bytes",
            "name": "_sig",
            "type": "bytes"
        }
        ],
        "name": "verify",
        "outputs": [
        {
            "internalType": "bool",
            "name": "",
            "type": "bool"
        }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
    },
    {
        "inputs": [
        {
            "internalType": "string",
            "name": "_message",
            "type": "string"
        }
        ],
        "name": "getMessageHash",
        "outputs": [
        {
            "internalType": "bytes32",
            "name": "",
            "type": "bytes32"
        }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
    },
    {
        "inputs": [
        {
            "internalType": "bytes32",
            "name": "_messageHash",
            "type": "bytes32"
        }
        ],
        "name": "getEthSignedMessageHash",
        "outputs": [
        {
            "internalType": "bytes32",
            "name": "",
            "type": "bytes32"
        }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
    },
    {
        "inputs": [
        {
            "internalType": "bytes32",
            "name": "_ethSignedMessageHash",
            "type": "bytes32"
        },
        {
            "internalType": "bytes",
            "name": "_sig",
            "type": "bytes"
        }
        ],
        "name": "recover",
        "outputs": [
        {
            "internalType": "address",
            "name": "",
            "type": "address"
        }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
    }]
};