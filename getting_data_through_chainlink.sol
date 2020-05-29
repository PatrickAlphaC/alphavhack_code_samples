pragma solidity ^0.6.0;

import "github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";

// MyContract inherits the ChainlinkClient contract to gain the
// functionality of creating Chainlink requests
contract ChainlinkExample is ChainlinkClient {
  // Stores the answer from the Chainlink oracle
  uint256 public currentPrice;
  address public owner;
  
  // Alpha Vantage Ropsten Oracle and JObID
  address ORACLE = 0xB36d3709e22F7c708348E225b20b13eA546E6D9c;
  bytes32 JOBID = stringToBytes32("b1440eefbbff416c8b99062a128ca075");
  
  uint256 constant private ORACLE_PAYMENT = 1 * LINK;

  constructor() public {
    // Set the address for the LINK token for the network
    setPublicChainlinkToken();
    owner = msg.sender;
  }

  // Creates a Chainlink request with the uint256 multiplier job
  function requestEthereumPrice() 
    public
    onlyOwner
  {
    // newRequest takes a JobID, a callback address, and callback function as input
    Chainlink.Request memory req = buildChainlinkRequest(JOBID, address(this), this.fulfill.selector);
    // Adds a URL with the key "get" to the request parameters
    req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD");
    // Uses input param (dot-delimited string) as the "path" in the request parameters
    req.add("path", "USD");
    // Adds an integer with the key "times" to the request parameters
    req.addInt("times", 100);
    // Sends the request with the amount of payment specified to the oracle
    sendChainlinkRequestTo(ORACLE, req, ORACLE_PAYMENT);
  }
 
  // fulfill receives a uint256 data type
  function fulfill(bytes32 _requestId, uint256 _price)
    public
    // Use recordChainlinkFulfillment to ensure only the requesting oracle can fulfill
    recordChainlinkFulfillment(_requestId)
  {
    // This fulfills the currentprice
    currentPrice = _price; 
  }
 
  
  // cancelRequest allows the owner to cancel an unfulfilled request
  function cancelRequest(
    bytes32 _requestId,
    uint256 _payment,
    bytes4 _callbackFunctionId,
    uint256 _expiration
  )
    public
    onlyOwner
  {
    cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
  }
  
  // withdrawLink allows the owner to withdraw any extra LINK on the contract
  function withdrawLink()
    public
    onlyOwner
  {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  // helper function
  function stringToBytes32(string memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }
    assembly { // solhint-disable-line no-inline-assembly
      result := mload(add(source, 32))
    }
  }
}
