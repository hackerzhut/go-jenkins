package models

import (
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/joho/godotenv"
	"os"
)

var db *gorm.DB

func init() {

	e := godotenv.Load()
	if e != nil {
		fmt.Print(e)
	}

	dbURI := os.Getenv("DB_CONNECTION")

	if dbURI == "" {
		username := "postgres"
		password := "postgres"
		dbName := "postgres"
		dbHost := "db"

		//host=db port=5432 dbname=postgres user=postgres password=postgres sslmode=disable

		dbURI = fmt.Sprintf("host=%s port=5432 user=%s dbname=%s password=%s sslmode=disable", dbHost, username, dbName, password)
	}

	fmt.Println("*********", dbURI)

	conn, err := gorm.Open("postgres", dbURI)
	if err != nil {
		fmt.Print(err)
	}

	db = conn
	db.Debug().AutoMigrate(&Account{}, &Contact{})
}

func GetDB() *gorm.DB {
	return db
}
