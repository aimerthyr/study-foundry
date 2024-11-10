// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    /**
     * 测试 setOwner 时，必须是 owner
     */
    function testSetOwnerMustBeOwner() public {
        // 修改 msg.sender => address(1)
        vm.prank(address(1));
        vm.expectRevert("caller is not owner");
        wallet.setOwner(address(2));
    }

    function testSetOwnerMustBeOwnerAgain() public {
        // 修改 owner 为 address(1) 此时不会报错 因为 msg.sender 是就是当前合约的 owner
        wallet.setOwner(address(1));
        // 由于 vm.prank 只会对下面第一行生效，如果我们有多次修改的话，可以使用 vm.startPrank 和 vm.stopPrank 来控制
        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        vm.stopPrank();
        // stopPrank 调用结束，msg.sender 又会变成当前的合约地址 address(this)，由于之前已经将owner修改为 address(1) 那么下一行再次调用就会报错
        vm.expectRevert("caller is not owner");
        wallet.setOwner(address(1));
    }
}
