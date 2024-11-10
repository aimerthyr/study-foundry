// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract Event {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function transfer(address from, address to, uint256 amount) public {
        emit Transfer(from, to, amount);
    }

    function batchTransfer(address from, address[] calldata tos, uint256[] calldata amounts) public {
        for (uint256 i = 0; i < tos.length; i++) {
            transfer(from, tos[i], amounts[i]);
        }
    }
}
