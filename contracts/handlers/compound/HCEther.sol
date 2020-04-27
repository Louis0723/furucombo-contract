pragma solidity ^0.5.0;

import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';

import '../HandlerBase.sol';
import './ICEther.sol';


contract HCEther is HandlerBase {
    using SafeERC20 for IERC20;

    address constant CETHER = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;

    function mint(uint256 value) external payable {
        ICEther compound = ICEther(CETHER);
        compound.mint.value(value)();

        // Update involved token
        _updateToken(CETHER);
    }

    function redeem(uint256 redeemTokens) external payable {
        ICEther compound = ICEther(CETHER);
        IERC20(CETHER).safeApprove(CETHER, redeemTokens);
        require(compound.redeem(redeemTokens) == 0, 'compound redeem failed');
        IERC20(CETHER).safeApprove(CETHER, 0);
    }

    function redeemUnderlying(uint256 redeemAmount) external payable {
        ICEther compound = ICEther(CETHER);
        IERC20(CETHER).safeApprove(CETHER, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        require(compound.redeemUnderlying(redeemAmount) == 0, 'compound redeem underlying failed');
        IERC20(CETHER).safeApprove(CETHER, 0);
    }
}
