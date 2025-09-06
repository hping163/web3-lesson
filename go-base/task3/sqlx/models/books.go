package models

import "github.com/jmoiron/sqlx"

// 定义书的模型
type Book struct {
	Id     int    `db:"id"`
	Title  string `db:"title"`
	Author string `db:"author"`
	Price  string `db:"price"`
}

// 查询书本价格大于50元的所有书籍
func GetBooksByPrice(db *sqlx.DB) ([]*Book, error) {
	var books []*Book
	err := db.Select(&books, "SELECT * FROM books WHERE price > 50")
	if err != nil {
		return nil, err
	}
	return books, nil
}
