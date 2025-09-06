package main

import (
	"log"
	"web3-lesson/go-base/task3/sqlx/models"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

func main() {
	// 连接数据库
	db, err := sqlx.Connect("mysql", "xiyi:9iMq3CTXJIaIctKs@tcp(rm-uf6shof1q7dzz91fato.mysql.rds.aliyuncs.com:3306)/gorm?parseTime=true")
	if err != nil {
		log.Fatalln(err)
	}
	defer db.Close()

	// 查询技术部的所有员工
	employees, err := models.GetEmployeesByDepartment(db, "技术部")
	if err != nil {
		log.Fatalln(err)
	}
	// 打印查询结果
	for _, employee := range employees {
		log.Printf("员工ID: %d, 姓名: %s, 部门: %s, 薪资: %s\n", employee.Id, employee.Name, employee.Department, employee.Salary)
	}

	// 查询员工薪资最高的员工
	highestSalaryEmployee, err := models.GetHighestSalaryEmployee(db)
	if err != nil {
		log.Fatalln(err)
	}
	// 打印查询结果
	log.Printf("薪资最高的员工ID: %d, 姓名: %s, 部门: %s, 薪资: %s\n", highestSalaryEmployee.Id, highestSalaryEmployee.Name, highestSalaryEmployee.Department, highestSalaryEmployee.Salary)

	// 查询书本价格大于50元的所有书籍
	books, err := models.GetBooksByPrice(db)
	if err != nil {
		log.Fatalln(err)
	}
	// 打印查询结果
	for _, book := range books {
		log.Printf("书籍ID: %d, 书名: %s, 作者: %s, 价格: %s\n", book.Id, book.Title, book.Author, book.Price)
	}
}
