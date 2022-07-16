// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

    /*
    We want to keep track of in the MINTING FUNCTION:    
        a. nft to point to an address
        b. keep track of token ids
        c. keep track of token owner addresses to token ids - we use mapping for this
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract
        address, where it is being minted to and its id.

    */

contract ERC721 {
    // log
    event Transfer( address indexed from, 
                    address indexed to, 
                    uint256 indexed tokenId);


    // mapping creates hash table of key pair values
    //Mapping from token id to owner:
    mapping(uint => address) private _tokenOwner;
    //Mapping from owner to number of owned tokens:
    mapping(address => uint) private _ownedTokensCount;


    // balanceOf function
    // Notes from eips.ethereum.org:
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner!=address(0), 'Owner address does not exist.');
        return _ownedTokensCount[_owner];
    }

    // ownerOf function
    // Notes from eips.ethereum.org:
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _tokenOwner[_tokenId];
        return owner;
    }


    // a function that checks whether the tokenID exists:
    function _exists(uint256 tokenID) internal view returns(bool) {
        address owner = _tokenOwner[tokenID];
        // return truthiness that address is not 0
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal {
        //requires that address isn't zero:
        require(to!=address(0), 'ERC721 cannot mint to a zero address!');
        // requires the token ID TO NOT EXIST, i.e., the token should not be present previously.
        require(!_exists(tokenId), 'Token already minted!');
        //updates the _tokenOwner map
        _tokenOwner[tokenId] = to;
        //updates the _ownedTokensCount map
        _ownedTokensCount[to] += 1;

        //emit logs
        emit Transfer(address(0), to, tokenId); 
    }
}