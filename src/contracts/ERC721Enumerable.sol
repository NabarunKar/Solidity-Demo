// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256=>uint256) private _allTokensIndex;

    // mapping from owner to list of all owned token IDs
    mapping(address=>uint256[]) private _ownedTokens; // owner lists

    // mapping from token ID index to owner tokens list
    mapping(uint256=>uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^
        keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    
    
    // return the total supply of the allTokens array
    function totalSupply() public override view returns (uint256) {
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    // function tokenByIndex(uint256 _index) external view returns (uint256); 
    
    // the next 6 lines originally had preceding /// instead of //
    // @notice Enumerate NFTs assigned to an owner
    // @dev Throws if `_index` >= `balanceOf(_owner)` or if
    //  `_owner` is the zero address, representing invalid NFTs.
    // @param _owner An address where we are interested in NFTs owned by them
    // @param _index A counter less than `balanceOf(_owner)`
    // @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);

    function _mint(address to, uint256 tokenId) internal override(ERC721) { // this function overrides the _mint function in ERC721.sol
        super._mint(to, tokenId); // calling the mint function of ERC721.sol
        
        // Now we need to add tokens to the (a) Owner (b) _allTokens
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _allTokens array and set the position of the token's indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length; // the position is kept track of
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        // we wanna:
        // a. add address and tokenId to _ownedTokens
        // b. ownedTokensIndex tokenId set to address of ownedTokens position
        // c. call this function as part of the minting process.
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length; // step b
        _ownedTokens[to].push(tokenId);                      // step a
    }

    // now let's write two more functions:
    // 1. one that returns tokenByIndex
    // 2. one that returns tokenOfOwnerByOwnerIndex

    // function 1 -> is going to search through indexes for us, a helper function
    function tokenByIndex(uint256 index) public override view returns(uint256) {
        require(index < totalSupply(), 'Index out of bounds!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256) {
        require(index < balanceOf(owner), 'Owner Index out of bounds!');
        return _ownedTokens[owner][index];
    }
}