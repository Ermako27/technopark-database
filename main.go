package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"

	// "github.com/Ermako27/technopark-database/api/user"
	// "github.com/Ermako27/technopark-database/dbutils"

	"technopark-database/api/user"
	"technopark-database/dbutils"

	"github.com/gorilla/mux"
)

const (
	PORT   = 5000
	dbhost = "localhost"
	dbport = "5432"
	dbuser = "docker"
	dbpass = "docker1828"
	dbname = "docker"
)

func main() {
	r := mux.NewRouter()

	dbinfo := fmt.Sprintf("host=%s port=%s user=%s "+
		"password=%s dbname=%s sslmode=disable",
		dbhost, dbport, dbuser, dbpass, dbname)

	db, err := sql.Open("postgres", dbinfo)

	if err != nil {
		log.Fatal(err)
	}

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	err = dbutils.CreateTables(db)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Successfully connected!")
	defer db.Close()

	r.HandleFunc("/api/user/{nickname:[a-z]+}/create", user.CreateUserHandler(db)).Methods("POST")
	log.Fatal(http.ListenAndServe(":5000", r))
}
