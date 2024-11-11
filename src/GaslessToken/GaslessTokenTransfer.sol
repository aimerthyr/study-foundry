// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "./IERC20Permit.sol";

contract GaslessTokenTransfer {
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // 调用合约中的鉴权方法
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);
        // 调用合约中的转账方法
        IERC20Permit(token).transferFrom(sender, receiver, amount);
        // 最后将手续费转账给调用者
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
