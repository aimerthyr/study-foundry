// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/Error.sol";

contract ErrorTest is Test {
    Error public errors;

    function setUp() public {
        errors = new Error();
    }

    function testRequireMessage() public {
        vm.expectRevert("not authorized");
        errors.throwError();
    }

    function testCustromError() public {
        // 断言自定义错误，需要拿到错误的 selector
        vm.expectRevert(Error.NotAuthorized.selector);
        errors.thowCustormError();
    }

    function testErrorLabel() public pure {
        // assertEq 最后一个参数为 label，用于标记错误，这样在大量测试的时候可以准确查看出错的具体位置
        assertEq(address(1), address(1), "test 1");
        assertEq(address(1), address(1), "test 2");
        assertEq(address(1), address(1), "test 3");
        assertEq(address(1), address(1), "test 4");
        assertEq(address(1), address(1), "test 5");
    }
}
