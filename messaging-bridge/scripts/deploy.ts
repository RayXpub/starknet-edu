import { ethers } from "hardhat";

async function main() {
  const l2_user = ethers.BigNumber.from(
    "1424123232705402199275974841415322067115068742167828463063108859871003787596"
  );
  const evaluator = ethers.BigNumber.from(
    "2526149038677515265213650328426051013974292914551952046681512871525993794969"
  );

  const L2Messager = await ethers.getContractFactory("L2Messager");
  const l2Messager = await L2Messager.deploy(l2_user, evaluator);
  await l2Messager.deployed();

  console.log("L2Messager address: ", l2Messager.address);
  const tx = await l2Messager.sendMessageToL2();
  await tx.wait(1);
  const msgHash = await l2Messager.lastMsg();
  console.log("Message hash: ", msgHash);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
