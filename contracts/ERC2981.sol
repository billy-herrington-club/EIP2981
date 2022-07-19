//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.15;

import "./IERC2981.sol";

abstract contract ERC2981 is IERC2981 {
    struct TokenRoyalty {
        address receiver;
        uint256 royaltyPercent;
    }

    mapping(uint256 => TokenRoyalty) royalties;

    error ReceiverZeroAddress();
    error RoyaltyPercentNull();

    function addRoyalty(
        uint256 _tokenId,
        address _receiver,
        uint256 _royaltyPercent
    ) internal {
        if (_receiver != address(0)) {
            revert ReceiverZeroAddress();
        }
        if(_royaltyPercent == 0) {
            revert RoyaltyPercentNull();
        }
        royalties[_tokenId] = TokenRoyalty(_receiver, _royaltyPercent);
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyPercent)
    {
        TokenRoyalty memory royalty = royalties[_tokenId];
        receiver = royalty.receiver;
        royaltyPercent = (_salePrice / 1000) * royalty.royaltyPercent;
    }
}
