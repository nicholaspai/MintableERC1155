import "openzeppelin-contracts/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

pragma solidity >=0.8.19;

contract MintableERC1155 is ERC1155PresetMinterPauser {
    
    mapping(uint256 => string) public uris;
    
    event Airdrop(address caller, address[] recipients, uint256 id);

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
     * deploys the contract.
     */
    constructor() ERC1155PresetMinterPauser("") {
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
     */
    function airdrop(
        address[] to,
        uint256 id
    ) public override {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");

        address operator = _msgSender();
        uint256[] memory ids = new uint256[](1);
        ids[0] = id;

        // - mint 1 token of `id` to each address in `to`
        for (uint256 i = 0; i < to.length; i++) {
            _beforeTokenTransfer(operator, from, to[i], [id], [1], "");
            ++_balances[id][to[i]];
            _doSafeTransferAcceptanceCheck(operator, address(0), to[i], id, 1, "");
            emit TransferSingle(operator, address(0), to[i], id, amount);
            _afterTokenTransfer(operator, address(0), to[i], ids, [1], "");
        }
    }    
    
    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function setURI(uint256 id, string memory newuri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uris[id] = newuri;
    }

    /*
    sets our URI and makes the ERC1155 OpenSea compatible
    */
    function uri(uint256 _tokenid) override public view returns (string memory) {
        return uris[id];
    }


}
