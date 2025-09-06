package models

type User struct {
	ID        uint   `gorm:"primaryKey"`
	Name      string `gorm:"column:name"`
	Age       int    `gorm:"column:age"`
	Email     string `gorm:"column:email"`
	PostCount uint    `gorm:"column:post_count"`
	Posts     []Post `gorm:"foreignKey:UserID;references:ID"`
}

func (u *User) TableName() string {
	return "user"
}
