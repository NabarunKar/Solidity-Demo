// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721.sol'

contract ERC721Connector is ERC721Metadata, ERC721 {
    // constructor
    // the following constructor passes the name and symbol to the constructor of ERC721Metadata 
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {

    }
}
