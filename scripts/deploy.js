async function main() {
  // Retrieve the deployer's account
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();
  console.log("Deploying contracts with account:", deployerAddress);

  // Get the account balance using ethers v6 style (via the provider)
  const balance = await ethers.provider.getBalance(deployerAddress);
  console.log("Account balance:", balance.toString());

  // Get the contract factory for the CircularMarketplace contract
  const CircularMarketplace = await ethers.getContractFactory("CircularMarketplace");
  
  // Deploy the contract (no constructor parameters needed)
  const circularMarketplace = await CircularMarketplace.deploy();

  // Wait until the deployment is complete (ethers v6 uses waitForDeployment)
  await circularMarketplace.waitForDeployment();
  console.log("CircularMarketplace deployed to:", circularMarketplace.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
