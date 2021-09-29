const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('VladsNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the Function.
  let txn = await nftContract.makeAnEpicNFT()
  
  // Wait for it to be minted.
  await txn.wait()

  console.log("Done minting first NFT!!")

  //Mint another NFT for fun.
  txn = await nftContract.makeAnEpicNFT()

  // wait for it to be minted.
  await txn.wait()

  console.log("Done minting second NFT!!")

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();