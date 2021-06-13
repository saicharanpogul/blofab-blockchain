#!/bin/bash

ORG_PORT=`expr $PORT + 2`
CA_PORT=`expr $PORT + 4`

echo "# CHAINCODE_SERVER_ADDRESS must be set to the host and port where the peer can
# connect to the chaincode server
CHAINCODE_SERVER_ADDRESS=chaincode.${ORG_NAME}.${DOMAIN_NAME}.com:${ORG_PORT}

# CHAINCODE_ID must be set to the Package ID that is assigned to the chaincode
# on install. The `peer lifecycle chaincode queryinstalled` command can be
# used to get the ID after install if required
CHAINCODE_ID=${CHAINCODE_CCID}

# Optional parameters that will be used for TLS connection between peer node
# and the chaincode.
# TLS is disabled by default, uncomment the following line to enable TLS connection
CHAINCODE_TLS_DISABLED=false

# Following variables will be ignored if TLS is not enabled.
# They need to be in PEM format

# CORE_PEER_TLS_KEY_FILE = CHAINCODE_TLS_KEY
CORE_PEER_TLS_KEY_FILE=/tls/key.pem

# CORE_PEER_TLS_CERT_FILE = CHAINCODE_TLS_CERT
CORE_PEER_TLS_CERT_FILE=/tls/cert.pem

# The following variable will be used by the chaincode server to verify the
# connection from the peer node.
# Note that when this is set a single chaincode server cannot be shared
# across organizations unless their root CA is same.

# CORE_PEER_TLS_ROOTCERT_FILE = CHAINCODE_CLIENT_CA_CERT
CORE_PEER_TLS_ROOTCERT_FILE=/tls/root-ca.pem" > chaincode.env