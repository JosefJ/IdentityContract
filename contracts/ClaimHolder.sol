pragma solidity ^0.4.19;

import './ByteArr.sol';
import './ERC735.sol';
import './KeyHolder.sol';

contract ClaimHolder is KeyHolder, ERC735 {
    using ByteArr for bytes32;
    using ByteArr for bytes32[];
    using ByteArr for uint256[];

    uint256 claimNonce;
    mapping (uint256 => Claim) claims;
    mapping (uint256 => uint256[]) claimsByType;

    function addClaim(uint256 _claimType, address _issuer, bytes _signature, bytes32 _claimerKey, bytes _data, string _uri) internal returns (uint256 claimRequestId) {
        // require(_signature == keccak256(address(this),_claimType,_data));
        // sending unhashed public key or hashed key for keys longer than 32 bytes;
        KeyHolder issuer = KeyHolder(issuer);
        require(issuer.keyHasPurpose(keccak256(_claimerKey),3));

        claims[claimNonce].claimType = _claimType;
        claims[claimNonce].issuer = _issuer;
        claims[claimNonce].signature = _signature;
        claims[claimNonce].key = _claimerKey;
        claims[claimNonce].data = _data;
        claims[claimNonce].uri = _uri;

        claimsByType[_claimType].push(claimNonce);
        ClaimAdded(claimNonce, _claimType, _issuer, _signature, _claimerKey, _data, _uri);

        claimNonce++;
        return claimNonce-1;
    }

    function changeClaim(uint256 _claimId, uint256 _claimType, address _issuer, bytes _signature, bytes32 _claimerKey, bytes _data, string _uri) internal returns (bool success) {
        require(_claimId <= claimNonce);
        if (claims[_claimId].claimType != _claimType) {
            uint index;
            (index,) = claimsByType[claims[_claimId].claimType].indexOf(_claimId);
            claimsByType[claims[_claimId].claimType].removeByIndex(index);
            claimsByType[_claimType].push(_claimId);
        }

        // TODO: test gas effectivity
        delete claims[_claimId];

        claims[_claimId].claimType = _claimType;
        claims[_claimId].issuer = _issuer;
        claims[_claimId].signature = _signature;
        claims[_claimId].key = _claimerKey;
        claims[_claimId].data = _data;
        claims[_claimId].uri = _uri;

        ClaimChanged(_claimId, _claimType, _issuer, _signature, _claimerKey, _data, _uri);
        return true;
    }

    function removeClaim(uint256 _claimId) internal returns (bool success) {
        require(msg.sender == claims[_claimId].issuer || msg.sender == address(this));
        uint index;
        (index, ) = claimsByType[claims[_claimId].claimType].indexOf(_claimId);
        claimsByType[claims[_claimId].claimType].removeByIndex(index);

        ClaimRemoved(_claimId, claims[_claimId].claimType, claims[_claimId].issuer, claims[_claimId].signature, claims[_claimId].key, claims[_claimId].data, claims[_claimId].uri);
        delete claims[_claimId];
        return true;
    }

    function getClaim(uint256 _claimId) public constant returns(uint256 claimType, address issuer, bytes signature, bytes32 claimerKey, bytes data, string uri) {
        return (claims[_claimId].claimType, claims[_claimId].issuer, claims[_claimId].signature, claims[_claimId].key, claims[_claimId].data, claims[_claimId].uri);
    }

    function getClaimIdsByType(uint256 _claimType) public constant returns(uint256[] claimIds) {
        return claimsByType[_claimType];
    }

    // Function override
    function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId) {
        bytes4 fHash = _data.getFuncHash();
        if (fHash == 0xc78322ae) {
            ClaimRequested(_data);
        }
        return super.execute(_to, _value, _data);
    }
}
