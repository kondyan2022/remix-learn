const {expect} = require('chai')
const {ethers} = require('hardhat')

describe('LibDemo', function () {
    let owner
    let demo

    beforeEach(async function () {
        ;[owner] = await ethers.getSigners()

        const Demo = await ethers.getContractFactory('LibDemo', owner)
        demo = await Demo.deploy()
        await demo.deployed()
    })

    it('compares string', async function () {
        const result = await demo.runnerStr("cat", "cat");
        expect(result).to.eq(true);

        const result2 = await demo.runnerStr("cat", "dog");
        expect(result2).to.eq(false);
    })
    it('find uint in array', async function () {
        const result = await demo.runnerArr([1,2,3], 2);
        expect(result).to.eq(true);

        const result2 = await demo.runnerArr([1,2,3], 42);
        expect(result2).to.eq(false);
    })


})