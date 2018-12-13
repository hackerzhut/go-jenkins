package models

import (
	"fmt"
	"testing"
)

func TestCreate(t *testing.T) {

	contract := Contact{
		Name:   "Sara",
		Phone:  "041231231",
		UserId: 1321,
	}

	result := contract.Create()

	fmt.Println("result: ====", result)

	if result == nil {
		t.Fatalf("result should not be nil")
	}
}
