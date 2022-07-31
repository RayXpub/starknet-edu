import { ethers } from "hardhat";

async function main() {
  const l2_user = ethers.BigNumber.from(
    "1424123232705402199275974841415322067115068742167828463063108859871003787596"
  );

  const L2Messager = await ethers.getContractFactory("L2Messager");
  const l2Messager = await L2Messager.deploy(l2_user);

  await l2Messager.deployed();
  console.log("Lock with 1 ETH deployed to:", l2Messager.address);
  await l2Messager.sendMessageToL2();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
