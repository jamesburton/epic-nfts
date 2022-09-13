// const MAX_TOKENS = 1;
// const TOKEN_NAME = 'SingletonNFT';
// const TOKEN = 'JUST1';
const MAX_TOKENS = 333;
const TOKEN_NAME = 'ThreeEpicWords';
const TOKEN = 'EPIC3';

const main = async () => {
    const networkName = hre.network.name;
    const chainId = hre.network.config.chainId;
    console.log('networkName: ', networkName, ', chainId: ', chainId);

    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    //const nftContract = await nftContractFactory.deploy();
    // const nftContract = await nftContractFactory.deploy(MAX_TOKENS);
    const nftContract = await nftContractFactory.deploy(TOKEN_NAME, TOKEN, MAX_TOKENS);
    await nftContract.deployed();
    // console.log("Contract deployed to:", nftContract.address);
    console.log(`Contract deployed to: ${nftContract.address} on ${networkName}`);

    const maxTokens = await nftContract.maxTokens();
    console.log(`- Max Tokens = ${await maxTokens}`);

    nftContract.on('AllNFTsMinted', () => console.log('*** All NFTs minted ***'));
  
    // Call the function.
    let txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    var results = await txn.wait()
    // console.log("Minted NFT #1")
    // console.log('- events: ', results.events);
    var transfer = results.events.find((e:any) => e.event === 'Transfer');
    var allMinted = results.events.find((e:any) => e.event === 'AllNFTsMinted');
    console.log(`Minted NFT #${transfer.args.tokenId} on contract ${transfer.address}, tx# ${transfer.transactionHash}, to ${transfer.args.to}`);
    var response = await nftContract.tokenURI(transfer.args.tokenId);
    console.log(`tokenURI(${transfer.args.tokenId}): `, response);

    var countResponse = (await nftContract.getMintedCount());
    console.log(`- Minted count=${countResponse}`);

    if(allMinted) {
        console.log('*** Received All NFTs minted event, further minting will cause errors!');
    }
    
    txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    var results = await txn.wait()
    transfer = results.events.find((e:any) => e.event === 'Transfer');
    // console.log("Minted NFT #2")
    // console.log('- events: ', results.events);
    console.log(`Minted NFT #${transfer.args.tokenId} on contract ${transfer.address}, tx# ${transfer.transactionHash}, to ${transfer.args.to}`);
    response = await nftContract.tokenURI(transfer.args.tokenId);
    console.log(`tokenURI(${transfer.args.tokenId}): `, response);

    var countResponse = (await nftContract.getMintedCount());
    console.log(`- Minted count=${countResponse}`);
 
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