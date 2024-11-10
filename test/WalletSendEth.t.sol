// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/Wallet.sol";

/**
 * deal(address user, uint256 balance); 设置某个地址的余额（deal + prank = hoax）
 * hoax(address user, uint256 balance); 设置某个地址余额，并切换 msg.sender 为该地址
 */
contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function _send(uint256 amount) private {
        (bool success,) = payable(wallet).call{value: amount}("");
        require(success, "send eth failed");
    }

    function testSendEth() public {
        // 获取当前 wallet 合约的余额
        uint256 bal = address(wallet).balance;
        // 设置 地址1 的余额为 100
        deal(address(1), 100);
        // 修改 msg.sender 为 地址1
        vm.prank(address(1));
        // 修改完 sender 之后，那就是从地址1进行转账，如果不修改就会变成从这个测试合约进行转账
        _send(100);
        // 由于转账了，所以这里就会是 0
        console.log(address(1).balance, "address(1) balance");
        // 钱包的金额新增 100
        assertEq(address(wallet).balance, bal + 100);
    }

    function testSendEthByHoax() public {
        // 设置 地址 1 的余额，并且切换 msg.sender 为 地址1
        hoax(address(1), 200);
        // 向钱包中转账 100 此时自己还剩下 100
        _send(100);
        assertEq(address(1).balance, 100);
    }
}
