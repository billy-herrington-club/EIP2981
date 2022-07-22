//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC2981.sol";

contract BHNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, ERC2981 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    uint8 constant MAX_SUPPLY = 228;

    constructor() ERC721("Billy Herrington NFT", "BHNFT") {}

    ///@notice Mints an NFT with a royalty
    ///@param to - adress to which the token is minted
    ///@param uri - uri to metadata
    ///@param royaltyReciever - address that will receiver royalty
    ///@param royaltyPercent - percentage that will be deducted from a trade
    function safeMint(
        address to,
        string memory uri,
        address royaltyReciever,
        uint256 royaltyPercent
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId + 1 < MAX_SUPPLY, "Boysia 228 esli pudrish nosik");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _addRoyalty(tokenId, royaltyReciever, royaltyPercent);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId ||
         super.supportsInterface(interfaceId);
    }
}
