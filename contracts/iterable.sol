// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract iterableMapping {
    mapping(address => uint) balances;
    mapping(address => bool) inserted;

    address[] keys;

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function input(uint value) external {
        balances[msg.sender] = value;

        if (!inserted[msg.sender]) {
            inserted[msg.sender] = true;
            keys.push(msg.sender);
        }
    }

    function return1() external view returns (uint) {
        return balances[keys[0]];
    }

    function returnLength() external view returns (uint) {
        return keys.length;
    }

    function returnAparticularIndex(uint index) external view returns (uint) {
        return balances[keys[index]];
    }
}


///address(this) : the owner who deployed  the contract
contract creat2guessAddress {

    event deployed(address contractAddress);

    function createContract(uint _salt) external returns (address) {
        iterableMapping _contract = new iterableMapping
            {salt: bytes32(_salt)}
            (msg.sender);

            emit deployed(address(_contract));

            return address(_contract);
    }

    function create2(bytes calldata _bytecode, uint _salt)
        external
        view
        returns(address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(_bytecode)
            )
        );

        return address(uint160(uint(hash)));
    }

    function bytcode(address owner) external pure returns (bytes memory) {
        bytes memory bytecodes = type(iterableMapping).creationCode;
        return abi.encodePacked(bytecodes, abi.encode(owner));
    }
}

///address(this) : the owner who deployed  the contract