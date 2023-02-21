// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Cryptography {

    ///@notice I use abi.encodePacked over abi.encode as it results in smaller encode data.
    ///@dev This code does not have any real use case. Just a collection of various cryptographic functions.
    
    // Simple keccak256 (sha-3) encoding function
    function keccak256Foo(string memory _string) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_string));
    }

    // Simple sha256 encoding function
    function sha256Foo(string memory _string) public pure returns(bytes32){
        return sha256(abi.encodePacked(_string));       
    }

    // Simpel rimpemd160 encoding function
    function ripemd160Foo(string memory _string) public pure returns(bytes32){
        return ripemd160(abi.encodePacked(_string));
    }

    ///@notice It is recommende to always use keccak256 hash algorithm. It's considered more faster and efficient.

    /*
        recover() for signature verification
        additional information https://docs.openzeppelin.com/contracts/2.x/utilities
    */
    function recoverAddress(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public pure returns(address){
        return ecrecover(hash, v, r, s);
    }
}
