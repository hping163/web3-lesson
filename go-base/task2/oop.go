package main

import "fmt"

/**
* 题目1：定义一个 Shape 接口，包含 Area() 和 Perimeter() 两个方法。
* 然后创建 Rectangle 和 Circle 结构体，实现 Shape 接口。在主函数中，
* 创建这两个结构体的实例，并调用它们的 Area() 和 Perimeter() 方法。
 */

// 定义Shape接口
type Shape interface {
	Area()
	Perimeter()
}

// Rectangle 长方形 结构体
type Rectangle struct {
	Width  float64
	Height float64
}

// 实现接口Shape的Area方法
func (r *Rectangle) Area() {
	fmt.Println("长方形的面积为：", r.Width*r.Height)
}

// 实现接口Shape的Perimeter方法
func (r *Rectangle) Perimeter() {
	fmt.Println("长方形的周长为：", 2*(r.Width+r.Height))
}

// Circle 结构体
type Circle struct {
	Radius float64
}

// 实现接口Shape的Area方法
func (c *Circle) Area() {
	fmt.Println("圆的面积为：", 3.14*c.Radius*c.Radius)
}

// 实现接口Shape的Perimeter方法
func (c *Circle) Perimeter() {
	fmt.Println("圆的周长为：", 2*3.14*c.Radius)
}

/*
* 题目 ：使用组合的方式创建一个 Person 结构体，包含 Name 和 Age 字段，
* 再创建一个 Employee 结构体，组合 Person 结构体并添加 EmployeeID 字段。为 Employee 结构体实现一个 PrintInfo() 方法，输出员工的信息。
 */
// Persion结构体
type Person struct {
	Name string
	Age  int
}

// Employee 结构体
type Employee struct {
	Person
	EmployeeID int
}

// Employee 结构体的 PrintInfo() 方法
func (e *Employee) PrintInfo() {
	fmt.Println("员工姓名：", e.Name)
	fmt.Println("员工年龄：", e.Age)
	fmt.Println("员工ID：", e.EmployeeID)
}

/*func main() {
	// 创建Rectangle实例
	rect := &Rectangle{
		Width:  5,
		Height: 3,
	}
	// 创建Circle实例
	circle := &Circle{
		Radius: 4,
	}
	// 长方形调用方法
	rect.Area()
	rect.Perimeter()

	// 圆形调用方法
	circle.Area()
	circle.Perimeter()

	fmt.Println()
	fmt.Println("===========员工信息============")
	fmt.Println()
	// 创建Employee实例
	emp := &Employee{
		Person: Person{
			Name: "张三",
			Age:  30,
		},
		EmployeeID: 1001,
	}
	// 调用Employee的PrintInfo()方法
	emp.PrintInfo()
}*/
