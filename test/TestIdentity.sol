pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/Identity.sol";

contract TestIdentity {
    function testNoop() public {
        Assert.equal(uint(1), uint(1), "noop");
    }
}