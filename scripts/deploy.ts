const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    // console.log("Contract deployed to:", nftContract.address);
    console.log(`Contract deployed to: ${nftContract.address} on ${process.env.HARDHAT_NETWORK}`);
  
    // Call the function.
    let txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    await txn.wait()
    console.log("Minted NFT #1")
  
    txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    await txn.wait()
    console.log("Minted NFT #2")

    // // Self-destruct the contract
    // txn = await nftContract.destroySmartContract(nftContract.address);
    // // Wait for it to be destroyed.
    // await txn.wait()
  
    // txn = await nftContract.makeAnEpicNFT()
    // // Wait for it to be mined.
    // await txn.wait()
    // console.log("Minted NFT #3 ... shouldn't have shown other logging now contract code has gone.")
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