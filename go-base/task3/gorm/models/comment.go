package models

import "gorm.io/gorm"

type Comment struct {
	ID      uint   `gorm:"primaryKey"`
	PostID  uint   `gorm:"column:post_id"`
	UserID  uint   `gorm:"column:user_id"`
	Content string `gorm:"column:content"`
}

func (c *Comment) TableName() string {
	return "comment"
}

// 在评论删除时检查文章的评论数量，如果评论数量为 0，则更新文章的评论状态为 "无评论"。
func (c *Comment) BeforeDelete(db *gorm.DB) (err error) {
	var post Post
	db.Where("id = ?", c.PostID).First(&post)
	if post.CommentCount > 0 {
		post.CommentCount--
	}
	if post.CommentCount == 0 {
		post.CommentStatus = "无评论"
	}
	db.Save(&post)
	return
}
