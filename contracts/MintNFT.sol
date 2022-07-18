// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// openzeppelin/contracts 오픈제플린 컨트렉 열거 가능한 ERC721
import "@openzeppelin/contracts/utils/Counters.sol";
// openzeppelin count 올라가는거
// library 임폴트한다.

contract MintNFT is  ERC721Enumerable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;

    // constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
    constructor() ERC721("SDD", "SDD_symbol") {}
    // symbol = 화폐의 통화기호 ethereum
    // name = 이름

    mapping(uint =>string ) public tokenURIs ;

    function tokenURI(uint _tokenId) override public view returns (string memory) {
        return  tokenURIs[_tokenId] ;
    }

    function mintNFT( string memory _tokenURI) public  returns (uint256) {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        tokenURIs[tokenId] = _tokenURI;
 
        _mint(msg.sender, tokenId);
        // msg.sender 주인의 주소
        return tokenId;
    }

    function editNFT( string memory _tokenURI) public returns (uint256) {
        
    }

    struct NftTokenData {
        uint256 nftTokenId;
        string  nftTokenURI ;
        uint price ;        
    }
    // 판매를 위한 구조체 만듬


// My NFT
    function getNftTokens(address _nftTokenOwner) view public returns (NftTokenData[] memory) {
        uint256 balanceLength = balanceOf(_nftTokenOwner);
        //balanceOf를 통해서 토큰의 갯수를 알아낸다
        //require(balanceLength != 0, "Owner did not have token.");

        NftTokenData[] memory nftTokenData = new NftTokenData[](balanceLength);

        for(uint256 i = 0; i < balanceLength; i++) {
            uint256 nftTokenId = tokenOfOwnerByIndex(_nftTokenOwner, i);
            string memory nftTokenURI = tokenURI(nftTokenId);   
            uint tokenPrice = getNftTokenPrice(nftTokenId);
            nftTokenData[i] = NftTokenData(nftTokenId , nftTokenURI, tokenPrice );
        }

        return nftTokenData;

    }

    //판매 등록
    mapping(uint256 => uint256) public nftTokenPrices;
    uint256[] public onSaleNftTokenArray;

    function setSaleNftToken(uint256 _tokenId, uint256 _price) public {
        address nftTokenOwner = ownerOf(_tokenId);

        require(nftTokenOwner == msg.sender, "Caller is not nft token owner.");
        require(_price > 0, "Price is zero or lower.");
        require(nftTokenPrices[_tokenId] == 0, "This nft token is already on sale.");
        require(isApprovedForAll(nftTokenOwner, address(this)), "nft token owner did not approve token.");

        nftTokenPrices[_tokenId] = _price;
        onSaleNftTokenArray.push(_tokenId); //판매중인 nft list

    }

    // 판매리스트
    function getSaleNftTokens() public view returns (NftTokenData[] memory ){
        uint[] memory onSaleNftToken = getSaleNftToken();
        NftTokenData[] memory onSaleNftTokens = new NftTokenData[](onSaleNftToken.length);

        for(uint i = 0; i < onSaleNftToken.length; i ++){
            uint tokenId = onSaleNftToken[i];
            uint tokenPrice = getNftTokenPrice(tokenId);
            onSaleNftTokens[i] = NftTokenData(tokenId, tokenURI(tokenId), tokenPrice) ;
        }

        return onSaleNftTokens;
    }


    function getSaleNftToken() view public returns (uint[] memory ){
        return onSaleNftTokenArray ;
    }


    function getNftTokenPrice(uint256 _tokenId) view public returns(uint256){
        return nftTokenPrices[_tokenId];
    }


    //구매함수
    function buyNftToken(uint256 _tokenId) public payable {
        uint256 price = nftTokenPrices[_tokenId];
        address nftTokenOwner = ownerOf(_tokenId);

        require(price > 0, "nft token not sale.");
        require(price  <= msg.value, "caller sent lower than price.");
        require(nftTokenOwner != msg.sender,"caller is nft token owner.");
        require(isApprovedForAll(nftTokenOwner, address(this)), "nft token owner did not approve token.");


        payable(nftTokenOwner).transfer(msg.value);

        IERC721(address(this)).safeTransferFrom(nftTokenOwner, msg.sender, _tokenId);


        //판매 리스트에서 삭제
        removeToken(_tokenId);        

    }

    function burn( uint256 _tokenId) public{
        address addr_owner = ownerOf(_tokenId);
        require( addr_owner == msg.sender, "msg.sender is not the owner of the token");
        _burn(_tokenId);
        removeToken(_tokenId);
    }



    function removeToken(uint256 _tokenId) private {
                
        nftTokenPrices[_tokenId] = 0;

        for(uint256 i = 0; i<onSaleNftTokenArray.length; i ++){
            if(nftTokenPrices[onSaleNftTokenArray[i]] ==0){
                onSaleNftTokenArray[i] = onSaleNftTokenArray[onSaleNftTokenArray.length -1] ;
                onSaleNftTokenArray.pop();
            }
        }
    } 
}
