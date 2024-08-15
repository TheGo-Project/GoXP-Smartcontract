// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract GoXP is Initializable, ERC20Upgradeable, OwnableUpgradeable, AccessControlUpgradeable, PausableUpgradeable, UUPSUpgradeable {
	uint256 private constant INITIAL_SUPPLY = 888_000_000 * 10**18;

	bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
	bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

	/**
	 * @dev Initializes the contract, setting the deployer as the initial owner, and assigning all roles to the deployer.
	 * This function can only be called once.
	 */
	function initialize() public initializer {
		__ERC20_init("GoXP", "GoXP");
		__Ownable_init(msg.sender);
		__AccessControl_init();
		__Pausable_init();
		__UUPSUpgradeable_init();

		_mint(msg.sender, INITIAL_SUPPLY);

		// Grant the contract deployer the default admin role
		_grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

		// Grant roles to the deployer
		_grantRole(PAUSER_ROLE, msg.sender);
		_grantRole(MINTER_ROLE, msg.sender);
		_grantRole(BURNER_ROLE, msg.sender);
		_grantRole(UPGRADER_ROLE, msg.sender);
	}

	/**
	 * @dev Pause the contract, preventing all token transfers.
	 * Only accounts with the PAUSER_ROLE can call this function.
	 */
	function pause() public onlyRole(PAUSER_ROLE) {
		_pause();
	}

	/**
	 * @dev Unpause the contract, allowing token transfers.
	 * Only accounts with the PAUSER_ROLE can call this function.
	 */
	function unpause() public onlyRole(PAUSER_ROLE) {
		_unpause();
	}

	/**
	 * @dev Mint new tokens to a specified address.
	 * Only accounts with the MINTER_ROLE can call this function.
	 * @param to The address that will receive the minted tokens.
	 * @param amount The amount of tokens to mint.
	 */
	function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
		_mint(to, amount);
		emit Mint(to, amount);  // Emit an event for better traceability
	}

	/**
	 * @dev Burn tokens from a specified address.
	 * Only accounts with the BURNER_ROLE can call this function.
	 * @param from The address from which the tokens will be burned.
	 * @param amount The amount of tokens to burn.
	 */
	function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
		_burn(from, amount);
		emit Burn(from, amount);  // Emit an event for better traceability
	}

	/**
	 * @dev Authorize the upgrade to a new implementation of the contract.
	 * Only accounts with the UPGRADER_ROLE can call this function.
	 * @param newImplementation The address of the new implementation contract.
	 */
	function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

	// Events for better traceability of minting and burning actions
	event Mint(address indexed to, uint256 amount);
	event Burn(address indexed from, uint256 amount);
}
