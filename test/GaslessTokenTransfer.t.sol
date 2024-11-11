// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "@/GaslessToken/GaslessTokenTransfer.sol";
import "@/GaslessToken/ERC20Permit.sol";

contract GaslessTokenTransferTest is Test {
    ERC20Permit public token;
    GaslessTokenTransfer public gaslessTokenTransfer;
    uint256 constant SENDER_PRIVATE_KEY = 112233;
    address sender;
    address receiver = address(2);
    uint256 constant AMOUNT = 1000;
    uint256 constant FEE = 10;

    function setUp() public {
        // 通过私钥生成一个地址，作为发送方地址
        sender = vm.addr(SENDER_PRIVATE_KEY);

        token = new ERC20Permit("Token", "TKN", 18);
        // 给发送方地址铸币
        token.mint(sender, AMOUNT + FEE);
        gaslessTokenTransfer = new GaslessTokenTransfer();
    }

    function testSend() public {
        // 设置过期时间
        uint256 deadline = block.timestamp + 60;
        // 生成信息摘要（发送者地址，接收者地址，转账数量，手续费，过期时间）
        bytes32 messageHash =
            _getMessageHash(sender, address(gaslessTokenTransfer), AMOUNT + FEE, token.nonces(sender), deadline);
        // 用户再用自己的私钥和摘要信息进行签名（返回的三个参数就是签名的v、r、s 三个部分，它们共同组成了数字签名）
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SENDER_PRIVATE_KEY, messageHash);
        uint256 senderBalance = token.balanceOf(sender);
        gaslessTokenTransfer.send(address(token), sender, receiver, AMOUNT, FEE, deadline, v, r, s);
        // 执行完转账后，发送方的账户应该减少，接收方的账户应该增加，手续费账户应该减少
        assertEq(token.balanceOf(sender), senderBalance - AMOUNT - FEE, "sender");
        assertEq(token.balanceOf(receiver), AMOUNT, "receiver");
        assertEq(token.balanceOf(address(this)), FEE, "fee");
    }

    function _getMessageHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)
        private
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                token.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                        owner,
                        spender,
                        value,
                        nonce,
                        deadline
                    )
                )
            )
        );
    }
}
