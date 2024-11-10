// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 amout) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(amout);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "caller is not owner");
        owner = payable(_owner);
    }
}
