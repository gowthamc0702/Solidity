// Objectives:
// 1.Get funds
// 2.Withdraw funds
// 3.Set a minimum funding value in USD

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./PriceConverter.sol";

error NotOwner();

contract FundMe
{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 1 * 1e18;
    //8,66,743 gas - non-constant
    //8,46,623 gas - constant

    mapping(address => uint256) public addressToAmountFunded;

    address[] public funders;
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
       // msg.value.getConvertionRate();
        require (msg.value.getConversionRate() >=MINIMUM_USD , "Didnt send enough!"); //1e18 == 1 * 10 * 18 == 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=msg.value;        
    }
    
    function withdraw() public onlyOwner{
      //  require(msg.sender == owner , "Sender is not owner!");

        for (uint256 FunderIndex=0; FunderIndex<funders.length ; FunderIndex++)
        {
            address funder = funders[FunderIndex];
            addressToAmountFunded[funder]=0;
        }
        //reset the array 
        funders = new address[](0);

        /*
        to actually withdraw the funds -we use 3 methods 
        1. transfer     2.send      3.call
        */
        // //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool sendSucsess = payable(msg.sender).send(address(this).balance);
        // require(sendSucsess,"Send failed");
        // //call
        (bool callSucsess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucsess,"Call Failed");


    }

    modifier onlyOwner{
        //        require(msg.sender == i_owner , "Sender is not owner!");
                if(i_owner != msg.sender){ revert NotOwner();}
                _;
    }

      receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

  
}
