const {assert} = require('chai')

const KryptoBird = artifacts.require('./Kryptobird');

//check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => { // grabs the ganache accounts 
    
    let contract

    // testing container - describe
    describe('deployment', async() => {
        // test samples with writing it
        // the following tests whether or not it has deployed successfully
        it('deploys successfully', async() => {
            contract  = await KryptoBird.deployed()
            const address = contract.address; // grabs the contract address
            // now we need to run a few tests to ensure contract address is correct
            assert.notEqual(address, '')       // address can't be empty
            assert.notEqual(address, null)     // or null 
            assert.notEqual(address, undefined)// or undefined
            assert.notEqual(address, 0x0)      // or 0x0
        })
    })
})