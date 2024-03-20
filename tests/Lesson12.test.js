const {expect} = require('chai')
const {ethers} = require('hardhat')

describe('Demo12', function () {
    let owner
    let demo

    beforeEach(async function () {
        ;[owner] = await ethers.getSigners()

        const Logger = await ethers.getContractFactory('Logger12', owner)
        const logger = await Logger.deploy()
        await logger.deployed()
        const loggerAddress = logger.address
        const Demo = await ethers.getContractFactory('Demo12', owner)
        demo = await Demo.deploy(loggerAddress)
        await demo.deployed()
    })

    it('allows to pay and get payment info', async function () {
        const sum = 100
        const txData = {
            value: sum,
            to: demo.address,
        }
        console.log('Pass 1', txData)
        const tx = await owner.sendTransaction(txData)
        console.log('Pass 2')
        await tx.wait()
        console.log('Pass 3')

        await expect(tx).to.changeEtherBalance(demo, sum)

        const amount = await demo.payment(owner.address, 0)

        expect(amount).to.eq(sum)
    })
})
