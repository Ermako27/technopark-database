package jsonutils

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

// ReadJSON читаем информацию из тела запроса
func ReadJSON(r *http.Request, i interface{}) error {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		return err
	}

	err = json.Unmarshal(body, &i)
	if err != nil {
		return err
	}
	return nil
}

// WriteJSON записываем в ответ json с информацией
func WriteJSON(w http.ResponseWriter, i interface{}, status int) error {
	response, err := json.Marshal(i)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return err
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	w.Write(response)
	return nil
}
