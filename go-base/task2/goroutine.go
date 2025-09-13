package main

import (
	"fmt"
)

/*
* 题目1 ：编写一个程序，使用 go 关键字启动两个协程，一个协程打印从1到10的奇数，另一个协程打印从2到10的偶数。
* 考察点 ： go 关键字的使用、协程的并发执行
 */
func printOdd() {
	for i := 1; i <= 10; i += 2 {
		fmt.Print(i)
	}
	fmt.Println()
}
func printEven() {
	for i := 2; i <= 10; i += 2 {
		fmt.Print(i)
	}
	fmt.Println()
}

/*
* 题目2 ：设计一个任务调度器，接收一组任务（可以用函数表示），并使用协程并发执行这些任务，同时统计每个任务的执行时间。
 */
func taskSchudle(tasks []func()) {
	for _, task := range tasks {
		go task()
	}
}

/*func main() {

	// 打印1-10的奇数
	// go printOdd()
	// 打印2-10的偶数
	// go printEven()

	// 任务调度器
	tasks := []func(){
		printOdd,
		printEven,
	}
	taskSchudle(tasks)

	// 等待协程执行完成
	time.Sleep(time.Second * 1)

}*/
