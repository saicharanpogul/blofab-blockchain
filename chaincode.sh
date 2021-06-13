#!/bin/bash
source ./terminal_control.sh


print Yellow '(1 - Start Chaincode / 2 - Stop Chaincode / 3 - Down Chaincode)'
read option


if [ $option == 1 ]
then
pushd ./chaincode/
print Green '========== Starting Chaincode Containers =========='
docker-compose up -d
print Green '========== Started Chaincode Containers =========='
popd
elif [ $option == 2 ]
then
pushd ./chaincode/
print Green '========== Stoping Chaincode Containers =========='
docker-compose stop
print Green '========== Stoped Chaincode Containers =========='
popd
elif [ $option == 3 ]
then
pushd ./chaincode/
print Green '========== Tearing Down Chaincode Containers =========='
docker-compose down -v
print Green '========== Teared Down Chaincode Containers =========='
popd
else
print Red "Invalid Input"
fi