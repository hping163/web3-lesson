// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 讨饭合约
contract BeggingContract {
    address private owner; // 合约所有者
    uint256 public totalCollected; // 已收集的金额
    mapping(address => uint256) private contributions; // 每个用户的贡献金额

    // 定义一个结构体数组来存储捐款者信息，方便后面实现排行榜需求
    struct Donor {
        address donorAddress;
        uint256 donationAmount;
    }
    Donor[] private donors;

    // 捐赠事件
    event Donation(address indexed contributor, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // 合约所有者修改器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // 捐款函数
    function donate() public payable {
        require(msg.value > 0, "Contribution amount must be greater than 0");
        // 添加一个时间限制，只有在特定时间段内才能捐赠
        require(
            block.timestamp >= 1690000000 && block.timestamp <= 1690086400,
            "Donation period is over"
        );
        contributions[msg.sender] += msg.value;
        totalCollected += msg.value;
        // 添加捐款者信息
        donors.push(Donor(msg.sender, msg.value));
        emit Donation(msg.sender, msg.value);
    }

    // 查询某个捐款者的金额
    function getDonation() public view returns (uint256) {
        return contributions[msg.sender];
    }

    // 提取捐款
    function withdraw() public onlyOwner {
        require(totalCollected > 0, "No contributions have been made");
        payable(owner).transfer(totalCollected);
        totalCollected = 0;
    }

    // 实现一个功能，显示捐赠金额最多的前 3 个地址
    function getTopDonors() public view returns (address[3] memory) {
        // 创建一个内存副本
        Donor[] memory sortedDonors = donors;
        // 对捐款者数组进行排序
        for (uint256 i = 0; i < sortedDonors.length; i++) {
            for (uint256 j = 0; j < sortedDonors.length - i - 1; j++) {
                if (sortedDonors[j].donationAmount < sortedDonors[j + 1].donationAmount) {
                    Donor memory temp = sortedDonors[j];
                    sortedDonors[j] = sortedDonors[j + 1];
                    sortedDonors[j + 1] = temp;
                }
            }
        }
        // 返回前 3 个捐款者
        address[3] memory topDonors;
        for (uint256 i = 0; i < 3; i++) {
            topDonors[i] = donors[i].donorAddress;
        }
        return topDonors;
    }
}
