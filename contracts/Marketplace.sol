// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./CarbonCredit.sol";

contract Marketplace {
    CarbonCredit public token;
    address public admin;
    uint256 public percentFee;

    struct Sale {
        address seller;
        uint256 amount;
        uint256 pricePerToken;
        bool isCompleted;
    }

    Sale[] public sales;

    constructor(address tokenAddress, uint256 fee) {
        require(fee <= 100, "fee too high");
        token = CarbonCredit(tokenAddress);
        admin = msg.sender;
        percentFee = fee;
    }

    function listTokens(uint256 amount, uint256 pricePerToken) external {
        require(token.balanceOf(msg.sender) >= amount, "not enough tokens");
        token.transferFrom(msg.sender, address(this), amount);
        sales.push(Sale({
            seller: msg.sender,
            amount: amount,
            pricePerToken: pricePerToken,
            isCompleted: false
        }));
    }

    function buyTokens(uint256 saleId) external payable {
        Sale storage sale = sales[saleId];
        require(!sale.isCompleted, "sale already completed");
        require(msg.value == sale.pricePerToken * sale.amount, "wrong value sent");

        sale.isCompleted = true;
        uint256 fee = (msg.value * percentFee) / 100;
        payable(admin).transfer(fee);
        payable(sale.seller).transfer(msg.value - fee);
        token.transfer(msg.sender, sale.amount);
    }
}
