// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, stdError} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

/**
 *  forge test -h 可以查看 test 脚本更多阐述
 *  forge test -vvv 可以查看更多报错细节
 *  forge test --gas-report 可以查看 gas 使用情况
 *  forge test --match-path test/Counter.t.sol 可以指定测试文件
 */
contract CounterTest is Test {
    Counter public counter;

    /**
     * setUp 每次测试前都会被调用，必须是 public / external
     */
    function setUp() public {
        counter = new Counter();
    }

    /**
     * 前缀 test 代表是一个测试函数
     */
    function testInc() public {
        counter.inc();
        assertEq(counter.get(), 1);
    }

    /**
     * 前缀 testFail 代表当前这个函数必须失败，才算通过，这种写法一般不容易看出具体错误
     */
    function testFailPrecisionOverflow() public {
        counter.dec(); // 因为是无符号整数初始值是 0 ，减 1 的话就会溢出
    }

    /**
     * 使用 vm.expectRevert 来断言 这种写法容易看出具体什么错误
     */
    function testDescCanNotPrecisionOverflow() public {
        // 对下面执行的一次调用进行断言（只针对下面这一行，如果有多行可能的报错调用，则需要分装到一个函数中）
        vm.expectRevert(stdError.arithmeticError);
        counter.dec();
    }

    function testDec() public {
        counter.inc();
        counter.inc();
        counter.dec();
        assertEq(counter.get(), 1);
    }
}
