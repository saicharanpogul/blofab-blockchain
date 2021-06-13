package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"log"
	"github.com/oleiade/reflections"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// ServerConfig for external chaincode
type ServerConfig struct {
	CCID string
	Address string
}

// SmartContract provides functions for managing blood donations data.
type SmartContract struct {
	contractapi.Contract
}

// BloodSamples keeps track of total count of all blood types
type BloodSamples struct {
	TotalBloodCount int `json:"totalBloodCount"`
	APositive int `json:"aPositive"`
	ANegative int `json:"aNegative"`
	BPositive int `json:"bPositive"`
	BNegative int `json:"bNegative"`
	OPositive int `json:"oPositive"`
	ONegative int `json:"oNegative"`
	ABPositive int `json:"abPositive"`
	ABNegative int `json:"abNegative"`
}

// QueryBloodSamples is used for handling results of query
type QueryBloodSamples struct {
	BloodBankId string `json:"bloodBankId"`
	BloodSamples *BloodSamples
}

// InitiateBloodCounts is used to initiate blood samples counts of a blood bank
func (s *SmartContract) InitiateBloodCounts(ctx contractapi.TransactionContextInterface, bloodBankId string) error {
	
	bloodSamples := BloodSamples {
		TotalBloodCount: 0,
		APositive: 0,
		ANegative: 0,
		BPositive: 0,
		BNegative: 0,
		OPositive: 0,
		ONegative: 0,
		ABPositive: 0,
		ABNegative: 0,
	}

	bloodSamplesBytes, _ := json.Marshal(bloodSamples)

	return ctx.GetStub().PutState(bloodBankId, bloodSamplesBytes)
}

// GetBloodCounts is used to get blood counts of a blood bank
func (s *SmartContract) GetBloodCounts(ctx contractapi.TransactionContextInterface, bloodBankId string) (*BloodSamples, error) {
	bloodSamplesBytes, err := ctx.GetStub().GetState(bloodBankId)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from the world state, %s.", err.Error())
	}

	if bloodSamplesBytes == nil {
		return nil, fmt.Errorf("%s does not exist.", bloodBankId)
	}

	bloodSamples := new(BloodSamples)
	_ = json.Unmarshal(bloodSamplesBytes, bloodSamples)

	return bloodSamples, nil
}

// IncrementBloodCount is used to increment blood count based on provided blood type
func (s *SmartContract) IncrementBloodCount(ctx contractapi.TransactionContextInterface, bloodBankId string, bloodType string) (*BloodSamples, error) {
	bloodSamples, err := s.GetBloodCounts(ctx, bloodBankId)

	if err != nil {
		return nil, err
	}

	bloodSamples.Increment(bloodType) // increment count of specific blood type 
	bloodSamples.Increment("TotalBloodCount") // increment total blood count
	
	bloodSamplesBytes, _ := json.Marshal(bloodSamples)

	return bloodSamples, ctx.GetStub().PutState(bloodBankId, bloodSamplesBytes)
}

func (s *SmartContract) DecrementBloodCount(ctx contractapi.TransactionContextInterface, bloodBankId string, bloodType string) (*BloodSamples, error) {
	bloodSamples, err := s.GetBloodCounts(ctx, bloodBankId)

	if err != nil {
		return nil, err
	}

	bloodSamples.Decrement(bloodType) // decrement count of specific blood type 
	bloodSamples.Decrement("TotalBloodCount") // decrement total blood count
	
	bloodSamplesBytes, _ := json.Marshal(bloodSamples)

	return bloodSamples, ctx.GetStub().PutState(bloodBankId, bloodSamplesBytes)
}

// GetBloodCountHistrory is used to get complete history of blood counter
func (s *SmartContract) GetBloodCountHistrory(ctx contractapi.TransactionContextInterface, bloodBankId string) ([]BloodSamples, error) {
	historyIterator, err := ctx.GetStub().GetHistoryForKey(bloodBankId)

	if err != nil {
		return nil, fmt.Errorf("History not found for %s.", err.Error())
	}

	defer historyIterator.Close()

	var arrayOfBloodSamples []BloodSamples

	for historyIterator.HasNext() {
		var bloodSamples BloodSamples
		bloodSamplesBytes, err := historyIterator.Next()
		if err != nil {
			return nil, fmt.Errorf(err.Error())
		}
		err = json.Unmarshal(bloodSamplesBytes.Value, &bloodSamples)
		if err != nil {
			return nil, fmt.Errorf(err.Error())
		}
		arrayOfBloodSamples = append(arrayOfBloodSamples, bloodSamples)
	}

	return arrayOfBloodSamples, nil
}

// Increment is used to increment blood count
func (b *BloodSamples) Increment(field string) {
	count, _ := reflections.GetField(b, field)
	count = count.(int) + 1 // increment
	reflections.SetField(b, field, count)
}

// Decrement is used to decrement the blood count
func (b *BloodSamples) Decrement(field string) {
	count, _ := reflections.GetField(b, field)
	count = count.(int) - 1 // decrement
	reflections.SetField(b, field, count)
}

// 19:00
func loadTLSFile(filePath string) ([]byte, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	return ioutil.ReadAll(file)
}

func main() {
	CHAINCODE_TLS_KEY, err := loadTLSFile(os.Getenv("CORE_PEER_TLS_KEY_FILE"))
	if err != nil {
		fmt.Printf("Error loadTLSFile : %s", err)
	}
	CHAINCODE_TLS_CERT, err := loadTLSFile(os.Getenv("CORE_PEER_TLS_CERT_FILE"))
	if err != nil {
		fmt.Printf("Error loadTLSFile : %s", err)
	}
	CHAINCODE_CLIENT_CA_CERT, err := loadTLSFile(os.Getenv("CORE_PEER_TLS_ROOTCERT_FILE"))
	if err != nil {
		fmt.Printf("Error loadTLSFile : %s", err)
	}

	config := ServerConfig{
		CCID: os.Getenv("CHAINCODE_CCID"),
		Address: os.Getenv("CHAINCODE_ADDRESS"),
	}

	chaincode, err := contractapi.NewChaincode(&SmartContract{})

	fmt.Printf("Starting chaincode server...")

	if err != nil {
		log.Panicf("error create blofab chaincode: %s", err)
	}

	server := &shim.ChaincodeServer{
		CCID: config.CCID,
		Address: config.Address,
		CC: chaincode,
		TLSProps: shim.TLSProperties{
			Disabled:      false,
			Key:           CHAINCODE_TLS_KEY,
			Cert:          CHAINCODE_TLS_CERT,
			ClientCACerts: CHAINCODE_CLIENT_CA_CERT,
		},
	}
 
	// Start the chaincode external server
	if err = server.Start(); err != nil {
		log.Panicf("Error starting  chaincode: %s", err)
	} else {
		fmt.Printf("Chaincode Server is running on %s", config.Address)
	}
}