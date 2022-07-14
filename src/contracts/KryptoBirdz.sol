// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract Kryptobird is ERC721Connector {

    string[] public kryptoBirdz; // array to store our NFTs

    function mint(string memory _kryptoBird) public {

        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;

        //running the mint function from ERC721.sol:
        _mint(msg.sender, _id);
    }

    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {
        

    }
}