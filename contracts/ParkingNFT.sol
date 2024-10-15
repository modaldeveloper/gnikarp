// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ParkingNFT is ERC721, Ownable {
    uint256 public nextTokenId;

    constructor() ERC721("ParkingNFT", "PNFT") {}

    function mintParkingNFT(address to) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _mint(to, tokenId);
        nextTokenId++;
    }
}
