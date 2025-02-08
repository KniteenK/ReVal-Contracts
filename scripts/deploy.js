async function main() {
  // Get the deployer's account details
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();
  console.log("Deploying contracts with account:", deployerAddress);

  // Get the account balance using ethers v6 style (via the provider)
  const balance = await ethers.provider.getBalance(deployerAddress);
  console.log("Account balance:", balance.toString());

  // Get the contract factory and deploy the contract
  const Greeter = await ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello, Hardhat!");

  await greeter.deployed(); // Wait until deployment is complete
  console.log("Greeter deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
