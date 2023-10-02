// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HogwartsCardFactory is ERC721 {
   
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public mintingFee = 0.01 ether;

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

mapping(address  => HogwartsCardInfo) private _infos;                 // issuer가 발급한 카드 정보
    mapping(uint => address) private _issuerOfToken;                  // tokenId의 issuer
    mapping(address => uint) private _amountOfTokenOwnedByIssuer;     // issuer가 현재 가지고 있는 자신의 카드 개수(발급한 양 - 남들에게 transfer한 양
                                                                      // ERC721의 _balances는 자신의 카드 개수 뿐만 아니라 자신이 받은 카드 개수까지 value값으로 가진다는 점에서 이 mapping과 차이점을 가진다 

    //Events
    event HogwartsCardMinted(
        uint indexed tokenId,
        address issuer,
        string name,       
        string age,        
        string description,
        string mbti,       
        string hobby,      
        string level,      
        string blood,      
        string dormitory
    );

    //Functions
    function mintHogwartsCard (
        string memory _name,
        string memory _age,
        string memory _description,
        string memory _mbti,
        string memory _hobby,
        string memory _level,
        string memory _blood,
        string memory _dormitory
    ) public payable isHogwartsCardInfoRegistered returns (uint256) { //호그와트 NFT 한 개 발급  
        // card 정보 세팅
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

        // 기존에 민팅한 card가 있는지 여부, 첫 1회만 무료
        if (_amountOfTokenOwnedByIssuer[msg.sender] >= 1) {
            require(msg.value == mintingFee);  // 민팅 비용 확인
        }

        uint256 newTokenId = _incrementTokenId(); 

        _mint(msg.sender, newTokenId);
        _issuerOfToken[newTokenId] = msg.sender;      
        _amountOfTokenOwnedByIssuer[msg.sender]++;

        emit HogwartsCardMinted(newTokenId, msg.sender, _name, _age, _description, _mbti, _hobby, _level, _blood, _dormitory);
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