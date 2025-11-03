// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ProofCloud
 * @notice A decentralized platform that allows users to store, verify, and retrieve
 *         document hashes securely on the blockchain — creating a transparent proof cloud.
 */
contract Project {
    address public admin;
    uint256 public documentCount;

    struct Document {
        uint256 id;
        address uploader;
        string docHash;
        string metadata;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => Document) public documents;

    event DocumentUploaded(uint256 indexed id, address indexed uploader, string docHash, string metadata);
    event DocumentVerified(uint256 indexed id, address indexed verifier);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can verify documents");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Upload a new document hash to the ProofCloud.
     * @param _docHash The hash of the document stored off-chain (e.g., IPFS hash).
     * @param _metadata A short description or metadata related to the document.
     */
    function uploadDocument(string memory _docHash, string memory _metadata) public {
        require(bytes(_docHash).length > 0, "Document hash required");
        require(bytes(_metadata).length > 0, "Metadata required");

        documentCount++;
        documents[documentCount] = Document(
            documentCount,
            msg.sender,
            _docHash,
            _metadata,
            block.timestamp,
            false
        );

        emit DocumentUploaded(documentCount, msg.sender, _docHash, _metadata);
    }

    /**
     * @notice Verify a document (admin only).
     * @param _id The document ID to verify.
     */
    function verifyDocument(uint256 _id) public onlyAdmin {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        Document storage doc = documents[_id];
        require(!doc.verified, "Document already verified");

        doc.verified = true;
        emit DocumentVerified(_id, msg.sender);
    }

    /**
     * @notice Retrieve a document’s details.
     * @param _id The document ID.
     * @return Document details struct.
     */
    function getDocument(uint256 _id) public view returns (Document memory) {
        require(_id > 0 && _id <= documentCount, "Invalid document ID");
        return documents[_id];
    }
}
