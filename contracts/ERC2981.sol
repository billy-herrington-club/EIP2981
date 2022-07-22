//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.15;

import "./IERC2981.sol";

///@title An implementation of ERC2981

abstract contract ERC2981 is IERC2981 {
    struct TokenRoyalty {
        //Address who will receive the royalty
        address receiver;
        //Royalty percentage (1 = 0.1%)
        uint256 royaltyPercent;
    }

    mapping(uint256 => TokenRoyalty) royalties;

    //Cannot set zero address as a reciever
    error ReceiverZeroAddress();
    //Cannot set royalty to zero
    error RoyaltyPercentNull();

    ///@notice Adds a royalty for a certain NFT 
    ///@param _tokenId - token that contains royalty
    ///@param _receiver - address that will receive royalty
    ///@param _royaltyPercent - percentage of transaction price
    ///deducted as royalty
    function _addRoyalty(
        uint256 _tokenId,
        address _receiver,
        uint256 _royaltyPercent
    ) internal {
        if (_receiver == address(0)) {
            revert ReceiverZeroAddress();
        }
        if(_royaltyPercent == 0) {
            revert RoyaltyPercentNull();
        }
        royalties[_tokenId] = TokenRoyalty(_receiver, _royaltyPercent);
    }

    ///@notice Returns amount of royalty and who will receive it
    ///@param _tokenId - NFT token to be sold
    ///@param _salePrice - sale value of _tokenId 
    ///@return receiver - address that receives the royalty
    ///@return royaltyAmount - royalty payment amount
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        TokenRoyalty memory royalty = royalties[_tokenId];
        receiver = royalty.receiver;
        royaltyAmount = (_salePrice / 1000) * royalty.royaltyPercent;
    }
}
