// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CircularMarketplace {
    struct Item {
        uint256 id;
        string name;
        string description;
        string[] images;
        string billUrl;
        uint256 price;
        address currentOwner;
        bool isListed;
    }

    struct Transaction {
        uint256 itemId;
        address seller;
        address buyer;
        uint256 price;
        uint256 timestamp;
    }

    mapping(uint256 => Item) public items;
    mapping(uint256 => Transaction[]) public itemTransactions;
    uint256 public itemCount;

    event ItemCreated(uint256 id, string name, uint256 price, address owner);
    event ItemTransferred(uint256 id, address from, address to, uint256 price);
    event ItemUpdated(uint256 id, string description, uint256 price);

    modifier onlyOwner(uint256 itemId) {
        require(items[itemId].currentOwner == msg.sender, "Not the owner");
        _;
    }

    function createItem(
        string memory name, 
        string memory description, 
        string[] memory imageUrls, 
        string memory billUrl, 
        uint256 price
    ) public {
        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            name: name,
            description: description,
            images: imageUrls,
            billUrl: billUrl,
            price: price,
            currentOwner: msg.sender,
            isListed: false
        });

        emit ItemCreated(itemCount, name, price, msg.sender);
    }

    function transferItem(uint256 itemId, address to) public payable onlyOwner(itemId) {
        require(to != address(0), "Invalid address");
        require(msg.value >= items[itemId].price, "Insufficient payment");

        address seller = items[itemId].currentOwner;
        items[itemId].currentOwner = to;

        itemTransactions[itemId].push(Transaction({
            itemId: itemId,
            seller: seller,
            buyer: to,
            price: items[itemId].price,
            timestamp: block.timestamp
        }));

        payable(seller).transfer(msg.value);
        emit ItemTransferred(itemId, seller, to, items[itemId].price);
    }

    function updateItem(
        uint256 itemId,
        string memory newDescription,
        uint256 newPrice,
        string[] memory newImages
    ) public onlyOwner(itemId) {
        items[itemId].description = newDescription;
        items[itemId].price = newPrice;
        items[itemId].images = newImages;

        emit ItemUpdated(itemId, newDescription, newPrice);
    }

    function listItem(uint256 itemId) public onlyOwner(itemId) {
        items[itemId].isListed = true;
    }

    function delistItem(uint256 itemId) public onlyOwner(itemId) {
        items[itemId].isListed = false;
    }

    function getItemHistory(uint256 itemId) public view returns (Transaction[] memory) {
        return itemTransactions[itemId];
    }
}
