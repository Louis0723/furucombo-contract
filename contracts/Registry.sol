pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @notice The handler registry database for Furucombo
contract Registry is Ownable {
    mapping(address => bytes32) public handlers;
    mapping(address => bytes32) public callers;
    bool public fHalt;

    bytes32 public constant DEPRECATED = bytes10(0x64657072656361746564);

    modifier isNotHalted() {
        require(fHalt == false, "Halted");
        _;
    }

    modifier isHalted() {
        require(fHalt, "Not halted");
        _;
    }

    /**
     * @notice Register a handler with a bytes32 information.
     * @param registration Handler address.
     * @param info Info string.
     */
    function register(address registration, bytes32 info) external onlyOwner {
        require(registration != address(0), "zero address");
        require(handlers[registration] != DEPRECATED, "unregistered");
        handlers[registration] = info;
    }

    /**
     * @notice Unregister a handler. The handler will be deprecated.
     * @param registration The handler to be unregistered.
     */
    function unregister(address registration) external onlyOwner {
        require(registration != address(0), "zero address");
        require(handlers[registration] != bytes32(0), "no registration");
        require(handlers[registration] != DEPRECATED, "unregistered");
        handlers[registration] = DEPRECATED;
    }

    /**
     * @notice Register a caller with a bytes32 information.
     * @param registration Caller address.
     * @param info Info string.
     * @dev Dapps that triggers callback function should be registered.
     * In this case, registration is the Dapp address and the leading 20 bytes
     * of info is the handler address.
     */
    function registerCaller(address registration, bytes32 info)
        external
        onlyOwner
    {
        require(registration != address(0), "zero address");
        require(callers[registration] != DEPRECATED, "unregistered");
        callers[registration] = info;
    }

    /**
     * @notice Unregister a caller. The caller will be deprecated.
     * @param registration The caller to be unregistered.
     */
    function unregisterCaller(address registration) external onlyOwner {
        require(registration != address(0), "zero address");
        require(callers[registration] != bytes32(0), "no registration");
        require(callers[registration] != DEPRECATED, "unregistered");
        callers[registration] = DEPRECATED;
    }

    /**
     * @notice Check if the handler is valid.
     * @param handler The handler to be verified.
     */
    function isValid(address handler)
        external
        view
        isNotHalted
        returns (bool result)
    {
        if (handlers[handler] == 0 || handlers[handler] == DEPRECATED)
            return false;
        else return true;
    }

    /**
     * @notice Check if the handler is valid.
     * @param caller The caller to be verified.
     */
    function isValidCaller(address caller)
        external
        view
        isNotHalted
        returns (bool result)
    {
        if (callers[caller] == 0 || callers[caller] == DEPRECATED) return false;
        else return true;
    }

    function halt() external isNotHalted onlyOwner {
        fHalt = true;
    }

    function unhalt() external isHalted onlyOwner {
        fHalt = false;
    }
}
