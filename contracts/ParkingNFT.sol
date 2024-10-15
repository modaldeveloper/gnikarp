// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ParkingRights is ERC721, Ownable {
    struct ParkingSpot {
        uint id;
        string location;
        bool isAvailable;
    }

    ParkingSpot[] public parkingSpots;
    uint256 public nextTokenId;

    constructor() ERC721("ParkingNFT", "PNFT") {
        // Initialize with some parking spots
        parkingSpots.push(ParkingSpot(1, "Location A", true));
        parkingSpots.push(ParkingSpot(2, "Location B", true));
    }

    // Function to get available parking spots
    function getAvailableParkingSpots() public view returns (ParkingSpot[] memory) {
        ParkingSpot[] memory availableSpots = new ParkingSpot[](parkingSpots.length);
        uint count = 0;
        for (uint i = 0; i < parkingSpots.length; i++) {
            if (parkingSpots[i].isAvailable) {
                availableSpots[count] = parkingSpots[i];
                count++;
            }
        }
        return availableSpots;
    }

    // Function to add a parking spot
    function addParkingSpot(string memory location) public onlyOwner {
        parkingSpots.push(ParkingSpot(parkingSpots.length + 1, location, true));
    }

    // Mint NFT representing ownership of a parking spot
    function mintParkingNFT(address to, uint parkingSpotId) public onlyOwner {
        require(parkingSpots[parkingSpotId].isAvailable, "Parking spot is not available");
        uint256 tokenId = nextTokenId;
        _mint(to, tokenId);
        nextTokenId++;

        // Once minted, mark the parking spot as unavailable
        parkingSpots[parkingSpotId].isAvailable = false;
    }

    // Function to transfer ownership of a parking NFT and update the availability of the spot
    function transferParkingNFT(address from, address to, uint256 tokenId) public {
        // Transfer the NFT to the new owner
        safeTransferFrom(from, to, tokenId);

        // Optionally, update the parking spot availability or any other logic
    }
}
