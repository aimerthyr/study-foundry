// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract Error {
    // 自定义一个错误
    error NotAuthorized();

    function throwError() external pure {
        require(false, "not authorized");
    }

    function thowCustormError() external pure {
        revert NotAuthorized();
    }
}
