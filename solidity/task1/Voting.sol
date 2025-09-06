// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // 候选人得票数
    mapping(address => uint256) public votes;

    // 投票
    function vote(address _addr) public {
        require(_addr != address(0), "Cannot vote for zero address");
        votes[_addr]++;
    }

    // 获得投票数
    function getVotes(address _addr) public view returns (uint256) {
        return votes[_addr];
    }

    // 重置所有候选人的得票数
    function resetVotes() public {
        for (address _addr in votes) {
            votes[_addr] = 0;
        }
    }

}