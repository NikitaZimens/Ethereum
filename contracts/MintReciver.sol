// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "./ElegiaRub.sol";

contract MintReceiver is IReceiver {
    ElegiaRub public elegiaRub; // Ссылка на контракт токена
    address public recipient;   // Получатель токенов

    event MintReceived(address indexed minter, uint256 amount, bytes data);

    constructor(address _elegiaRubAddress, address _recipient) {
        require(_elegiaRubAddress != address(0), "Invalid token contract address");
        require(_recipient != address(0), "Invalid recipient address");

        elegiaRub = ElegiaRub(_elegiaRubAddress);
        recipient = _recipient;
    }

    /**
     * @notice Функция для обработки события "минтинга".
     * @param amount Количество токенов.
     * @param data Дополнительные данные.
     */
    function onMint(uint256 amount, bytes calldata data) external override {
        require(msg.sender == address(elegiaRub), "Caller is not the token contract");
        require(amount > 0, "Amount must be greater than zero");

        // Перевод токенов на адрес получателя
        elegiaRub.transfer(recipient, amount);

        emit MintReceived(msg.sender, amount, data);
    }

    /**
     * @notice Обновление адреса получателя.
     * @param newRecipient Новый адрес получателя.
     */
    function updateRecipient(address newRecipient) external {
        require(newRecipient != address(0), "Invalid recipient address");
        recipient = newRecipient;
    }
}
