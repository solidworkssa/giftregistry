// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GiftRegistry Contract
/// @notice On-chain gift registry and contribution tracking.
contract GiftRegistry {

    struct Item {
        string name;
        uint256 cost;
        uint256 funded;
    }
    
    Item[] public items;
    
    function addItem(string memory _name, uint256 _cost) external {
        items.push(Item({
            name: _name,
            cost: _cost,
            funded: 0
        }));
    }
    
    function contribute(uint256 _id) external payable {
        Item storage item = items[_id];
        require(item.funded + msg.value <= item.cost, "Over funded");
        item.funded += msg.value;
    }

}
