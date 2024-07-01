// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _transferOwnership(_msgSender());
    }

    struct RedeemedItem {
        uint256 amount;          
        uint256 tokensRedeemed;  
    }

    event TokensRedeemed(address indexed redeemer, uint256 amount, uint256 tokensRedeemed);

    uint256 public tokenCost = 1; // Default cost of tokens for redemption

    mapping(address => RedeemedItem[]) private redeemedItems;
    mapping(address => uint256) private totalTokensRedeemed; // Track total tokens redeemed by user

    // Mint function - restricted to owner
    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Mint amount must be greater than zero");
        _mint(to, amount);
    }

    // Burn function - available to any user
    function burn(uint256 amount) public {
        require(amount > 0, "Burn amount must be greater than zero");
        _burn(_msgSender(), amount);
    }

    // Redeem function with dynamic game item costs
    function redeem(uint256 amount, uint256 RedeemItem) public returns (uint256) {
        require(amount > 0, "Redeem amount must be greater than zero");

        uint256 requiredTokens;
        if (RedeemItem == 1) {
            requiredTokens = 50;
        } else if (RedeemItem == 2) {
            requiredTokens = 100;
        } else if (RedeemItem == 3) {
            requiredTokens = 200;
        } else {
            revert("Invalid game item");
        }

        require(balanceOf(_msgSender()) >= requiredTokens, "Insufficient token balance");
        _burn(_msgSender(), requiredTokens);

        redeemedItems[_msgSender()].push(RedeemedItem({
            amount: amount,
            tokensRedeemed: requiredTokens
        }));

        totalTokensRedeemed[_msgSender()] += requiredTokens; // Update total tokens redeemed

        emit TokensRedeemed(_msgSender(), amount, requiredTokens);

        return totalTokensRedeemed[_msgSender()]; // Return total tokens redeemed by the user
    }

    // Retrieve redeemed items for an account
    function getRedeemedItems(address account) public view returns (RedeemedItem[] memory) {
        require(account != address(0), "Query for zero address");
        return redeemedItems[account];
    }

    // Print redeemed tokens for an account
    function printRedeemedTokens(address account) public view returns (string memory) {
        require(account != address(0), "Query for zero address");
        RedeemedItem[] memory items = redeemedItems[account];
        require(items.length > 0, "No redeemed tokens found");

        string memory result;
        for (uint i = 0; i < items.length; i++) {
            result = string(abi.encodePacked(
                result,
                "Redemption ", uintToString(i + 1), ": ", 
                "Amount: ", uintToString(items[i].amount), 
                " Tokens Redeemed: ", uintToString(items[i].tokensRedeemed), 
                "\n"
            ));
        }
        return result;
    }

    // Get total tokens redeemed by a user
    function getTotalTokensRedeemed(address account) public view returns (uint256) {
        require(account != address(0), "Query for zero address");
        return totalTokensRedeemed[account];
    }

    // Utility function to convert uint to string
    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        uint256 digits;
        uint256 temp = v;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (v != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(v % 10)));
            v /= 10;
        }
        return string(buffer);
    }

    // Check balance of an account
    function checkBalance(address account) public view returns (uint256) {
        require(account != address(0), "Query for zero address");
        return balanceOf(account);
    }

    // Transfer tokens with allowance handling
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
