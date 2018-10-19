package dbutils

import (
	"database/sql"
	"io/ioutil"
)

func CreateTables(db *sql.DB) error {
	content, err := ioutil.ReadFile("migrations/create_tables.sql")
	if err != nil {
		return err
	}

	sqlCommand := string(content)
	_, err = db.Exec(sqlCommand)
	return err
}
