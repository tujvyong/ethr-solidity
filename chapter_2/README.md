## Chapter-2
Deploy to test network<br>

### Local Development
- Ganache
ローカル環境での開発をしたい場合に使える。
    1. Ganacheを起動
    2. `truffle migrate --network development` でデプロイ
<br>
- Goerli
テストネットワークの１つ<br>
イーサリアムクライアントを使ったデプロイ方法<br>
    1. `openethereum --chain=goerli` でテストネットワークに接続
    2. `truffle migrate --network goerli` でデプロイ
<br>
- Rinkeby
テストネットワークの1つ<br>
マネージドイーサリアムノードのサービスプロバイダである Infura を使用<br>
    1. `export INFURA_PROJECT_ID=<PROJECT_ID>`
    2. `truffle migrate --network rinkeby`

