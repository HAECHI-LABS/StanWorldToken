pragma solidity 0.6.5;

import "./erc20/ERC20Lockable.sol";
import "./erc20/ERC20Burnable.sol";
import "./erc20/ERC20Mintable.sol";
import "./library/Pausable.sol";
import "./library/Freezable.sol";

contract StanWorld is
    ERC20Lockable,
    ERC20Burnable,
    ERC20Mintable,
    Freezable
{
    string constant private _name = "StanWorld";
    string constant private _symbol = "STAN";
    uint8 constant private _decimals = 18;
    uint256 constant private _initial_supply = 1_000_000_000;

    constructor() public Ownable() {
        _cap = 10_000_000_000 * (10**uint256(_decimals));
        _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
    }

    function transfer(address to, uint256 amount)
        override
        external
        whenNotFrozen(msg.sender)
        whenNotPaused
        checkLock(msg.sender, amount)
        returns (bool success)
    {
        require(
            to != address(0),
            "STAN/transfer : Should not send to zero address"
        );
        _transfer(msg.sender, to, amount);
        success = true;
    }

    function transferFrom(address from, address to, uint256 amount)
        override
        external
        whenNotFrozen(from)
        whenNotPaused
        checkLock(from, amount)
        returns (bool success)
    {
        require(
            to != address(0),
            "STAN/transferFrom : Should not send to zero address"
        );
        _transfer(from, to, amount);
        _approve(
            from,
            msg.sender,
            _allowances[from][msg.sender].sub(
                amount,
                "STAN/transferFrom : Cannot send more than allowance"
            )
        );
        success = true;
    }

    function approve(address spender, uint256 amount)
        override
        external
        returns (bool success)
    {
        require(
            spender != address(0),
            "STAN/approve : Should not approve zero address"
        );
        _approve(msg.sender, spender, amount);
        success = true;
    }

    function name() override external view returns (string memory tokenName) {
        tokenName = _name;
    }

    function symbol() override external view returns (string memory tokenSymbol) {
        tokenSymbol = _symbol;
    }

    function decimals() override external view returns (uint8 tokenDecimals) {
        tokenDecimals = _decimals;
    }
}
