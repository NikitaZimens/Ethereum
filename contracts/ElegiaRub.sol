// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IReceiver {
    function onMint(uint256 amount, bytes calldata data) external;
}

contract ElegiaRub is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("Elegia Rub", "ERUB")
        Ownable(initialOwner)
        ERC20Permit("Elegia Rub")
    {
        require(initialOwner != address(0), "Invalid owner address");
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Cannot mint to the zero address");
        _mint(to, amount);
    }

    function mintAndCall(address to, uint256 amount, bytes calldata data) public onlyOwner returns (bool) {
        require(to != address(0), "Cannot mint to the zero address");
        _mint(to, amount);
        
        if (isContract(to)) {
            try IReceiver(to).onMint(amount, data) {
                // Successful call
            } catch {
                revert("mintAndCall: Receiver contract did not handle the call");
            }
        }

        return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}