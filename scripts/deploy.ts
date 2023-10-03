require("dotenv").config();
import { ethers } from "hardhat";
import { HogwartsCardFactory } from "../typechain-types";

async function main() {
  const HogwartsCardFactory_factory = await ethers.getContractFactory(
    "HogwartsCardFactory"
  );
  const hogwartsCardFactory: HogwartsCardFactory =
    (await HogwartsCardFactory_factory.deploy()) as HogwartsCardFactory;

  console.log("contract deployed to:", await hogwartsCardFactory.address);
}

main()
  .then(() => (process.exitCode = 0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
