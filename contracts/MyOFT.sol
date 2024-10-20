// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";

contract RoyaltyPoints is OFT {
    struct Products {
        string name;
        uint256 points;
    }

    struct UserOrder {
        uint256 amount;
        uint256 orderNounce;
    }

    mapping(uint256 => Products) public products;
    mapping(address => bool) public user;
    address public storeManager;

    constructor(
        string memory _name,
        string memory _symbol,
        address _lzEndpoint,
        address _delegate
    ) OFT(_name, _symbol, _lzEndpoint, _delegate) Ownable(_delegate) {
        _mint(msg.sender, 100 ether);
        storeManager = msg.sender;
    }

    function buy(uint256 amount) public payable {
        require(msg.value == amount, "Invalid amount");
        _burn(msg.sender, amount);
    }

    function addProduct(string memory _name, uint256 _index, uint256 _points) public onlyOwner {
        products[_index] = Products({ name: _name, points: _points });
    }

    function removeProduct(uint256 _index) public onlyOwner {
        delete products[_index];
    }

    function createAccount(address _account) public {
        require(user[msg.sender], "user already exist");
        user[_account] = true;
        _mint(_account, 100 ether);
    }

    function firstBuy(uint256 _index) public {
        require(products[_index].points > 0, "Product not found");
        require(balanceOf(msg.sender) >= products[_index].points, "Insufficient balance");
        _mint(msg.sender, 100 ether);
    }
}
