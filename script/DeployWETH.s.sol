// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {WETH} from '../src/WETH.sol';
import {Script} from 'forge-std/Script.sol';

contract DeployWETH is Script {

    uint256 private constant DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 private deployerKey;

    function run() external returns(WETH) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_KEY;
        }

        vm.startBroadcast();
        WETH weth = new WETH();
        vm.stopBroadcast();
        return weth;
    }

}