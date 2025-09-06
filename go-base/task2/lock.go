package main

import (
	"fmt"
	"sync"
	"sync/atomic"
)

/*
 * 题目1 ：编写一个程序，使用 sync.Mutex 来保护一个共享的计数器。启动10个协程，每个协程对计数器进行1000次递增操作，最后输出计数器的值。
 */

var (
	sum int
	mu  sync.Mutex
	wg  sync.WaitGroup
)

// 计数
func count(mu *sync.Mutex) {
	mu.Lock()
	for i := 0; i < 1000; i++ {
		sum += 1
	}
	fmt.Println("每一次循环的sum值为：", sum)
	mu.Unlock()
	wg.Done()
}

/*
* 题目2 ：使用原子操作（ sync/atomic 包）实现一个无锁的计数器。启动10个协程，每个协程对计数器进行1000次递增操作，最后输出计数器的值。
 */
var (
	counter int64
)

// 计数
func countAtomic() {
	for i := 0; i < 1000; i++ {
		atomic.AddInt64(&counter, 1)
	}
	fmt.Println("每一次循环的counter值为：", counter)
	wg.Done()
}

func main() {
	wg.Add(10)
	for i := 0; i < 10; i++ {
		go count(&mu)
	}
	wg.Wait()
	fmt.Println("sum最终值为：", sum)

	fmt.Println()

	// 题目2
	wg.Add(10)
	for i := 0; i < 10; i++ {
		go countAtomic()
	}
	wg.Wait()
	fmt.Println("counter最终值为：", counter)
}
