package main

import (
	"database/sql"
	"log"

	"github.com/Ermako27/technopark-database/dbutils"
)

func main() {
	db, err := sql.Open("postgres", "user=docker password=docker1828 dbname=docker sslmode=disable")
	err = dbutils.CreateTables(db)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

}
