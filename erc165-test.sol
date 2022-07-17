pragma solidity >= 0.7.0 < 0.9.0;

interface IERC165 {
    //interface will only contain unimplemented functions
    function supportsInterface(bytes4 interfaceId) external view returns(bool); // this fuction checks if our smart contract supports the interface
    // function balanceOf(address _owner) external view returns (uint256); // another function, just for example to override in ERC165 contract
}

contract ERC165 is IERC165 {
    // a basic byte calculation interface function algorithm
    function calcFingerPrint() public view returns(bytes4) {
        return bytes4(keccak256('supportsInterface(bytes4)')); // --> only for one function
        // supportsInterface function value: 0x01ffc9a7
        // if we have multiple functions we will have to calculate with a XOR operation:
        // return bytes4(keccak256('supportsInterface(bytes4)')^
        // keccak256('balanceOf(bytes4)'));
        // WE GOT A NEW HASH! VALUE: 0x8b81fe23
        // The hash value obtained from this function will be used to register in supportsInterface
        // function by passing in the hash as interfaceId
    }


    // hash table to keep track of contract fingerprint data of byte function conversions
    mapping(bytes4=>bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceId) external override view returns(bool) {
        return _supportedInterfaces[interfaceId];
    }

    // overriding balanceOf function just to demonstrate the different hash example
    // function balanceOf(address _owner) external override view returns (uint256) {
    //     return 5; // just an example, chill... 
    // }


    constructor() {
        _registerInterface(0x01ffc9a7);
    }

    // registering the interface(comes from within) -> this changes often :( => more work
    // usually we should use OpenZeppelin standardisation 
    function _registerInterface(bytes4 interfaceId) public {
        require(interfaceId!=0xffffffff, 'ERC165: Invalid Interface!'); // interfaceId shouldn't be blank!
        _supportedInterfaces[interfaceId] = true;
    }
}
