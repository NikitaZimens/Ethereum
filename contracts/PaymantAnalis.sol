// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenSplitter {
    address public recipient1; // Получатель 30%
    address public recipient2; // Получатель 30%
    address public recipient3; // Получатель 40%

    event TokensSplit(address sender, uint256 totalAmount, uint256 toRecipient1, uint256 toRecipient2, uint256 toRecipient3);

    constructor(address _recipient1, address _recipient2, address _recipient3) {
        require(_recipient1 != address(0) && _recipient2 != address(0) && _recipient3 != address(0), "Invalid address");
        recipient1 = _recipient1;
        recipient2 = _recipient2;
        recipient3 = _recipient3;
    }

    /**
     * @dev Метод для деления токенов и распределения их между тремя адресами.
     * @param tokenAddress Адрес токена (ERC-20).
     * @param amount Сумма токенов, которую необходимо распределить.
     */
    function splitTokens(address tokenAddress, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        ERC20 token = ERC20(tokenAddress);

        // Перевод токенов на этот контракт
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        // Расчет долей
        uint256 amount30 = (amount * 30) / 100; // 30%
        uint256 amount40 = (amount * 40) / 100; // 40%

        // Выплаты получателям
        require(token.transfer(recipient1, amount30), "Transfer to recipient1 failed");
        require(token.transfer(recipient2, amount30), "Transfer to recipient2 failed");
        require(token.transfer(recipient3, amount40), "Transfer to recipient3 failed");

        emit TokensSplit(msg.sender, amount, amount30, amount30, amount40);
    }
}