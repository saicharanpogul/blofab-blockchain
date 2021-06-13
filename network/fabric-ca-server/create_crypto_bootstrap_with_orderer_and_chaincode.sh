#!/bin/bash
source ../../terminal_control.sh

generateCrypto() {

  CA_PORT=`expr $PORT + 4`
  echo
  echo "Enroll CA Admin for $ORG_NAME"
  echo

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/

  fabric-ca-client enroll -u https://${ORG_NAME}:adminpw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-$CA_PORT-ca-$ORG_NAME-$DOMAIN_NAME-com.pem
    OrganizationalUnitIdentifier: orderer" >${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Register peer0.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register peer1.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register orderer$ORDERER_NUMBER.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name orderer$ORDERER_NUMBER --id.secret orderer${ORDERER_NUMBER}pw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  # ORDERER1

  echo
  echo "Register orderer$ORDERER_NUMBER_1.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name orderer$ORDERER_NUMBER_1 --id.secret orderer${ORDERER_NUMBER_1}pw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register user1.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register admin.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name admin1 --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  echo
  echo "Register chaincode.$ORG_NAME"
  echo

  fabric-ca-client register --caname ca.$ORG_NAME.$DOMAIN_NAME.com --id.name chaincode_$ORG_NAME --id.secret chaincode_${ORG_NAME}_pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers

  # Peer0

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate Peer0 MSP"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts peer0.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate Peer0 TLS-Certs"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts peer0.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  # Just for anchor Peer0?

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/tlsca

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/tlsca/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/ca

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer0.$ORG_NAME.$DOMAIN_NAME.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/ca/ca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  # Peer1

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate Peer1 MSP"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts peer1.$ORG_NAME.$DOMAIN_NAME.com --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate Peer1 TLS-Certs"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts peer1.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/peers/peer1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  # User1

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users
  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/User1@$ORG_NAME.$DOMAIN_NAME.com

  echo 
  echo "Generate User1 MSP"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/User1@$ORG_NAME.$DOMAIN_NAME.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  # Admin User

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com 

  echo
  echo "Generate Admin User MSP"
  echo

  fabric-ca-client enroll -u https://admin1:adminpw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/users/Admin@$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  # Chaincode

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode
  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate Chaincode MSP"
  echo

  fabric-ca-client enroll -u https://chaincode_$ORG_NAME:chaincode_${ORG_NAME}_pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate Chaincode TLS-Certs"
  echo

  fabric-ca-client enroll -u https://chaincode_$ORG_NAME:chaincode_${ORG_NAME}_pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts chaincode.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/root-ca.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/chaincode/chaincode.$ORG_NAME.$DOMAIN_NAME.com/tls/key.pem

  #  Orderer0

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate the Orderer MSP"
  echo

  fabric-ca-client enroll -u https://orderer$ORDERER_NUMBER:orderer${ORDERER_NUMBER}pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate the orderer TLS-Certs"
  echo

  fabric-ca-client enroll -u https://orderer$ORDERER_NUMBER:orderer${ORDERER_NUMBER}pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  #mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  #  Orderer1

  mkdir -p ../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com

  echo
  echo "Generate the ${ORDERER_NUMBER_1} MSP"
  echo

  fabric-ca-client enroll -u https://orderer$ORDERER_NUMBER_1:orderer${ORDERER_NUMBER_1}pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/msp --csr.hosts orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/msp/config.yaml

  echo
  echo "Generate the ${ORDERER_NUMBER_1} TLS-Certs"
  echo

  fabric-ca-client enroll -u https://orderer$ORDERER_NUMBER_1:orderer${ORDERER_NUMBER_1}pw@localhost:$CA_PORT --caname ca.$ORG_NAME.$DOMAIN_NAME.com -M ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls --enrollment.profile tls --csr.hosts orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/$ORG_NAME/tls-cert.pem

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/ca.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.crt

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  #mkdir ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts

  cp ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/orderers/orderer$ORDERER_NUMBER_1.$ORG_NAME.$DOMAIN_NAME.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$ORG_NAME.$DOMAIN_NAME.com/msp/tlscacerts/tlsca.$ORG_NAME.$DOMAIN_NAME.com-cert.pem

  echo
  print Green "Certificates are generated!"
  echo
}

generateCrypto