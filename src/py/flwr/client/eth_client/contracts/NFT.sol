//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("NFTs", "NFT") {}
    mapping(uint256 => string) private _tokenURIs;


    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory tokenURI){
        tokenURI = _tokenURIs[tokenId];
        return tokenURI;
    }

//    function transferFrom (address _from, address _to, uint256 _tokenId) public payable override{
//        require(msg.value >0, "Please send some ether");
//        uint256 fee = msg.value;
//        super.transferFrom(_from,_to,_tokenId);
//        // 이더 처리 로직
//        address payable feeRecipient = _from;
//        feeRecipient.transfer(fee);
//    }
}