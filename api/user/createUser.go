package user

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/technopark-database/api"
	"github.com/technopark-database/jsonutils"
)

type userSlice []api.UserModel

func CreateUserHandler(db *sql.DB) func(http.ResponseWriter, *http.Request) {

	createuser := func(w http.ResponseWriter, r *http.Request) {
		var input api.UserModel
		err := jsonutils.ReadJSON(r, &input)
		if err != nil {
			w.WriteHeader(400)
			return
		}

		action(w, input, db)
	}
	return createuser
}

func action(w http.ResponseWriter, input api.UserModel, db *sql.DB) {
	var output api.UserModel

	sqlQuery := "SELECT nickname, fullname, about, email FROM users WHERE nickname = $1 OR email = $2"
	rows, err := db.Query(sqlQuery, input.Nickname, input.Email)
	defer rows.Close()

	if err != nil {
		log.Println("error: apiforum.createForumAction: SELECT by nickname start:", err)
		w.WriteHeader(500)
		return
	}
	// возможно при прочтении будет теряться первая запись
	if !rows.Next() { // если результат запроса не пустой значит есть пользователи с таким именем или email
		oldUsers := make(userSlice, 0, 2)
		for rows.Next() {
			var user api.UserModel
			err = rows.Scan(&user.Nickname, &user.Fullname, &user.About, &user.Email)

			if err != nil {
				log.Println("error: apiforum.createForumAction: SELECT by nickname iter:", err)
				w.WriteHeader(500)
				return
			}

			oldUsers = append(oldUsers, user)
		}

		jsonutils.WriteJSON(w, oldUsers, 409)
		return

	} else {
		sqlInsert := "INSERT INTO users (nickname, fullname, about, email) VALUES ($1, $2, $3, $4)"
		_, err = db.Exec(sqlInsert, input.Nickname, input.Fullname, input.About, input.Email)

		if err != nil {
			log.Println("error: apiuser.createUserAction: INSERT:", err)
			w.WriteHeader(500)
			return
		}

		output.Nickname = input.Nickname
		output.Fullname = input.Fullname
		output.About = input.About
		output.Email = input.Email

		jsonutils.WriteJSON(w, output, 201)
	}
}
