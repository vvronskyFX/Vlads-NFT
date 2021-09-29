// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract VladsNFT is ERC721URIStorage {

	// Magic given to us by OpenZepplin to help us keep track of token Ids.
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";

  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Jupiter", "Pluto", "Uranus", "Earth", "Saturn", "Venus", "Mercury", "Mars", "Neptune"];
    string[] secondWords = ["Galaxy", "Space", "Universe", "Exoplanet", "Metagalaxy", "Interstellar", "Constellation", "Nebula", "Void"];
    string[] thirdWords = ["Sword", "Blast", "Smoke", "Vibes", "Annihilation", "Growth", "Adventure", "Exploration", "Travel"];

      // Get fancy with it! Declare a bunch of colors.
    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green", "#3C43B0", "#C48BEA", "#38A54A"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721("GalaxyNFT", "SPACE") {
		console.log("This is my space inspired NFT Contract. Sick!");
	}

	// I create a function to randomly pick a word & color from each array.
	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
	   // I seed the random generator.
	   uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
	   // Squash the # btwn 0 and the length of the array to avoid going out of bounds.
	   rand = rand % firstWords.length;
	   return firstWords[rand];
	}

  	function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
       uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
       rand = rand % secondWords.length;
       return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
       uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
       rand = rand % thirdWords.length;
       return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
       uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
       rand = rand % colors.length;
       return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
    	return uint256(keccak256(abi.encodePacked(input)));
    } 

    // A function our user will hit to get their NFT.
	function makeAnEpicNFT() public {

	  // Get the current NFT Id, this starts at 0.
	  uint256 newItemId = _tokenIds.current();

	  // We go and randomly grab one word from each of the three arrays.
   	  string memory first = pickRandomFirstWord(newItemId);
      string memory second = pickRandomSecondWord(newItemId);
      string memory third = pickRandomThirdWord(newItemId);
      string memory combinedWord = string(abi.encodePacked(first, second, third));
      string memory randomColor = pickRandomColor(newItemId); // Add the random color in.
    // I concatenate it all together, and then close the <text> and <svg> tags.
      string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

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

	  // Actually mint the NFT to the sender using msg.sender
	  // msg.sender is to WHO the NFT is minted for and sent to.
	  _safeMint(msg.sender, newItemId);

	  // Set the NFTs data.
	  _setTokenURI(newItemId, finalTokenUri);

	  // Increment the coutner for when the next NFT is minted.
	  _tokenIds.increment();

	  console.log("Nice! You've minted an NFT with ID %s to %s", newItemId, msg.sender);
    
    emit NewEpicNFTMinted(msg.sender, newItemId);

	}
}

// Remember to redeploy smart contract everytime I make changes here.