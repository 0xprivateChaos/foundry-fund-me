//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    
    function testMinimumDollarIsFive() public view { 
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsDeployer() public view {
        // assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next call will be by USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    modifier funded() {
        vm.prank(USER); 
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testFundingUpdatesAddressToAmountFunded() public {
        vm.startPrank(USER);
        uint256 expectedAmount = fundMe.getAddressToAmountFunded(USER) + SEND_VALUE;
        fundMe.fund{value: SEND_VALUE}();
        assertEq(fundMe.getAddressToAmountFunded(USER), expectedAmount);
        vm.stopPrank();
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); // should have spent gas

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startFunderIndex = 1;
        for(uint160 i = startFunderIndex; i < numberOfFunders; i++){
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        assert(address(fundMe).balance == 0);
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);
    }

    function testCheaperWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startFunderIndex = 1;
        for(uint160 i = startFunderIndex; i < numberOfFunders; i++){
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        assert(address(fundMe).balance == 0);
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);
    }
}