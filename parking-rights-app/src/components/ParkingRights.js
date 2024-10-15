// src/components/ParkingRights.js

import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import contractABI from '../contractABI.json'; // ABI for the smart contract

// Define contract address (replace with your actual contract address)
const contractAddress = '0xYourSmartContractAddress';

const ParkingRights = () => {
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [parkingSpots, setParkingSpots] = useState([]);
  const [isConnected, setIsConnected] = useState(false);

  // Load Web3 and connect to the user's Ethereum wallet (e.g., MetaMask)
  useEffect(() => {
    const loadWeb3 = async () => {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        try {
          // Request wallet connection
          await window.ethereum.request({ method: 'eth_requestAccounts' });
          const accounts = await web3.eth.getAccounts();
          setAccount(accounts[0]);

          // Load the smart contract
          const contractInstance = new web3.eth.Contract(contractABI, contractAddress);
          setContract(contractInstance);

          setIsConnected(true);
        } catch (error) {
          console.error("Error connecting to wallet:", error);
        }
      } else {
        alert("Non-Ethereum browser detected. Please install MetaMask.");
      }
    };

    loadWeb3();
  }, []);

  // Function to fetch available parking spots from the contract (replace with actual contract logic)
  const getParkingSpots = async () => {
    if (contract) {
      try {
        const spots = await contract.methods.getAvailableParkingSpots().call();
        setParkingSpots(spots);
      } catch (error) {
        console.error("Error fetching parking spots:", error);
      }
    }
  };

  // Call getParkingSpots when the component mounts
  useEffect(() => {
    if (contract) {
      getParkingSpots();
    }
  }, [contract]);

  return (
    <div>
      <h1>Parking Rights Management</h1>

      {isConnected ? (
        <div>
          <p>Connected to wallet: {account}</p>

          <h2>Available Parking Spots</h2>
          {parkingSpots.length > 0 ? (
            <ul>
              {parkingSpots.map((spot, index) => (
                <li key={index}>Spot ID: {spot.id}, Location: {spot.location}</li>
              ))}
            </ul>
          ) : (
            <p>No parking spots available.</p>
          )}

          {/* Add more interaction components here, like MintNFT, TransferOwnership, etc. */}

        </div>
      ) : (
        <p>Please connect to MetaMask to manage parking rights.</p>
      )}
    </div>
  );
};

export default ParkingRights;
