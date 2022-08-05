import { ethers } from "hardhat";

async function main() {
  const l2_user = ethers.BigNumber.from(
    "1424123232705402199275974841415322067115068742167828463063108859871003787596"
  );
  const L1Receiver = await ethers.getContractFactory("L1Receiver");
  const l1Receiver = await L1Receiver.deploy();
  await l1Receiver.deployed();

  console.log("L1Receiver address: ", l1Receiver.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
