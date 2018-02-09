pragma solidity ^0.4.18;

import './ERC735.sol';
import './KeyHolder.sol';

contract ClaimHolder is KeyHolder, ERC735 {
    using ByteArr for bytes32;


    mapping (uint256 => Claim) pendingClaims; //TODO: remove and resolve pending claims possibly as executions
    mapping (bytes32 => Claim) claims;
    mapping (uint256 => uint256[]) claimsByType;

    // signature
    function addClaim(uint256 _claimType, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri) public returns (uint256 claimRequestId) {
        require(_signature == keccak256(address(this),_claimType,_data));

        issuer.getKeysByPurpose(3).indexOf(??claimerKey);
        claims[claimNonce].claimType = _claimType;
        claims[claimNonce].scheme = _scheme;
        claims[claimNonce].issuer = _issuer;
        claims[claimNonce].signature = _signature;
        claims[claimNonce].data = _data;
        claims[claimNonce].uri = _uri;

        claimsByType[_claimType].push(claimNonce);
        claimNonce++;
        return claimNonce-1;
    }
    function verifySignature() returns (bool verified) {

    }

    function removeClaim(bytes32 _claimId) public returns (bool success) {
        require(msg.sender == claims[_claimId].issuer || msg.sender == address(this));

        var (index, isThere) = claimsByType[claims[_claimId].claimType].indexOf(_claimId);
        claimsByType[claims[_claimId].claimType].removeByIndex(index);

        delete claims[_claimId];

        return true;
    }

    function getClaim(bytes32 _claimId) public constant returns(uint256 claimType, uint256 scheme, address issuer, bytes signature, bytes data, string uri);
    function getClaimIdsByType(uint256 _claimType) public constant returns(bytes32[] claimIds);

}