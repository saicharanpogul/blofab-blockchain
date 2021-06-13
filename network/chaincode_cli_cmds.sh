#!/bin/bash
source ../terminal_control.sh

CHAINCODE_NAME=blofab-external

ORG_NAME1="blofab"
DOMAIN_NAME1="example"
ORG1_PORT="7051"

ORG_NAME2="nbtc"
DOMAIN_NAME2="example"
ORG2_PORT="7051"

checkCommitReadiness () {
  print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 $ORG_NAME =========="
  echo

  docker exec cli_${ORG_NAME2} peer lifecycle chaincode checkcommitreadiness -o localhost:7050 --channelID ${CHANNEL_NAME} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME1}.${DOMAIN_NAME}.com/orderers/orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com/msp/tlscacerts/tlsca.${ORG_NAME1}.${DOMAIN_NAME}.com-cert.pem --name ${CHAINCODE_NAME} --version 1 --sequence 1 --output json --init-required --signature-policy "AND ('${ORG_NAME1^}MSP.peer','${ORG_NAME2^}MSP.peer')"

  print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 $ORG_NAME =========="
  echo 
}

commitChaincode () {
  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} =========="
  echo

  docker exec cli_${ORG_NAME2} peer lifecycle chaincode commit \
  -o orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com:7050 \
  --ordererTLSHostnameOverride orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com \
  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME1}.${DOMAIN_NAME}.com/orderers/orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com/msp/tlscacerts/tlsca.${ORG_NAME1}.${DOMAIN_NAME}.com-cert.pem \
  --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME} \
  --peerAddresses peer0.${ORG_NAME1}.${DOMAIN_NAME}.com:7051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME1}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME1}.${DOMAIN_NAME}.com/tls/ca.crt \
  --peerAddresses peer0.${ORG_NAME2}.${DOMAIN_NAME}.com:9051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME2}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME2}.${DOMAIN_NAME}.com/tls/ca.crt \
  --version 1 --sequence 1 --init-required --signature-policy "AND ('${ORG_NAME1^}MSP.peer','${ORG_NAME2^}MSP.peer')"

  print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} Successful =========="
  echo
}

initChaincode () {
  print Green "========== Init Chaincode on Peer0 $ORG_NAME ========== "
  echo 

  docker exec cli_${ORG_NAME2} peer chaincode invoke \
  -o orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com:7050 \
  --ordererTLSHostnameOverride orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com \
  --tls true \
  --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME1}.${DOMAIN_NAME}.com/orderers/orderer0.${ORG_NAME1}.${DOMAIN_NAME}.com/msp/tlscacerts/tlsca.${ORG_NAME1}.${DOMAIN_NAME}.com-cert.pem \
  -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} \
  --peerAddresses peer0.${ORG_NAME1}.${DOMAIN_NAME}.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME1}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME1}.${DOMAIN_NAME}.com/tls/ca.crt \
  --peerAddresses peer0.${ORG_NAME2}.${DOMAIN_NAME}.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG_NAME2}.${DOMAIN_NAME}.com/peers/peer0.${ORG_NAME2}.${DOMAIN_NAME}.com/tls/ca.crt \
  --isInit -c '{"Args":[]}'

  print Green "========== Init Chaincode on Peer0 $ORG_NAME Successful ========== "
  echo
}

# checkCommitReadiness
# commitChaincode
initChaincode