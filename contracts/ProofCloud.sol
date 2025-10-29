// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ProofCloud
 * @dev A decentralized proof-of-storage system to register and verify file hashes on the blockchain.
 */
contract ProofCloud {
    struct FileRecord {
        address owner;
        uint256 timestamp;
    }

    mapping(bytes32 => FileRecord) private fileRecords;

    event FileUploaded(address indexed user, bytes32 indexed fileHash, uint256 timestamp);
    event FileVerified(address indexed user, bytes32 indexed fileHash, bool exists);

    /**
     * @dev Upload a file hash to the blockchain as proof of ownership.
     */
    function uploadFile(bytes32 fileHash) external {
        require(fileHash != bytes32(0), "Invalid file hash");
        require(fileRecords[fileHash].owner == address(0), "File already exists");

        fileRecords[fileHash] = FileRecord({
            owner: msg.sender,
            timestamp: block.timestamp
        });

        emit FileUploaded(msg.sender, fileHash, block.timestamp);
    }

    /**
     * @dev Verify if a file hash exists and return ownership details.
     */
    function verifyFile(bytes32 fileHash) external view returns (address owner, uint256 timestamp) {
        FileRecord memory record = fileRecords[fileHash];
        require(record.owner != address(0), "File not found");
        return (record.owner, record.timestamp);
    }

    /**
     * @dev Check if a given hash is registered.
     */
    function isFileRegistered(bytes32 fileHash) external view returns (bool) {
        return fileRecords[fileHash].owner != address(0);
    }
}
// 
update
// 
