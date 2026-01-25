// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GiftRegistry {
    struct Gift {
        address wisher;
        string itemName;
        uint256 estimatedCost;
        bool claimed;
        address claimer;
    }

    mapping(uint256 => Gift) public gifts;
    uint256 public giftCounter;

    event GiftAdded(uint256 indexed giftId, address indexed wisher, string itemName);
    event GiftClaimed(uint256 indexed giftId, address indexed claimer);

    function addGift(string memory itemName, uint256 estimatedCost) external returns (uint256) {
        uint256 giftId = giftCounter++;
        gifts[giftId] = Gift(msg.sender, itemName, estimatedCost, false, address(0));
        emit GiftAdded(giftId, msg.sender, itemName);
        return giftId;
    }

    function claimGift(uint256 giftId) external {
        Gift storage gift = gifts[giftId];
        gift.claimed = true;
        gift.claimer = msg.sender;
        emit GiftClaimed(giftId, msg.sender);
    }

    function getGift(uint256 giftId) external view returns (Gift memory) {
        return gifts[giftId];
    }
}
