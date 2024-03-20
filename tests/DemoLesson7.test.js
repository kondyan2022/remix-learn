const {expect} = require('chai')
const {ethers} = require('hardhat')

describe('DemoSeven', function () {
    let owner
    let other_addr
    let demo

    beforeEach(async function () {
        [owner, other_addr] = await ethers.getSigners()
        const Demo7Contract = await ethers.getContractFactory('DemoSeven', owner)
        demo = await Demo7Contract.deploy()
        await demo.deployed()
    })

    async function sendMoney(sender) {
        const amount = 100
        const txData = {to: demo.address, value: amount}
        const tx = await sender.sendTransaction(txData)
        await tx.wait();
        return [tx, amount]
    }
    it('should allow to send money', async function () {
        const [sendMoneyTx, amount] = await sendMoney(other_addr)
        console.log(sendMoneyTx)
    })
})
