// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HogwartsCardFactory is ERC721Enumerable, Ownable {
   
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("HogwartsCardNFT", "HogwartsCard") {}

    struct HogwartsCardInfo {
        address issuer;      // 발급한 사람
        string name;         // 캐릭터 이름
        string age;          // 나이
        string description;  // 자기소개, 캐릭터 설명
        string mbti;         // 엠비티아이
        string hobby;        // 취미
        string level;        // 레벨
        string blood;        // 혈통 여부(순수, 머글, 혼혈)
        string dormitory;    // 소속 기숙사
    }

    modifier isHogwartsCardInfoRegistered(){
        HogwartsCardInfo memory hogwartsCardInfo = _infos[msg.sender];
        require(
            keccak256(abi.encodePacked(hogwartsCardInfo.name)) != keccak256(abi.encodePacked("")),
            "Register your Hogwarts Card info First"
        );
        _;
    }

    mapping(address  => HogwartsCardInfo ) private _infos; //issuer가 발급한 명함 정보
    mapping(address => uint[]) private _tokenIdsMadeByIssuer;  //issuer가 발급한 명함의 tokenId들
    mapping(address => mapping(uint=> bool)) private _isTokenStillOwnedByIssuer; //issuer가 발급한 tokenId들이 현재 issuer에게 있는지. 있으면 true, 없으면 false
    mapping(uint => address) private _issuerOfToken; //tokenId의 issuer
    mapping(address => uint) private _amountOfTokenOwnedByIssuer; //issuer가 현재 가지고 있는 자신의 명함 개수(발급한 양 - 남들에게 transfer한 양) //ERC721의 _balances는 자신의 명함 개수 뿐만 아니라 자신이 받은 명함 개수까지 value값으로 가진다는 점에서 이 mapping과 차이점을 가짐. 

     //Events
    event HogwartsCardInfoRegistered(
        address indexed issuer,
        string name,       
        string age,        
        string description,
        string mbti,       
        string hobby,      
        string level,      
        string blood,      
        string dormitory
    );
    event HogwartsCardMinted(
        uint indexed tokenId,
        address issuer,
        uint amountOfTokenOwnedByIssuer
    );

    //Functions
    function registerHogwartsCardInfo (
        string memory _name,
        string memory _age,
        string memory _description,
        string memory _mbti,
        string memory _hobby,
        string memory _level,
        string memory _blood,
        string memory _dormitory
    ) public {
        HogwartsCardInfo memory hogwartsCardInfo = HogwartsCardInfo({
            issuer: msg.sender,
            name: _name,
            age: _age,
            description: _description,
            mbti: _mbti,
            hobby: _hobby,
            level: _level,
            blood: _blood,
            dormitory: _dormitory
        });
               
        _infos[msg.sender] = hogwartsCardInfo;

        emit HogwartsCardInfoRegistered(msg.sender, _name, _age, _description, _mbti, _hobby, _level, _blood, _dormitory);
    } 

    function mintHogwartsCard () public payable isHogwartsCardInfoRegistered returns (uint256) { //호그와트 NFT 한 개 발급      
        uint256 newTokenId = _incrementTokenId();
        
        _mint(msg.sender, newTokenId);
 
        //tokenIds 관련 매핑 업데이트
        uint[] storage tokenIdsMadeByIssuer = _tokenIdsMadeByIssuer[msg.sender];
        tokenIdsMadeByIssuer.push(newTokenId);
        
        _isTokenStillOwnedByIssuer[msg.sender][newTokenId] = true;
        _issuerOfToken[newTokenId] = msg.sender;      
        _amountOfTokenOwnedByIssuer[msg.sender]++;

        emit HogwartsCardMinted(newTokenId,msg.sender, _amountOfTokenOwnedByIssuer[msg.sender]);
        return newTokenId;
    }

    function _incrementTokenId() internal returns (uint256) {
        _tokenIdCounter.increment();
        return _tokenIdCounter.current();
    }

    //getter Funtions
    function getUnemployedCardInfo(address issuer) external view returns (HogwartsCardInfo memory){
        return _infos[issuer];
    }
    function getAmountOfTokenOwnedByIssuer(address issuer) external view returns (uint){
        return _amountOfTokenOwnedByIssuer[issuer];
    }
}