const main = async () => {
    const networkName = hre.network.name;
    const chainId = hre.network.config.chainId;
    console.log('networkName: ', networkName, ', chainId: ', chainId);

    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    // console.log("Contract deployed to:", nftContract.address);
    console.log(`Contract deployed to: ${nftContract.address} on ${networkName}`);
  
    // Call the function.
    let txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    var results = await txn.wait()
    // console.log("Minted NFT #1")
    // console.log('- events: ', results.events);
    var transfer = results.events.find((e:any) => e.event === 'Transfer');
    console.log(`Minted NFT #${transfer.args.tokenId} on contract ${transfer.address}, tx# ${transfer.transactionHash}, to ${transfer.args.to}`);
    var response = await nftContract.tokenURI(transfer.args.tokenId);
    console.log(`tokenURI(${transfer.args.tokenId}): `, response);
    
    txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    var results = await txn.wait()
    transfer = results.events.find((e:any) => e.event === 'Transfer');
    // console.log("Minted NFT #2")
    // console.log('- events: ', results.events);
    console.log(`Minted NFT #${transfer.args.tokenId} on contract ${transfer.address}, tx# ${transfer.transactionHash}, to ${transfer.args.to}`);
    response = await nftContract.tokenURI(transfer.args.tokenId);
    console.log(`tokenURI(${transfer.args.tokenId}): `, response);
 
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