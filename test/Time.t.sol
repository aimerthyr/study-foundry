// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/Time.sol";

/**
 * 时间相关函数
 * vm.warp	将区块时间设置为指定时间戳	测试涉及特定日期的逻辑
 * vm.roll	设置当前区块高度	测试区块高度相关的逻辑
 * skip	向前推进指定秒数	模拟时间流逝，例如等待定时器到期
 * rewind	向后倒退指定秒数	模拟历史回溯，测试过去状态的逻辑
 */
contract AuctionTest is Test {
    Auction public auction;

    function setUp() public {
        auction = new Auction();
    }

    function testBidAfterStartAt() public {
        // vm.warp 函数可以设置当前的时间戳
        vm.warp(block.timestamp + 1 days);
        auction.bid();
    }

    function testBidBefortEndAt() public {
        vm.warp(block.timestamp + 2 days);
        auction.bid();
    }

    function testEndBeforeEndAtFail() public {
        vm.expectRevert("cannot end");
        auction.end();
    }

    function testTimeFunc() public {
        vm.roll(200);
        assertEq(block.number, 200);
        uint256 time = block.timestamp;
        // 往后延迟 300 秒
        skip(300);
        assertEq(block.timestamp, time + 300);
        // 再往前回溯 100 秒
        rewind(100);
        assertEq(block.timestamp, time + 200);
    }
}
