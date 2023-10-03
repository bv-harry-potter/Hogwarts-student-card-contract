import { ethers } from "hardhat";
import { expect } from "chai";
import { Signer } from "ethers";
import { HogwartsCardFactory } from "../typechain-types";

describe("UnemployedCardNFTFactory", () => {
  let hogwartsCardFactory: HogwartsCardFactory;
  let owner: Signer;
  let addr: Signer;

  // deploy test
  beforeEach(async () => {
    const HogwartsCardFactory_factory = await ethers.getContractFactory(
      "HogwartsCardFactory"
    );
    hogwartsCardFactory =
      (await HogwartsCardFactory_factory.deploy()) as HogwartsCardFactory;
    [owner, addr] = await ethers.getSigners();
  });

  describe("Minting Test", () => {
    it("Should mint a new Hogwarts NFT Card", async () => {
      await hogwartsCardFactory
        .connect(addr)
        .mintHogwartsCard(
          "Jiwoo Yun",
          "22",
          "래번클로의 반장",
          "INTJ",
          "독서, 영화보기, 마법주문 적용해보기",
          "1",
          "혼혈(Half)",
          "래번클로(Ravenclaw)"
        );
      expect(
        await hogwartsCardFactory.balanceOf(await addr.getAddress())
      ).to.equal(1);
    });
  });
});
