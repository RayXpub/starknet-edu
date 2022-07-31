// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./interfaces/IStarknetCore.sol";

contract L2Messager {
    IStarknetCore starknetCore;
    uint256 constant EX2_SELECTOR = 352040181584456735608515580760888541466059565068553383579463728554843487745;
    uint256 private EvaluatorContractAddress;
    uint256 private _l2_user;

    constructor(
        uint256 l2_user
    ) {
        starknetCore = IStarknetCore(0xde29d060D45901Fb19ED6C6e959EB22d8626708e);
        _l2_user = l2_user;
    }

    function sendMessageToL2() public {
        uint256[] memory payload = new uint256[](1);
        payload[0] = _l2_user;
        starknetCore.sendMessageToL2(
            EvaluatorContractAddress,
            EX2_SELECTOR,
            payload
        );
    }
}