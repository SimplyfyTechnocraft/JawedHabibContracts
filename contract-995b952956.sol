// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.28;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable@5.1.0/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/access/Ownable2StepUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable@5.1.0/proxy/utils/UUPSUpgradeable.sol";

// @custom:security-contact SimplyfyTechnocraft
contract JawedHabib is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PausableUpgradeable, Ownable2StepUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() payable {
        _disableInitializers();
    }

    // Declare the Mint event (for custom events only)
    event Mint(address indexed to, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    function initialize(address initialOwner) initializer public {
        __ERC20_init("Jawed Habib", "JH");
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init("Jawed Habib");
        __UUPSUpgradeable_init();

        // Mint initial supply
        uint256 initialSupply = 1e5 * 10 ** decimals();
        _mint(msg.sender, initialSupply);
    }

    function pause() public onlyOwner {
        _pause();  // Inherited event will be triggered automatically
        emit Paused(msg.sender);  // Paused event is inherited from PausableUpgradeable
    }

    function unpause() public onlyOwner {
        _unpause();  // Inherited event will be triggered automatically
        emit Unpaused(msg.sender);  // Unpaused event is inherited from PausableUpgradeable
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit Mint(to, amount);  // Emit the Mint event
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20PausableUpgradeable)
    {
        super._update(from, to, value);
    }

   function withdraw(uint256 amount) public onlyOwner {
    // Use address(this).balance to check the contract's balance
    require(address(this).balance > amount, "Insufficient balance");

    // Transfer the specified amount of ETH to the owner
    payable(owner()).transfer(amount);

    // Emit the Withdraw event
    emit Withdraw(owner(), amount);
}
    // Fallback function to accept ETH
    receive() external payable {}
}
