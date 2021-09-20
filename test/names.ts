import { ethers } from "hardhat";
import { expect } from "chai";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract, ContractFactory } from "@ethersproject/contracts";
import { BigNumber } from "@ethersproject/bignumber";

describe("Testing Names.sol", function() {
    
    // Get signers
    let deployer: SignerWithAddress;
    let minter: SignerWithAddress

    // Get contracts
    let Names_Factory: ContractFactory;
    let names: Contract;

    before(async () => {

        // Get signers
        [deployer, minter] = await ethers.getSigners();

        // Get Names.sol contract factory
        Names_Factory = await ethers.getContractFactory("Names");
    })

    beforeEach(async () => {
        // Get Names.sol contract
        names = await Names_Factory.connect(deployer).deploy("Names", "NAME");
    })

    it("Should mint an NFT and display its name", async () => {

        const desiredTokenId: number = 100;
        const nameOfDesiredToken: string = await names.getName(desiredTokenId);
        
        const nameMintedPromise = new Promise((resolve, reject) => {
            names.on("NameMinted", (_receiver, _tokenId, _name) => {
                expect(_receiver).to.equal(minter.address)
                expect(_tokenId).to.equal(desiredTokenId);
                expect(_name).to.equal(nameOfDesiredToken);

                console.log(`${minter.address} has a new name! It's ${_name}`);
                console.log(`${_name} is NFT with id ${_tokenId}`)

                resolve(null)
            })

            setTimeout(() => {
                reject(new Error("Timeout: NameMinted"))
            }, 5000)
        })

        await names.connect(minter).mintName(desiredTokenId);
        await nameMintedPromise;
    })

    it("Should revert when someone tries to mint an already minted NFT", async () => {
        const desiredTokenId: number = 100;

        const [,,someRandomMinter]: SignerWithAddress[] = await ethers.getSigners();

        // Shoot, someone minted the NFT with ID 100 before me.
        await names.connect(minter).mintName(desiredTokenId);

        await expect(names.connect(someRandomMinter).mintName(desiredTokenId)).to.be.revertedWith("ERC721: token already minted");
    })
})