// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector { // this is inheritance 

    string[] public kryptoBirdz; // array to store our NFTs

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {

        //require that the current kryptoBird being minted does not already exist
        require(!_kryptoBirdzExists[_kryptoBird], 'Error - kryptoBird already exists!');

        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;

        //running the mint function from ERC721.sol:
        _mint(msg.sender, _id); // msg.sender = first address on Ganache
        _kryptoBirdzExists[_kryptoBird] = true;
    }

    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {
        

    }
}