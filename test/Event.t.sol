// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/Event.sol";

contract EventTest is Test {
    Event public e;

    // 测试合约中，需要写一个同名的 event
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        e = new Event();
    }

    function testTransfer() public {
        /**
         * 一共有四个参数
         * 前三个参数是针对 indexed 修饰的参数 如果设置为 true 代表需要校验，false 代表不需要校验
         * 最后一个参数是数据
         */
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(1), 200);
        e.transfer(address(this), address(1), 200);
    }

    function testBatchTransfer() public {
        address[] memory tos = new address[](2);
        uint256[] memory amounts = new uint256[](2);
        tos[0] = address(1);
        tos[1] = address(2);
        amounts[0] = 200;
        amounts[1] = 400;
        for (uint256 i = 0; i < tos.length; i++) {
            // 每次调用的时候，都需要校验
            vm.expectEmit(true, true, false, true);
            emit Transfer(address(this), tos[i], amounts[i]);
        }
        e.batchTransfer(address(this), tos, amounts);
    }
}
