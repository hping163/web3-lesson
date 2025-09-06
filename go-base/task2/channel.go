package main

import (
	"fmt"
	"sync"
)

/*
* 题目 1 编写一个程序，使用通道实现两个协程之间的通信。一个协程生成从1到10的整数，并将这些整数发送到通道中，另一个协程从通道中接收这些整数并打印出来。
 */

// 发送到通道
func sendChannel(wg *sync.WaitGroup, _chan chan int) {
	defer wg.Done()
	for i := 0; i < 10; i++ {
		_chan <- i
	}
	close(_chan)
}

// 接收通道
func receiveChannel(wg *sync.WaitGroup, _chan chan int) {
	defer wg.Done()
	for i := range _chan {
		fmt.Println(i)
	}
}

/*
 * 题目 2 实现一个带有缓冲的通道，生产者协程向通道中发送100个整数，消费者协程从通道中接收这些整数并打印。
 */

// 发送到通道
func sendChannelBuffer(wg *sync.WaitGroup, _chan chan int) {
	defer wg.Done()
	for i := 0; i < 100; i++ {
		_chan <- i
	}
	close(_chan)
}

// 接收通道
func receiveChannelBuffer(wg *sync.WaitGroup, _chan chan int) {
	defer wg.Done()
	for i := range _chan {
		fmt.Println(i)
	}
}

func main() {
	// 题目1
	_chan := make(chan int)
	var sw sync.WaitGroup
	sw.Add(2)
	// 发送携程
	go sendChannel(&sw, _chan)
	// 接收携程
	go receiveChannel(&sw, _chan)
	// 等待协程执行完成
	sw.Wait()

	fmt.Println("题目1完成")
	fmt.Println()

	// 题目2
	_chanBuffer := make(chan int, 10)
	var sw2 sync.WaitGroup
	sw2.Add(2)
	// 发送携程
	go sendChannelBuffer(&sw2, _chanBuffer)
	// 接收携程
	go receiveChannelBuffer(&sw2, _chanBuffer)
	// 等待协程执行完成
	sw2.Wait()
}
