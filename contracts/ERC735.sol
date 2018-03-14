pragma solidity ^0.4.19;

contract ERC735 {
    event ClaimAdded(uint256 indexed claimId, uint256 indexed claimType, address indexed issuer, bytes signature, bytes32 key, bytes data, string uri);
    event ClaimChanged(uint256 indexed claimId, uint256 indexed claimType, address indexed issuer, bytes signature, bytes32 key, bytes data, string uri);
    event ClaimRemoved(uint256 indexed claimId, uint256 indexed claimType, address indexed issuer, bytes signature, bytes32 key, bytes data, string uri);
    // event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed claimType, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
    event ClaimRequested(bytes data);

    // Stated ERC735 implementation
    //    struct Claim {
    //        uint256 claimType;
    //        uint256 scheme;
    //        address issuer; // msg.sender
    //        bytes signature; // this.address + claimType + data
    //        bytes data;
    //        string uri;
    //    }

    // Suggested ERC735 implementation
    struct Claim {
        uint256 claimType;
        address issuer; // msg.sender
        bytes signature; // actual signature of the data =
        bytes32 key;
        bytes data;
        string uri;
    }

    // Setters
    function addClaim(uint256 _claimType, address _issuer, bytes _signature, bytes32 _claimerKey, bytes _data, string _uri) internal returns (uint256 claimRequestId);
    function changeClaim(uint256 _claimId, uint256 _claimType, address _issuer, bytes _signature, bytes32 _claimerKey, bytes _data, string _uri) internal returns (bool success);
    function removeClaim(uint256 _claimId) internal returns (bool success);
    // Getters
    function getClaim(uint256 _claimId) public view returns (uint256 claimType, address issuer, bytes signature, bytes32 claimerKey, bytes data, string uri);
    function getClaimIdsByType(uint256 _claimType) public view returns (uint256[] claimIds);
}
