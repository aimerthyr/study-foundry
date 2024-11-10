// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * 通过 forge install 安装的第三方包， 直接通过 forge remappings > remappings.txt 来生成映射
 */
contract InstallThirdParty is ERC20("ForgeInstallToken", "FIT", 18) {}

/**
 * 通过 npm install 安装的第三方包，需要手动到 remappings.txt 中添加映射（一般不常用）
 */
contract NpmThirdParty is ERC721("ForgeNpmToken", "FNT") {}
