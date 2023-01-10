// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

contract FundMe {
  // Type Declarations
  using PriceConverter for uint256;

  // State variables
  mapping(address => uint256) public s_addressToAmountFunded;
  address[] public s_funders;
  address private immutable i_owner;
  AggregatorV3Interface public s_priceFeed;

  // Events (we have none!)

  // Modifiers
  modifier onlyOwner() {
    require(msg.sender == i_owner);
    _;
  }

  // Functions Order:
  // constructor
  // receive
  // fallback
  // external
  // public
  // internal
  // private
  // view / pure

  constructor(address priceFeed) {
    s_priceFeed = AggregatorV3Interface(priceFeed);
    i_owner = msg.sender;
  }

  function fund() public payable {
    uint256 minimumUSD = 50 * 10 ** 18;
    require(
      msg.value.getConversionRate(s_priceFeed) >= minimumUSD,
      "You need to spend more ETH!"
    );
    // require(PriceConverter.getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
    s_addressToAmountFunded[msg.sender] += msg.value;
    s_funders.push(msg.sender);
  }

  function withdraw() public payable onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
    for (
      uint256 funderIndex = 0;
      funderIndex < s_funders.length;
      funderIndex++
    ) {
      address funder = s_funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address[](0);
  }

  function cheaperWithdraw() public payable onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
    address[] memory funders = s_funders;
    // mappings can't be in memory, sorry!
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address[](0);
  }

  /** @notice Gets the amount that an address has funded
   *  @param fundingAddress the address of the funder
   *  @return the amount funded
   */
  function getAddressToAmountFunded(
    address fundingAddress
  ) public view returns (uint256) {
    return s_addressToAmountFunded[fundingAddress];
  }

  function getVersion() public view returns (uint256) {
    return s_priceFeed.version();
  }

  function getFunder(uint256 index) public view returns (address) {
    return s_funders[index];
  }

  function getOwner() public view returns (address) {
    return i_owner;
  }

  function getPriceFeed() public view returns (AggregatorV3Interface) {
    return s_priceFeed;
  }
}
