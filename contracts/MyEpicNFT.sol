// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // Provides Strings.toString(UINT256) and JSON helpers
// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  // Add owner tracking to allow destroy command and/or owner-creation lock
  // address public owner;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Amazing", "Great", "Odd", "Interesting", "Flawed", "Obscure", "Radiant", "Opaque", "Obscured", "Illuminating", "Surprising", "Ordinary", "Juxtaposed", "Individual", "Underrated", "Blissful"];
  string[] secondWords = ["Dog", "Person", "Robot", "Computer", "Program", "Code", "Cat", "Dingo", "Lemur", "Postman", "Worker", "Hobbit", "Elf", "Mouse", "Dragon"];
  string[] thirdWords = ["Wrangler", "Leader", "Chief", "Underling", "Coordinator", "Usurper", "Destroyer", "Battler", "Regent", "Creator", "Nemesis", "Champion"];

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    // uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", msg.sender, Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    // uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", msg.sender, Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    // uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", msg.sender, Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("SquareNFT", "SQUARE") {
  //constructor() ERC721 ("Epic NFT", "EP!C") {
    // owner = msg.sender;
    //console.log("This is my NFT contract. Epic!");
    console.log("This is my NFT contract. Woah!");
  }

  // A function our user will hit to get their NFT.
  function makeAnEpicNFT() public {
    // * Lock minting to the owner
    // require(msg.sender == owner, 'Only the owner can mint NFT');

    // * Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

    // * We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    // * Generating SVG from words
    // ** I concatenate it all together, and then close the <text> and <svg> tags.
    // string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
    // string memory combinedWord = string(abi.encodePackged(first,second,third));
    string memory combinedWord = string(abi.encodePacked(first,'-',second,'-',third));
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    console.log("\n--------------------", finalSvg,"--------------------\n");
    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");
    
    // console.log('makeAnEpicNFT: Preparing to mint ', newItemId, '...');
    console.log(string(abi.encodePacked('makeAnEpicNFT: Preparing to mint ', Strings.toString(newItemId), ' with words=[',first,',',second,',',third,'], ...')));

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);
    
    console.log('- Token minted, setting token URI ...');

    // Set the NFTs data.
    // _setTokenURI(newItemId, "https://api.npoint.io/86ce62f99d90f2d656b1"); // Spongebox Cowboy Pants
    // NB: Edit on https://www.npoint.io/docs/20af4aabe6a0e92de44f // 3476604559_An_HD_photo_of_a_purple_sifaka.png / ipfs://QmPk5vPprBg436yxq1VCcU8LCCVNAzaysPwuxUJ3A28FYE
    // _setTokenURI(newItemId, "https://api.npoint.io/20af4aabe6a0e92de44f"); // 3476604559_An_HD_photo_of_a_purple_sifaka.png / ipfs://QmPk5vPprBg436yxq1VCcU8LCCVNAzaysPwuxUJ3A28FYE
    // Swapped to encoded JSON without npoint.io hosting
    // _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiMzQ3NjYwNDU1OV9Bbl9IRF9waG90b19vZl9hX3B1cnBsZV9zaWZha2EucG5nIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBIHN0YWJsZSBkaWZmdXNpb24gZ2VuZXJhdGVkIHB1cnBsZSBzaWZha2EgcGhvdG8uIiwKICAgICJpbWFnZSI6ICJpcGZzOi8vUW1QazV2UHByQmc0MzZ5eHExVkNjVThMQ0NWTkF6YXlzUHd1eFVKM0EyOEZZRSIKfQ==");
    _setTokenURI(newItemId, finalTokenUri); // Now using encoded SVG

    // Log the activity
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
  }

    // // Include a self-destruct function
    // function destroySmartContract(address payable _to) public {
    //     require(msg.sender == owner, "You are not the owner");
    //     selfdestruct(_to);
    // }
}
