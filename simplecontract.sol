pragma solidity ^0.6.0;

contract Demo {
    string public name;
    
    constructor() public {
        name = "Patrick";
  }
  
  function updateName(string memory updated_name) public{
        name = updated_name;
    }
}

