package models

import "github.com/jmoiron/sqlx"

// 员工实体
type Employee struct {
	Id         int    `db:"id"`
	Name       string `db:"name"`
	Department string `db:"department"`
	Salary     string `db:"salary"`
}

// 查询技术部的所有员工
func GetEmployeesByDepartment(db *sqlx.DB, department string) ([]*Employee, error) {
	var employees []*Employee
	err := db.Select(&employees, "SELECT * FROM employees WHERE department = ?", department)
	if err != nil {
		return nil, err
	}
	return employees, nil
}

// 查询员工薪资最高的员工
func GetHighestSalaryEmployee(db *sqlx.DB) (*Employee, error) {
	var employee Employee
	err := db.Get(&employee, "SELECT * FROM employees ORDER BY salary DESC LIMIT 1")
	if err != nil {
		return nil, err
	}
	return &employee, nil
}
