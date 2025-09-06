package main

import (
	"fmt"
	"sort"
)

func main() {
	// 136
	nums := []int{2, 2, 1}
	singleNumber := getSingleNumber(nums)
	fmt.Println(singleNumber)

	// 回文数
	fmt.Println(isPalindrome(123))

	// 有效的括号
	fmt.Println(isValid("({})"))

	// 最长公共前缀
	strs := []string{"dog", "docecar", "car"}
	fmt.Println(longestCommonPrefix(strs))

	// 加一
	digits := []int{1, 2, 3}
	fmt.Println(plusOne(digits))

	// 删除有序数组中的重复项
	numbers := []int{1, 1, 2, 2, 3, 3, 4, 4, 5, 5}
	fmt.Println(removeDuplicates(numbers))

	// 合并区间
	intervals := [][]int{{1, 3}, {2, 10}, {2, 6}, {15, 18}}
	fmt.Println(mergeIntervals(intervals))

	// 两数之和
	target := 9
	twoNum := []int{2, 7, 11, 15}
	fmt.Println(towSum(twoNum, target))
}

/**
*  136. 只出现一次的数字：给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。
*  找出那个只出现了一次的元素。可以使用 for 循环遍历数组，结合 if 条件判断和 map 数据结构来解决，
*  例如通过 map 记录每个元素出现的次数，然后再遍历 map 找到出现次数为1的元素。
 */
func getSingleNumber(nums []int) int {
	// 定义一个 map 数据结构，用于记录每个元素出现的次数
	countMap := make(map[int]int)
	// 遍历数组，记录每个元素出现的次数
	for _, num := range nums {
		countMap[num]++
	}
	// 遍历 map 数据结构，找到出现次数为1的元素
	for num, count := range countMap {
		if count == 1 {
			return num
		}
	}
	// 如果没有找到出现次数为1的元素，返回0
	return 0
}

/**
* 判断一个整数是否是回文数
 */
func isPalindrome(x int) bool {
	// 负数不是回文数
	if x < 0 {
		return false
	}
	// 0 是回文数
	if x == 0 {
		return true
	}
	// 将数字反转后比较
	original := x
	reversed := 0
	for x > 0 {
		digit := x % 10
		reversed = reversed*10 + digit
		x /= 10
	}
	return original == reversed
}

/**
* 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
* 有效字符串需满足：
* 1. 左括号必须用相同类型的右括号闭合。
* 2. 左括号必须以正确的顺序闭合。
* 3. 每个右括号都有一个对应的相同类型的左括号。
 */
func isValid(s string) bool {
	// 定义一个 map 数据结构，用于记录每个左括号对应的右括号
	bracketMap := map[byte]byte{
		'(': ')',
		'{': '}',
		'[': ']',
	}
	// 定义一个栈数据结构，用于记录左括号
	var stack []byte
	// 遍历字符串
	for i := 0; i < len(s); i++ {
		// 如果是左括号，入栈
		if _, ok := bracketMap[s[i]]; ok {
			stack = append(stack, s[i])
		} else {
			// 如果是右括号，判断栈顶元素是否匹配
			if len(stack) == 0 {
				return false
			}
			lastIndex := len(stack) - 1
			// 最后一个元素作为key获取值进行判断是否匹配
			if bracketMap[stack[lastIndex]] != s[i] {
				return false
			}
			// 匹配成功，出栈
			stack = stack[:len(stack)-1]
		}
	}
	// 最后判断栈是否为空
	if len(stack) != 0 {
		return false
	}
	return true
}

/**
* 查找字符串数组中的最长公共前缀
* "dog","racecar","car"
 */
func longestCommonPrefix(strs []string) string {
	if len(strs) == 0 {
		return ""
	}
	// 取第一个字符串作为基准
	prefix := strs[0]
	// 遍历字符串数组
	for i := 1; i < len(strs); i++ {
		// 比较基准字符串和当前字符串的公共前缀
		for j := 0; j < len(prefix); j++ {
			if j >= len(strs[i]) || strs[i][j] != prefix[j] {
				prefix = prefix[:j]
				break
			}
		}
	}
	return prefix
}

/**
* 给定一个表示 大整数 的整数数组 digits，其中 digits[i] 是整数的第 i 位数字。这些数字按从左到右，从最高位到最低位排列。这个大整数不包含任何前导 0。
* 将大整数加 1，并返回结果的数字数组。
 */
func plusOne(digits []int) []int {
	// 从最低位开始加1
	for i := len(digits) - 1; i >= 0; i-- {
		digits[i]++
		// 如果当前位小于10，直接返回
		if digits[i] < 10 {
			return digits
		}
		// 如果当前位等于10，将当前位设为0，继续向高位进1
		digits[i] = 0
	}
	// 如果所有位都等于10，说明需要在最高位前添加1
	return append([]int{1}, digits...)
}

/**
* 26. 删除有序数组中的重复项,返回新去重后的数组
 */
func removeDuplicates(nums []int) []int {
	if len(nums) == 0 {
		return []int{}
	}
	// 定义一个指针，用于记录不重复元素的位置
	index := 0
	// 遍历数组
	for i := 1; i < len(nums); i++ {
		// 如果当前元素与前一个元素不同，说明是不重复元素
		if nums[i] != nums[index] {
			// 将指针后移一位
			index++
			// 将当前元素赋值给指针位置
			nums[index] = nums[i]
		}
	}
	// 返回不重复数组
	return nums[:index+1]
}

/**
* 56. 合并区间
* 以数组 intervals 表示若干个区间的集合，其中单个区间为 intervals[i] = [starti, endi] 。
* 请你合并所有重叠的区间，并返回 一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间 。
 */
func mergeIntervals(intervals [][]int) [][]int {
	// 先根据区间起始位置进行排序
	sort.Slice(intervals, func(i, j int) bool {
		return intervals[i][0] < intervals[j][0]
	})
	// 定义一个结果数组，用于存储合并后的区间
	var res [][]int
	// 遍历排序后的区间数组
	for _, interval := range intervals {
		// 如果结果数组为空，或者当前区间的起始位置大于结果数组中最后一个区间的结束位置，说明没有重叠
		if len(res) == 0 || interval[0] > res[len(res)-1][1] {
			// 直接将当前区间添加到结果数组中
			res = append(res, interval)
		} else {
			// 否则说明有重叠，更新结果数组中最后一个区间的结束位置
			res[len(res)-1][1] = max(res[len(res)-1][1], interval[1])
		}
	}
	return res
}

/**
* 两数之和
 */
func towSum(nums []int, target int) []int {
	// 定义一个 map 数据结构，用于记录每个元素对应的索引
	indexMap := make(map[int]int)
	// 遍历数组
	for i, num := range nums {
		// 计算当前元素与目标值的差
		diff := target - num
		// 如果差在 map 中，说明找到了解
		if index, ok := indexMap[diff]; ok {
			return []int{index, i}
		}
		// 如果差不在 map 中，将当前元素和索引添加到 map 中
		indexMap[num] = i
	}
	return []int{}
}
