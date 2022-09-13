// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // Add owner tracking to allow destroy command
  address public owner;

  // We need to pass the name of our NFTs token and its symbol.
  //constructor() ERC721 ("SquareNFT", "SQUARE") {
  constructor() ERC721 ("Epic NFT", "EP!C") {
    owner = msg.sender;
    console.log("This is my NFT contract. Epic!");
  }

  // A function our user will hit to get their NFT.
  function makeAnEpicNFT() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data.
    // _setTokenURI(newItemId, "blah");
    // _setTokenURI(newItemId, "https://api.npoint.io/86ce62f99d90f2d656b1"); // Spongebox Cowboy Pants
    // NB: Edit on https://www.npoint.io/docs/20af4aabe6a0e92de44f // 3476604559_An_HD_photo_of_a_purple_sifaka.png / ipfs://QmPk5vPprBg436yxq1VCcU8LCCVNAzaysPwuxUJ3A28FYE
    //_setTokenURI(newItemId, "https://api.npoint.io/20af4aabe6a0e92de44f"); // 3476604559_An_HD_photo_of_a_purple_sifaka.png / ipfs://QmPk5vPprBg436yxq1VCcU8LCCVNAzaysPwuxUJ3A28FYE
    // Swapped to encoded JSON without npoint.io hosting
    _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiMzQ3NjYwNDU1OV9Bbl9IRF9waG90b19vZl9hX3B1cnBsZV9zaWZha2EucG5nIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBIHN0YWJsZSBkaWZmdXNpb24gZ2VuZXJhdGVkIHB1cnBsZSBzaWZha2EgcGhvdG8uIiwKICAgICJpbWFnZSI6ICJpcGZzOi8vUW1QazV2UHByQmc0MzZ5eHExVkNjVThMQ0NWTkF6YXlzUHd1eFVKM0EyOEZZRSIKfQ==");

    // Log the activity
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
  }

    // Include a self-destruct function
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
}
