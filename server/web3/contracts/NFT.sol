//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("NFTs", "NFT") {
    }

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => uint256) public _tokenPrice;
    mapping(uint256 => uint256) private _balance;
    mapping(uint256 => address) private _buyer;



    function mintNFT(address recipient, string memory tokenURI, uint256 tokenPrice)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenPrice[newItemId] = tokenPrice;
        return newItemId;
    }

    function updateTokenPrice(uint256 tokenId, uint256 _price) external {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "Not the token owner");

        _tokenPrice[tokenId] = _price;
    }

    function buyToken(uint256 _tokenId) external payable{
        require(_exists(_tokenId),"Token does not exist");
        require(msg.value == _tokenPrice[_tokenId], "Inaccurate funds");
        require(msg.sender != ownerOf(_tokenId),"Cannot buy your own token");
        // address seller = ownerOf(_tokenId);
        // address payable sellerPayable = payable(seller);
        // sellerPayable.transfer(msg.value);
        _balance[_tokenId] = msg.value;
        _buyer[_tokenId] = msg.sender;
    }

    function transferNFT(uint256 _tokenId, address buyer) external payable onlyOwner(){
        require(_exists(_tokenId),"Token does not exist");
        require(_buyer[_tokenId] == buyer,"Not correct buyer address.");
        address seller = ownerOf(_tokenId);
        address payable sellerPayable = payable(seller);
        sellerPayable.transfer(address(this).balance);
        transferFrom(seller,buyer,_tokenId);
        _balance[_tokenId] = 0;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory tokenURI){
        tokenURI = _tokenURIs[tokenId];
        return tokenURI;
    }

}