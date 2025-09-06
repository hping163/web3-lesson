package models

import "gorm.io/gorm"

type Post struct {
	ID            uint      `gorm:"primaryKey"`
	Title         string    `gorm:"column:title"`
	Content       string    `gorm:"column:content"`
	UserID        uint      `gorm:"column:user_id"`
	CommentCount  uint      `gorm:"column:comment_count"`
	CommentStatus string    `gorm:"column:comment_status"`
	Comments      []Comment `gorm:"foreignKey:PostID;references:ID"`
}

func (p *Post) TableName() string {
	return "post"
}

// 钩子函数
func (p *Post) BeforeCreate(tx *gorm.DB) (err error) {
	// 文章创建时，更新用户的文章数量统计字段
	var user User
	tx.Where("id = ?", p.UserID).First(&user)
	user.PostCount++
	tx.Save(&user)
	return
}
