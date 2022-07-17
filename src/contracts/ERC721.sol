// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

    /*
    We want to keep track of in the MINTING FUNCTION:    
        a. nft to point to an address
        b. keep track of token ids
        c. keep track of token owner addresses to token ids - we use mapping for this
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract
        address, where it is being minted to and its id.

    */

contract ERC721 is ERC165, IERC721 {
    // log: commented out since its a part of IERC721 now
    // event Transfer( address indexed from, 
    //                 address indexed to, 
    //                 uint256 indexed tokenId);


    // mapping creates hash table of key pair values

    //Mapping from token id to owner:
    mapping(uint => address) private _tokenOwner;

    //Mapping from owner to number of owned tokens:
    mapping(address => uint) private _ownedTokensCount;

    //Mapping from tokenId to approved addresses
    mapping(uint256 => address) private _tokenApprovals;


    // balanceOf function
    // Notes from eips.ethereum.org:
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) public override view returns(uint256) {
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

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner!=address(0), 'Owner address does not exist.');
        return owner;
    }


    // a function that checks whether the tokenID exists:
    function _exists(uint256 tokenID) internal view returns(bool) {
        address owner = _tokenOwner[tokenID];
        // return truthiness that address is not 0
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal virtual { // virtual is written to specify this function is gonna be overridden (in ERC721Enumerable.sol)
        //requires that address isn't zero:
        require(to!=address(0), 'ERC721 cannot mint to a zero address!');
        // requires the token ID TO NOT EXIST, i.e., the token should not be present previously.
        require(!_exists(tokenId), 'Token already minted!');
        //updates the _tokenOwner map
        _tokenOwner[tokenId] = to;
        //updates the _ownedTokensCount map
        _ownedTokensCount[to] += 1;

        //emit logs
        // emit Transfer(address(0), to, tokenId); 
    }

    // MISSED FUNCTIONS
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not possess');

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }
    
    // 1. require that the person approving is the owner
    // 2. we are approving an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner
    // 4. update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token.');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender==owner);
    }
}