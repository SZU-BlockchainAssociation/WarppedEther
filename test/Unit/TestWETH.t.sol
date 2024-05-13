//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {WETH} from '../../src/WETH.sol';
import {Test,console} from 'forge-std/Test.sol';
import {DeployWETH} from '../../script/DeployWETH.s.sol';

contract TestWETH is Test {
    WETH public weth;
    DeployWETH public deployer;
    address public bob;

    function setUp() public {
        deployer = new DeployWETH();
        weth = deployer.run();

        bob = makeAddr("bob");
        payable(bob).transfer(1 ether);
    }

    function testCanMintWeth() public {
        uint256 depositedEth = 1 ether;

        vm.prank(bob);
        weth.deposit{value: depositedEth}();
        assertEq(weth.balanceOf(bob), depositedEth);
    }

    function testCanWithdraWeth() public {
        uint256 depositedEth = 1 ether;
        uint256 withdrawEth = 0.3 ether;

        vm.startPrank(bob);
        weth.deposit{value: depositedEth}();
        weth.withdraw(withdrawEth);
        vm.stopPrank();
        assertEq(weth.balanceOf(bob), depositedEth - withdrawEth);
        assertEq(address(bob).balance, withdrawEth);
    }

    function testRevertIfWithdrawTooMuch() public {
        uint256 depositedEth = 1 ether;
        uint256 withdrawEth = 1.1 ether;

        vm.startPrank(bob);
        weth.deposit{value: depositedEth}();
        vm.expectRevert(abi.encodeWithSelector(WETH.WETH__InsufficientBalance.selector, weth.balanceOf(bob), withdrawEth));
        weth.withdraw(withdrawEth);
        vm.stopPrank();
    }

    function testFallback() public {
        uint256 depositedEth = 1 ether;
        bytes memory data = "some data";

        vm.prank(bob);
        (bool success,) = payable(address(weth)).call{value: depositedEth}(data);
        assert(success);
        assertEq(weth.balanceOf(bob), depositedEth);
    }

}