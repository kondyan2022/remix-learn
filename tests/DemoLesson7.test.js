const {expect} = require('chai')
const {ethers} = require('hardhat')

describe('DemoSeven', function () {
    let owner
    let other_addr
    let demoSeven

    beforeEach(async function () {
        [owner, other_addr] = await ethers.getSigners()
        const DemoSevenContract = await ethers.getContractFactory('DemoSeven', owner)
        demoSeven = await DemoSevenContract.deploy()
        await demoSeven.deployed()
        console.log("Contract deployed")
    })

    async function sendMoney(sender) {
        const amount = 100
        const txData = {to: demoSeven.address, value: amount}
        const tx = await sender.sendTransaction(txData)
        await tx.wait();
        return [tx, amount]
    }

    it('should allow to send money', async function () {
        // const [sendMoneyTx, amount] = await sendMoney(other_addr)
        // console.log(sendMoneyTx)
                console.log("nntcn")
    })
})
