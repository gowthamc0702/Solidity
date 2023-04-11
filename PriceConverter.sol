//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter{
    
    function getPrice() internal view returns(uint256){
        //ABI
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       
        //(uint80 roundId, int price , uint startedAt ,uint timeStamp,uint80 answeredInRound) = pricefeed.latestRoundData();
        //pricefeed.latestRoundData() returns these 5 values, we only need int price (so emit the rest)
        (, int256 price , , , ) = pricefeed.latestRoundData();
        //ETH in terms of USD ~= 3000.00000000 (but msg.value in fund() has 18 decimalplaces ,to convert the price from 8 decimal to 18 we do price*e10;
        return uint256(price * 1e10);
   
    }

    // function getVersion() internal view returns(uint256) {
    //     AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //     return pricefeed.version();
    // }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethprice = getPrice();
        return ((ethAmount*ethprice) / 1e18); //without /1e18 we'll have 36 zeros
    }
}
