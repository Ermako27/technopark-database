package main

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/Ermako27/technopark-database/api/user"
	"github.com/Ermako27/technopark-database/dbutils"

	// "technopark-database/api/user"
	// "technopark-database/dbutils"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()
	db, err := sql.Open("postgres", "user=docker password=docker1828 dbname=docker sslmode=disable")
	err = dbutils.CreateTables(db)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	r.HandleFunc("/api/user/{nickname:[a-z]+}/create", user.CreateUserHandler(db)).Methods("POST")
	log.Fatal(http.ListenAndServe(":5000", r))
}
