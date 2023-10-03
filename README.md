# Hogwarts-student-card-contract

호그와트 학생증 NFT

### 패키지 설치

```shell
npm i
```

### `.env` 파일 생성후 환경변수 입력

```shell
SEPOLIA_API_URL="Alchemy에서_발급받은_sepolia_network의_api_url"
METAMASK_PRIVATE_KEY="Metamask_private_key"
```

### 민팅

```shell
npx hardhat compile
npx hardhat run --network sepolia scripts/mint.ts
```
