#!/bin/bash

ORG_PORT=`expr $PORT + 2`

echo "{
    \"address\": \"chaincode.${ORG_NAME}.${DOMAIN_NAME}.com:${ORG_PORT}\",
    \"dial_timeout\": \"10s\",
    \"tls_required\": true,
    \"client_auth_required\": true,
    \"client_key\": \"CORE_PEER_TLS_KEY_FILE\",
    \"client_cert\": \"CORE_PEER_TLS_CERT_FILE\",
    \"root_cert\": \"CORE_PEER_TLS_ROOTCERT_FILE\"
}" > connection.json
