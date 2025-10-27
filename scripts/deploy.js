const hre = require("hardhat");

async function main() {
  const ProofCloud = await hre.ethers.getContractFactory("ProofCloud");
  const proofCloud = await ProofCloud.deploy();

  await proofCloud.waitForDeployment();
  console.log("✅ ProofCloud deployed to:", await proofCloud.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
