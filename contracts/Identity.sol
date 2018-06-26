pragma solidity ^0.4.19;

import './KeyHolder.sol';
import './ClaimHolder.sol';

contract Identity is KeyHolder, ClaimHolder {
    event IdentityCreated(uint256 version);

    function Identity() public {
        IdentityCreated(0x1);
    }
}
