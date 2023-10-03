import { ethers, utils } from "ethers";
import { HogwartsCardFactory } from "../typechain-types";
import { readFileSync } from "fs";
import { join } from "path";
const hh = require("hardhat");

const abiPath = join(
  __dirname,
  "../artifacts/contracts/HogwartsCardFactory.sol/HogwartsCardFactory.json"
);
// JSON 파싱
const abiJson = JSON.parse(readFileSync(abiPath, "utf8"));
const abi = abiJson.abi;
// 배포된 컨트랙트 주소
const contractAddress = "0xA07302EE1F4430Ad439752e98159DC2d5bF922b1";

async function main() {
  const provider = hh.ethers.provider; // Hardhat's built-in provider
  const privateKey = process.env.METAMASK_PRIVATE_KEY;

  if (!privateKey) {
    console.error("Please set the METAMASK_PRIVATE_KEY environment variable");
    process.exit(1);
  }
  const wallet = new hh.ethers.Wallet(privateKey, provider);
  const contract = new ethers.Contract(contractAddress, abi, provider).connect(
    wallet
  ) as HogwartsCardFactory;

  // Mint a new UnemployedCardNFT
  await contract.mintHogwartsCard(
    "Jiwoo Yun",
    "22",
    "래번클로의 반장",
    "INTJ",
    "독서, 영화보기, 마법주문 적용해보기",
    "1",
    "혼혈(Half)",
    "래번클로(Ravenclaw)",
    {
      value: utils.parseEther("0.01"),
    }
  );
  let tokenId = await contract.getTokenId();
  console.log("New UnemployedCardNFT Minted");
  console.log(`TokenId : ${tokenId}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
