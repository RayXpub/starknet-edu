// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./interfaces/IStarknetCore.sol";

contract L2Messager {
    IStarknetCore starknetCore;
    uint256 constant EX2_SELECTOR = 897827374043036985111827446442422621836496526085876968148369565281492581228;
    uint256 private _evaluatorContractAddress;
    uint256 private _l2_user;

    bytes32 public lastMsg;

    constructor(
        uint256 l2_user,
        uint256 evaluatorContractAddress
    ) {
        starknetCore = IStarknetCore(0xde29d060D45901Fb19ED6C6e959EB22d8626708e);
        _evaluatorContractAddress = evaluatorContractAddress;
        _l2_user = l2_user;
    }

    function sendMessageToL2() public {
        uint256[] memory payload = new uint256[](1);
        payload[0] = _l2_user;
        (bytes32 msgHash, ) = starknetCore.sendMessageToL2(
            _evaluatorContractAddress,
            EX2_SELECTOR,
            payload
        );
        lastMsg = msgHash;
    }
}