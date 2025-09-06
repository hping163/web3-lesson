// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyERC20 {
    // 定义发送方异常
    error ERC20InvalidSender(address sender);
    // 定义接受方异常
    error ERC20InvalidReceiver(address receiver);
    // 定义更新余额异常
    error ERC20InsufficientBalance(
        address from,
        uint256 fromBalance,
        uint256 amount
    );
    // 定义更新授权异常
    error ERC20InsufficientAllowance(
        address spender,
        uint256 allowance,
        uint256 amount
    );
    // 名称
    string private _name;
    // 符号
    string private _symbol;
    // 总供应量
    uint256 private _totalSupply;
    // 账户余额
    mapping(address => uint256) private _balances;
    // 某个账号授权给某个账号允许话费的金额
    mapping(address => mapping(address => uint256)) private _allowances;

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed from, address indexed to, uint256 value);

    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
    }

    // 获取名称
    function name() public view returns (string memory) {
        return _name;
    }
    // 获取标记
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // 查询账户余额
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // 查询总供应量
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // 查询allowances
    function allowances(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    // 转账
    function transter(address to, uint256 amount) public returns (bool) {
        _transter(msg.sender, to, amount);
        return true;
    }

    // 转账验证
    function _transter(address from, address to, uint256 amount) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, amount);
    }

    // 授权
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // 内部函数
    function _approve(address owner, address spender, uint256 amount) internal {
        if (owner == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _allowances[owner][spender] = amount; // 更新授权金额
        emit Approval(owner, spender, amount); // 发送授权事件
    }

    // 某账号授权给某个账号(msg.sender)代扣转账
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        uint256 currentAllowances = _allowances[from][spender];
        if (currentAllowances != type(uint256).max) {
            if (currentAllowances < amount) {
                revert ERC20InsufficientAllowance(
                    spender,
                    currentAllowances,
                    amount
                );
            }
            unchecked {
                _approve(from, spender, currentAllowances - amount);
            }
        }
        _transter(from, to, amount);
        return true;
    }

    // 铸币
    function mint(address to, uint256 amount) public {
        _update(address(0), to, amount);
    }

    // 更新账户余额
    function _update(address from, address to, uint256 amount) internal {
        if (from == address(0)) {
            _totalSupply += amount;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < amount) {
                revert ERC20InsufficientBalance(from, fromBalance, amount);
            }
            unchecked {
                _balances[from] -= amount;
            }
        }
        if (to == address(0)) {
            unchecked {
                _totalSupply -= amount;
            }
        } else {
            unchecked {
                _balances[to] += amount;
            }
        }
        emit Transfer(from, to, amount); // 发送转账事件)
    }
}
