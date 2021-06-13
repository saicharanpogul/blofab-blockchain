CHAINCODE_PORT=`expr $PORT + 2`

echo "version: '2'

networks: 
  blood-donation:
      external: 
        name: blood-donation

services: 
  
  chaincode-${ORG_NAME}.${DOMAIN_NAME}.com:
    hostname: chaincode.${ORG_NAME}.${DOMAIN_NAME}.com
    image: hyperledger/fabric-chaincode:\$IMAGE_TAG
    env_file:
      - chaincode.env
    environment:
      - CHAINCODE_CCID=${CHAINCODE_CCID}
      - CHAINCODE_ADDRESS=0.0.0.0:${CHAINCODE_PORT}
    ports: 
      - '${CHAINCODE_PORT}:${CHAINCODE_PORT}'
    volumes:
      - ../network/organizations/peerOrganizations/${ORG_NAME}.${DOMAIN_NAME}.com/chaincode/chaincode.${ORG_NAME}.${DOMAIN_NAME}.com/tls/:/tls
    container_name: chaincode-${ORG_NAME}.${DOMAIN_NAME}.com
    networks: 
      - blood-donation" > docker-compose.yaml