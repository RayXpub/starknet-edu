// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./interfaces/IStarknetCore.sol";

contract L1Receiver {
    IStarknetCore private _starknetCore;

    constructor() {
        _starknetCore = IStarknetCore(0xde29d060D45901Fb19ED6C6e959EB22d8626708e);
    }

    function consumeMessage(uint256 l2Evaluator, uint256 l2User) public {
        uint256[] memory payload = new uint256[](1);
        payload[0] =  l2User;
        _starknetCore.consumeMessageFromL2(l2Evaluator, payload);
    }
}