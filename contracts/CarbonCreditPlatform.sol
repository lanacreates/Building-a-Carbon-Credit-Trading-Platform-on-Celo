import "@toucanprotocol/contracts/TCO2.sol";

contract CarbonCreditPlatform is TCO2 {
    function buyCarbonCredits(address buyer, uint256 amount) public payable {
        _transfer(buyer, amount);
    }
    
    function sellCarbonCredits(address seller, uint256 amount) public {
        _transferFrom(seller, address(this), amount);
    }
}
