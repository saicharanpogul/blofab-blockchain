## Init

``` peer chaincode invoke -o orderer0.blofab.example.com:7050 --ordererTLSHostnameOverride orderer0.blofab.example.com --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/blofab.example.com/orderers/orderer0.blofab.example.com/msp/tlscacerts/tlsca.blofab.example.com-cert.pem -C blood-donation-channel -n blofab-external --peerAddresses peer0.nbtc.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nbtc.example.com/peers/peer0.nbtc.example.com/tls/ca.crt --peerAddresses peer0.nbtc.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nbtc.example.com/peers/peer0.nbtc.example.com/tls/ca.crt  --isInit -c '{"Args":[]}' ```

## Invoke InitiateBloodCounts

<!-- AddCert(ctx contractapi.TransactionContextInterface, certID string, hash string, holder string, dateTime string, url string, status string) -->

``` peer chaincode invoke -o orderer0.blofab.example.com:7050 --ordererTLSHostnameOverride orderer0.blofab.example.com --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/blofab.example.com/orderers/orderer0.blofab.example.com/msp/tlscacerts/tlsca.blofab.example.com-cert.pem -C blood-donation-channel -n blofab-external --peerAddresses peer0.blofab.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/blofab.example.com/peers/peer0.blofab.example.com/tls/ca.crt --peerAddresses peer0.nbtc.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nbtc.example.com/peers/peer0.nbtc.example.com/tls/ca.crt -c '{"Args":["InitiateBloodCounts", "blofab_blood_bank"]}' ```

## Query GetCertByID

<!-- GetCertByID(ctx contractapi.TransactionContextInterface, certID string) -->

``` peer chaincode query -C blood-donation-channel -n blofab-external -c '{"Args":["GetBloodCounts", "blofab_blood_bank"]}' ```

## Invoke IncrementBloodCount 

``` peer chaincode invoke -o orderer0.blofab.example.com:7050 --ordererTLSHostnameOverride orderer0.blofab.example.com --tls $CORE_PEER_TLS_ENABLED --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/blofab.example.com/orderers/orderer0.blofab.example.com/msp/tlscacerts/tlsca.blofab.example.com-cert.pem -C blood-donation-channel -n blofab-external --peerAddresses peer0.blofab.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/blofab.example.com/peers/peer0.blofab.example.com/tls/ca.crt --peerAddresses peer0.nbtc.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nbtc.example.com/peers/peer0.nbtc.example.com/tls/ca.crt -c '{"Args":["IncrementBloodCount", "blofab_blood_bank", "BPositive"]}' ```