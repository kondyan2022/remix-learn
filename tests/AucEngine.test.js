const {expect} = require('chai')
const {ethers, waffle} = require('hardhat')


describe('AucEngine', function () {
    let owner
    let seller
    let buyer
    let auct

    beforeEach(async function () {
        ;[owner, seller, buyer] = await ethers.getSigners()
        const AucEngine = await ethers.getContractFactory('AucEngine', owner)
        auct = await AucEngine.deploy()
        await auct.deployed()
    })
    it('set owner', async function () {
        const currentOwner = await auct.owner()
        console.log(currentOwner)
        expect(currentOwner).to.eq(owner.address)
    })

    async function getTimestamp(bn)   {
        return await ethers.provider.getBlock(bn);
    }

    describe('createAction', function () {
        it('creates auction correctly', async function () {
            const duration = 60
            const tx = await auct.createAuction(
                ethers.utils.parseEther('0.0001'),
                3,
                "fake item",
                duration
            )

            console.log("hereeeee")
            const cAuction = await auct.auctions(0)
            console.log(cAuction)
            expect(cAuction.item).to.eq('fake item')
            console.log(tx.blockNumber)
            // const provider= ethers.provider;
            // const  _block = await provider.getBlock(15);
            // const ts = await getTimestamp(tx.blockNumber)
            // expect(cAuction.endsAt).to.eq(ts + duration)
        })
    })
    function delay(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms))
        f
    }

    describe('buy', function () {
        it('allows to buy', async function () {
            const duration = 60

            const sellerBalance = await ethers.provider.getBalance(seller.address)
            console.log(sellerBalance)
            
            const tx = await auct.createAuction(
                ethers.utils.parseEther('0.0001'),
                3,
                'fake item',
                60
            )
            this.timeout(5000) //5s for test library

            await delay(1000)

            const byTx = await auct
                .connect(buyer)
                .buy(0, {value: ethers.utils.parseEther('0.0001')})

            const cAuction = await auct.auctions(0)
            const finalPrice = await cAuction.finalPrice
            const newSellerBalance = await ethers.provider.getBalance(seller.address)
                        console.log(newSellerBalance)
            // await expect(() => byTx).to.changeEtherBalance(
            //     seller,
            //     finalPrice - Math.floor(finalPrice * 10) / 100
            // )
        })
    })
})
