// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DengenToken is ERC20, Ownable {
   
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    
    event TokensRedeemed(address indexed redeemer, uint256 amount, string item);

   
    mapping(string => uint256) private itemCosts;

    
    function setItemCost(string memory item, uint256 cost) public onlyOwner {
        require(bytes(item).length > 0, "Item name cannot be empty");
        require(cost > 0, "Item cost must be greater than zero");
        itemCosts[item] = cost;
    }
    
     function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Mint amount must be greater than zero");
        _mint(to, amount);
    }

       function burn(uint256 amount) public {
        require(amount > 0, "Burn amount must be greater than zero");
        _burn(_msgSender(), amount);
    }


        function redeem(string memory item) public {
        uint256 cost = itemCosts[item];
        require(cost > 0, "Item does not exist or cost not set");
        require(balanceOf(_msgSender()) >= cost, "Insufficient token balance");


        _burn(_msgSender(), cost);

  
        emit TokensRedeemed(_msgSender(), cost, item);
    }


    function checkBalance(address account) public view returns (uint256) {
        require(account != address(0), "Query for zero address");
        return balanceOf(account);
    }


    function transferTokens(address from, address to, uint256 amount) public {
        require(amount > 0, "Transfer amount must be greater than zero");
        require(from != address(0), "Cannot transfer from zero address");
        require(to != address(0), "Cannot transfer to zero address");

        if (from == _msgSender()) {
            _transfer(from, to, amount);
        } else {
            uint256 currentAllowance = allowance(from, _msgSender());
            require(currentAllowance >= amount, "Transfer amount exceeds allowance");
            _approve(from, _msgSender(), currentAllowance - amount);
            _transfer(from, to, amount);
        }
    }
}
