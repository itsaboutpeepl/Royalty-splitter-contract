pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract TokenPaymentSplitter {
    using SafeERC20 for IERC20;
    
    address internal paymentToken;
    uint256 internal _totalShares;
    uint256 internal _totalTokenReleased;
    address[] internal _payees;
    mapping(address => uint256) internal _shares;
    mapping(address => uint256) internal _totalReleased;

    constructor(
        address[] memory payees,
        uint256[] memory shares_,
        address _paymentToken
    ) {
        /* @notice 
            this makes sure each payee have shares assigned to them
        */
        require(
            payees.length == shares_.length,
            "TokenPaymentSplitter: payees and shares length mismatch"
        );
        
        require(payees.length > 0, "TokenPaymentSplitter: no payees");
        for (uint256 i = 0; i < payees.length; i++) {
            _addPayee(payees[i], shares_[i]);
        }
        paymentToken = _paymentToken;
    }

    function totalShares() public view returns (uint256) {
        return _totalShares;
    }
    function shares(address account) public view returns (uint256) {
        return _shares[account];
    }
    function payee(uint256 index) public view returns (address) {
        return _payees[index];
    }
    function _addPayee(address account, uint256 shares_) internal {
        require(
            account != address(0),
            "TokenPaymentSplitter: account is the zero address"
        );
        require(
            shares_ > 0, "TokenPaymentSplitter: shares are 0"
        );
        require(
            _shares[account] == 0,
            "TokenPaymentSplitter: account already has shares"
        );
        _payees.push(account);
    }
}

