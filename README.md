# DEGEN GAMING TOKEN USING ERC20 BY OPENZEPPLIN

This smart contract depicts the Degen Game Token.

## Description

My task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. The smart contract should have the following functionality:

* Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
* Transferring tokens: Players should be able to transfer their tokens to others.
* Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
* Checking token balance: Players should be able to check their token balance at any time.
* Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

## Getting Started


```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
```
This specifies the license type (MIT) and the Solidity compiler version (^0.8.0) to be used for the contract.

```
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```
This imports the ERC20 standard implementation from OpenZeppelin, a library for secure smart contract development.

```
contract DegenGamingToken is ERC20 {
```
This declares a new contract named DegenGamingToken that inherits from the ERC20 contract.

```
address private owner;
```
This declares a private state variable named owner of type address to store the owner's address.

```
   constructor() ERC20("Degen Gaming Token", "DGT"){
        owner = msg.sender;
        items[1]["Maths book"] = 80;
        items[2]["English book"] = 160;
        items[3]["Science book"] = 210;

        itemInfo[1] = "Maths book";
        itemInfo[2] = "English book";
        itemInfo[3] = "Science book";
    }
```
Initializes the token with the name "Degen Gaming Token" and symbol "DGT".
Sets the owner to the address that deploys the contract.
Adds three items (Iphone, Laptop, Watch) with their corresponding prices in tokens.
Stores the item names in itemInfo mapping.

```
    modifier onlyOwner{
        require(msg.sender == owner,"You are not the owner");
        _;
    }
```
This defines a modifier named onlyOwner that checks if the caller (msg.sender) is the owner. If not, it throws an error "You are not the owner". The _ placeholder represents where the modified function's code will be executed.

```
function getItems() external pure returns(string memory){
        return "1. Maths book : 80 2. English book : 160 3. Science book : 210";
    }
```
A pure function that returns a string listing the available items and their prices.

```
    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }
```
This function allows the owner to mint new tokens. It takes two parameters: to (the address to receive the tokens) and amount (the number of tokens to mint). It uses the _mint function from the ERC20 contract. The onlyOwner modifier restricts its usage to the owner only.

```
    function redeem(uint _itemNo) external {
    string memory itemName = itemInfo[_itemNo];
    uint price = items[_itemNo][itemName];
    require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem");
    _transfer(msg.sender, owner, price);
}
```
Allows users to redeem items by transferring the required amount of tokens to the owner.
Updates the claimedItems mapping to record the claimed item.

```
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
```
This function allows any user to burn (destroy) their tokens. It takes one parameter, amount (the number of tokens to burn). It uses the _burn function from the ERC20 contract.

```
    function transferToken(address _reciever , uint256 amount) external {
        require(balanceOf(msg.sender) >= amount , "You don't have enough degen tokens to transfer");
        approve(msg.sender, amount);
        transferFrom(msg.sender , _reciever , amount);
    }
```
This function allows a user to transfer tokens to another address. It takes two parameters: _reciever (the address to receive the tokens) and amount (the number of tokens to transfer). It checks if the caller has enough balance, approves the transfer, and then transfers the tokens using the transferFrom function.

```
    function getBalance() external view returns(uint256) {
        return this.balanceOf(msg.sender);
    }
}
```
This function returns the balance of the caller. It is marked as view since it does not modify the state. It calls the balanceOf function from the ERC20 contract to get the balance.

## Complete Program

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenGamingToken is ERC20 {

    mapping(uint => mapping(string => uint)) public items;
    mapping(uint => string) public itemInfo;

    mapping(address => string[]) public claimedItems;

    address private owner;
    constructor() ERC20("Degen Gaming Token", "DGT"){
        owner = msg.sender;
        items[1]["Maths book"] = 80;
        items[2]["English book"] = 160;
        items[3]["Science book"] = 210;

        itemInfo[1] = "Maths book";
        itemInfo[2] = "English book";
        itemInfo[3] = "Science book";
    }

    function getItems() external pure returns(string memory){
        return "1. Maths book : 80 2. English book : 160 3. Science book : 210";
    }

    modifier onlyOwner{
        require(msg.sender == owner,"You are not the owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }

    function redeem(uint _itemNo) external {
        string memory itemName = itemInfo[_itemNo];
        uint price = items[_itemNo][itemName];
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem");
        _transfer(msg.sender, owner, price);
       
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferToken(address _reciever , uint256 amount) external {
        require(balanceOf(msg.sender) >= amount , "You don'thave enough degen tokens to transfer");
        approve(msg.sender, amount);
        transferFrom(msg.sender , _reciever , amount);
    }
    function getBalance() external view returns(uint256) {
        return this.balanceOf(msg.sender);
    }
 }
```

## Authors

Contributor Name: Siddharth 
Contact Info: siddharthnain3@gmail.com


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
