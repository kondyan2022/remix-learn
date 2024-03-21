const {expect} = require('chai')
const {ethers} = require('hardhat')

describe('Payments', function () {
    let acc1
    let acc2
    let payments

    beforeEach(async function () {
        ;[acc1, acc2] = await ethers.getSigners()
        const Payments = await ethers.getContractFactory('Payments', acc1)
        payments = await Payments.deploy()
        await payments.deployed()
        console.log(payments.address)
    })
    it('should be deployed', async function () {
        expect(payments.address).to.be.properAddress
    })
    it('should have 0 eather by default', async function () {
        const balance = await payments.currentBalance()
        console.log(balance)
        expect(balance).to.eq(0)
    })
    it('should be possible to send funds', async function () {
        const startBalance = await acc2.getBalance()
        console.log('Balance before ', startBalance)
        const tx = await payments
            .connect(acc2)
            .pay('hello from hardhat', {value: 100})
        await tx.wait()
        await expect(() => tx).to.changeEtherBalances(
            [acc2, payments],
            [-100, 100]
        )
        const finishBalance = await acc2.getBalance()
        console.log('Balance after', await acc2.getBalance())
        console.log('Delta', finishBalance - startBalance)
        const balance = await payments.currentBalance()
        console.log(balance)
        expect(balance).to.eq(100)

        const newPayment = await payments.getPayment(acc2.address, 0)
        expect(newPayment.message).to.eq("hello from hardhat")
        expect(newPayment.amount).to.eq(100)
        expect(newPayment.from).to.eq(acc2.address)
    })
})
