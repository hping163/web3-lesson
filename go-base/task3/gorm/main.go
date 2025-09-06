package main

import (
	"fmt"
	"web3-lesson/go-base/task3/gorm/models"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// 连接数据库
func initDB() *gorm.DB {
	url := "xiyi:9iMq3CTXJIaIctKs@tcp(rm-uf6shof1q7dzz91fato.mysql.rds.aliyuncs.com:3306)/gorm?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(url), &gorm.Config{})
	if err != nil {
		panic("数据库连接失败")
	}
	return db
}

func main() {
	// 初始化连接
	db := initDB()

	// 题目1：模型定义
	db.AutoMigrate(&models.User{})
	db.AutoMigrate(&models.Post{})
	db.AutoMigrate(&models.Comment{})

	// 题目2：关联查询
	// 查询某个用户发布的所有文章及其对应的评论信息。
	var user models.User
	db.Where("name = ?", "张三").First(&user)

	var posts []models.Post
	db.Where("user_id = ?", user.ID).Find(&posts)
	// 预加载评论
	db.Preload("Comments").Find(&posts)

	for _, post := range posts {
		var comments []models.Comment
		db.Where("post_id = ?", post.ID).Find(&comments)
		post.Comments = append(post.Comments, comments...)
	}
	// 打印
	for _, post := range posts {
		fmt.Println("文章标题：", post.Title)
		for _, comment := range post.Comments {
			fmt.Println("文章评论：", comment.Content)
		}
	}

	// 查询评论数量最多的文章信息
	var mostComment struct {
		PostID int
		Count  int
	}
	db.Model(&models.Comment{}).
		Select("post_id, count(*) as count").
		Group("post_id").
		Order("count desc").
		First(&mostComment)
	// 查询文章标题
	var post models.Post
	db.Where("id = ?", mostComment.PostID).First(&post)
	fmt.Println("评论数量最多的文章标题：", post)

	// 题目3：钩子函数
	// 在文章创建时自动更新用户的文章数量统计字段
	addPost := models.Post{
		Title:         "文章标题22",
		Content:       "文章内容22",
		UserID:        1,
		CommentCount:  0,
		CommentStatus: "",
	}
	db.Create(&addPost)

	// 在评论删除时检查文章的评论数量，如果评论数量为 0，则更新文章的评论状态为 "无评论"。
	comment := models.Comment{
		ID:     3,
		PostID: 2,
	}
	db.Delete(&comment)

}
