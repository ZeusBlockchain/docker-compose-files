/*
Copyright IBM Corp. 2016 All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

//WARNING - this chaincode's ID is hard-coded in chaincode_example04 to illustrate one way of
//calling chaincode from a chaincode. If this example is modified, chaincode_example04.go has
//to be modified as well with the new ID of chaincode_example02.
//chaincode_example05 show's how chaincode ID can be passed in as a parameter instead of
//hard-coding.

import (
	"fmt"
	"strconv"
	"strings"
	"encoding/gob"
	"bytes"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// SimpleChaincode example simple Chaincode implementation
type SimpleChaincode struct {
}

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex02 Init")
	_, args := stub.GetFunctionAndParameters()
	var A, B string    // Entities
	var Aval, Bval int // Asset holdings
	var err error

	if len(args) != 4 {
		return shim.Error("Incorrect number of arguments. Expecting 4")
	}

	// Initialize the chaincode
	A = args[0]
	Aval, err = strconv.Atoi(args[1])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	B = args[2]
	Bval, err = strconv.Atoi(args[3])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	fmt.Printf("Aval = %d, Bval = %d\n", Aval, Bval)

	// Write the state to the ledger
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(B, []byte(strconv.Itoa(Bval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex02 Invoke")
	function, args := stub.GetFunctionAndParameters()
	if function == "invoke" {
		// Make payment of X units from A to B
		return t.invoke(stub, args)
	} else if function == "delete" {
		// Deletes an entity from its state
		return t.delete(stub, args)
	} else if function == "query" {
		// the old "Query" is now implemented in invoke
		return t.query(stub, args)
	} else if function == "set" {
		// set a variable with a specified value
		return t.set(stub, args)
	} else if function == "set_list" {
		// set a list variable with a specified value
		return t.set_list(stub, args)
	}else if function == "query_map_keys" {
		// query a variable and get a string which consists of all the list elements
		return t.query_map_keys(stub, args)
	} else if function == "query_map_field" {
		// query a variable and get a string which consists of all the list elements
		return t.query_map_field(stub, args)
	} else if function == "query_list" {
		// query a variable and get a string which consists of all the list elements
		return t.query_list(stub, args)
	} else if function == "insert_map" {
		// query a variable and get a string which consists of all the list elements
		return t.insert_map(stub, args)
	} else if function == "insert_list" {
		// query a variable and get a string which consists of all the list elements
		return t.insert_list(stub, args)
	} else if function == "map_remove" {
		// query a variable and get a string which consists of all the list elements
		return t.map_remove(stub, args)
	}

	return shim.Error("Invalid invoke function name. Expecting \"invoke\" \"delete\" \"query\" \"set\" \"set_list\" \"query_map_keys\"  \"query_list\" \"query_map_field\" \"insert_map\"  \"insert_list\" \"map_remove\"")
}

func (t *SimpleChaincode) map_remove(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entity
	var Key string // Asset
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	A = args[0]
	Key = args[1]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}
	b1 := bytes.NewBuffer(Avalbytes)
	var decodedMap map[string]string
	d := gob.NewDecoder(b1)

	// Decoding the serialized data
	err = d.Decode(&decodedMap)
	if err != nil {
		shim.Error(err.Error())
	}
	fmt.Printf("%#v\n", decodedMap)
	// Remove the Key
	delete(decodedMap, Key)

	b2 := new(bytes.Buffer)
	e := gob.NewEncoder(b2)
	// Encoding the map
	err = e.Encode(decodedMap)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Write the state back to the ledger
	err = stub.PutState(A, b2.Bytes())
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChaincode) insert_map(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var Map string    // Map
	var Key string // Key
	var Value string // Value
	var err error

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	Map = args[0]
	Key = args[1]
	Value = args[2]

	// Get the state from the ledger
	Mapbytes, err := stub.GetState(Map)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + Map + "\"}"
		return shim.Error(jsonResp)
	}

	if Mapbytes == nil {
		fmt.Printf("NIL\n")
		// jsonResp := "{\"Error\":\"Nil amount for " + Map + "\"}"
		// return shim.Error(jsonResp)
		NewMap := make(map[string]string)

		// Add to map
		NewMap[Key] = Value
		fmt.Printf("%#v\n", NewMap)

		b := new(bytes.Buffer)
		e := gob.NewEncoder(b)
		// Encoding the map
		err = e.Encode(NewMap)
		if err != nil {
			return shim.Error(err.Error())
		}

		// Write the state back to the ledger
		err = stub.PutState(Map, b.Bytes())
		if err != nil {
			return shim.Error(err.Error())
		}
	} else {
		b := bytes.NewBuffer(Mapbytes)
		var decodedMap map[string]string
		d := gob.NewDecoder(b)

		// Decoding the serialized data
		err = d.Decode(&decodedMap)
		if err != nil {
			shim.Error(err.Error())
		}
		// fmt.Printf("%#v\n", decodedMap)
		// Add to map
		decodedMap[Key] = Value

		b2 := new(bytes.Buffer)
		e := gob.NewEncoder(b2)
		// Encoding the map
		err = e.Encode(decodedMap)
		if err != nil {
			return shim.Error(err.Error())
		}

		// Write the state back to the ledger
		err = stub.PutState(Map, b2.Bytes())
		if err != nil {
			return shim.Error(err.Error())
		}
	}
	return shim.Success(nil)
}

func (t *SimpleChaincode) insert_list(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var List string
	var Element string
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	List = args[0]
	Element = args[1]

	// Get the state from the ledger
	Listbytes, err := stub.GetState(List)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + List + "\"}"
		return shim.Error(jsonResp)
	}

	if Listbytes == nil {
		fmt.Printf("NIL\n")
		// jsonResp := "{\"Error\":\"Nil amount for " + List + "\"}"
		// return shim.Error(jsonResp)
		var NewList []string

		// Add to list
		NewList = append(NewList, Element)
		fmt.Printf("%#v\n", NewList)

		b := new(bytes.Buffer)
		e := gob.NewEncoder(b)
		// Encoding the map
		err = e.Encode(NewList)
		if err != nil {
			return shim.Error(err.Error())
		}

		// Write the state back to the ledger
		err = stub.PutState(List, b.Bytes())
		if err != nil {
			return shim.Error(err.Error())
		}
	} else {
		b := bytes.NewBuffer(Listbytes)
		var decodedList []string
		d := gob.NewDecoder(b)

		// Decoding the serialized data
		err = d.Decode(&decodedList)
		if err != nil {
			shim.Error(err.Error())
		}
		// fmt.Printf("%#v\n", decodedList)
		// Add to map
		decodedList = append(decodedList, Element)

		b2 := new(bytes.Buffer)
		e := gob.NewEncoder(b2)
		// Encoding the map
		err = e.Encode(decodedList)
		if err != nil {
			return shim.Error(err.Error())
		}

		// Write the state back to the ledger
		err = stub.PutState(List, b2.Bytes())
		if err != nil {
			return shim.Error(err.Error())
		}
	}
	return shim.Success(nil)
}

func (t *SimpleChaincode) set_map(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entity
	var Aval string // Asset
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	A = args[0]
	Aval = args[1]
	// Create a list (slice) from the string
	List := strings.Split(Aval, ",")
	// Create a map from the list
	Map := make(map[string]string)
	for i := 0; i < len(List); i +=1 {
		Map[List[i]] = "DummyStringValue"
	}
	fmt.Printf("%#v\n", Map)

	b := new(bytes.Buffer)
	e := gob.NewEncoder(b)
	// Encoding the map
	err = e.Encode(Map)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Write the state back to the ledger
	err = stub.PutState(A, b.Bytes())
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChaincode) set(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entity
	var Aval string // Asset
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	A = args[0]
	Aval = args[1]

	// Write the state back to the ledger
	err = stub.PutState(A, []byte(Aval))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func Split(r rune) bool {
	return r == '[' || r == ',' || r == ']'
}

func (t *SimpleChaincode) set_list(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entity
	var Aval string // Asset
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	A = args[0]
	Aval = args[1]

	// Construct list
	List := strings.FieldsFunc(Aval, Split)

	b := new(bytes.Buffer)
	e := gob.NewEncoder(b)
	// Encoding the list
	err = e.Encode(List)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Write the state back to the ledger
	err = stub.PutState(A, b.Bytes())
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}

func (t *SimpleChaincode) query_list(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entity
	var Aval string // Asset
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	A = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}
	b := bytes.NewBuffer(Avalbytes)
	var decodedList []string
	d := gob.NewDecoder(b)

	// Decoding the serialized data
	err = d.Decode(&decodedList)
	if err != nil {
		shim.Error(err.Error())
	}


	Aval = strings.Join(decodedList[:],",")
	jsonResp := "{\"Name\":\"" + A + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success([]byte(Aval))
}


// Transaction makes payment of X units from A to B
func (t *SimpleChaincode) invoke(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A, B string    // Entities
	var Aval, Bval int // Asset holdings
	var X int          // Transaction value
	var err error

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	A = args[0]
	B = args[1]

	// Get the state from the ledger
	// TODO: will be nice to have a GetAllState call to ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		return shim.Error("Failed to get state")
	}
	if Avalbytes == nil {
		return shim.Error("Entity not found")
	}
	Aval, err = strconv.Atoi(string(Avalbytes))
	if err != nil {
		return shim.Error("Invalid state, expecting a integer value for "+A)
	}

	Bvalbytes, err := stub.GetState(B)
	if err != nil {
		return shim.Error("Failed to get state")
	}
	if Bvalbytes == nil {
		return shim.Error("Entity not found")
	}
	Bval, err = strconv.Atoi(string(Bvalbytes))
	if err != nil {
		return shim.Error("Invalid state, expecting a integer value for "+B)
	}

	// Perform the execution
	X, err = strconv.Atoi(args[2])
	if err != nil {
		return shim.Error("Invalid transaction amount, expecting a integer value")
	}
	Aval = Aval - X
	Bval = Bval + X
	fmt.Printf("Aval = %d, Bval = %d\n", Aval, Bval)

	// Write the state back to the ledger
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(B, []byte(strconv.Itoa(Bval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

// Deletes an entity from state
func (t *SimpleChaincode) delete(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	A := args[0]

	// Delete the key from the state in ledger
	err := stub.DelState(A)
	if err != nil {
		return shim.Error("Failed to delete state")
	}

	return shim.Success(nil)
}

// query callback representing the query of a chaincode
func (t *SimpleChaincode) query(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	A = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	jsonResp := "{\"Name\":\"" + A + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success(Avalbytes)
}

func (t *SimpleChaincode) query_map_keys(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	A = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}
	b := bytes.NewBuffer(Avalbytes)
	var decodedMap map[string]string
	d := gob.NewDecoder(b)

	// Decoding the serialized data
	err = d.Decode(&decodedMap)
	if err != nil {
		shim.Error(err.Error())
	}
	// fmt.Printf("%#v\n", decodedMap)
	keys := make([]string, 0, len(decodedMap))
	for k := range decodedMap {
		keys = append(keys, k)
	}
	Avalstring := strings.Join(keys[:],",")
	jsonResp := "{\"Name\":\"" + A + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success([]byte(Avalstring))
}

func (t *SimpleChaincode) query_map_field(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var Map string
	var Key string
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	Map = args[0]
	Key = args[1]

	// Get the state from the ledger
	Mapbytes, err := stub.GetState(Map)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + Map + "\"}"
		return shim.Error(jsonResp)
	}

	if Mapbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + Map + "\"}"
		return shim.Error(jsonResp)
	}
	b := bytes.NewBuffer(Mapbytes)
	var decodedMap map[string]string
	d := gob.NewDecoder(b)

	// Decoding the serialized data
	err = d.Decode(&decodedMap)
	if err != nil {
		shim.Error(err.Error())
	}
	// fmt.Printf("%#v\n", decodedMap)

	Response := decodedMap[Key]
	// jsonResp := "{\"Name\":\"" + Map + "\",\"Amount\":\"" + string(Mapbytes) + "\"}"
	// fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success([]byte(Response))
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
