// SPDX-License-Identifier: MIT
pragma solidity >=0.7.2;

import {
    ReentrancyGuardUpgradeable
} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {
    ERC20Upgradeable
} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {IRibbonV2Vault} from "../interfaces/IRibbonVaults.sol";
import {IVaultRegistry} from "../interfaces/IVaultRegistry.sol";

contract OptionsVaultStorageV1 is
    ReentrancyGuardUpgradeable,
    OwnableUpgradeable,
    ERC20Upgradeable
{
    // DEPRECATED: This variable was originally used to store the asset address we are using as collateral
    // But due to gas optimization and upgradeability security concerns,
    // we removed it in favor of using immutable variables
    // This variable is left here to hold the storage slot for upgrades
    address private _oldAsset;

    // Privileged role that is able to select the option terms (strike price, expiry) to short
    address public manager;

    // Option that the vault is shorting in the next cycle
    address public nextOption;

    // The timestamp when the `nextOption` can be used by the vault
    uint256 public nextOptionReadyAt;

    // Option that the vault is currently shorting
    address public currentOption;

    // Amount that is currently locked for selling options
    uint256 public lockedAmount;

    // Cap for total amount deposited into vault
    uint256 public cap;

    // Fee incurred when withdrawing out of the vault, in the units of 10**18
    // where 1 ether = 100%, so 0.005 means 0.5% fee
    uint256 public instantWithdrawalFee;

    // Recipient for withdrawal fees
    address public feeRecipient;
}

contract OptionsVaultStorageV2 {
    // DEPRECATED FOR V2
    // Amount locked for scheduled withdrawals
    uint256 private queuedWithdrawShares;

    // DEPRECATED FOR V2
    // Mapping to store the scheduled withdrawals (address => withdrawAmount)
    mapping(address => uint256) private scheduledWithdrawals;
}

contract OptionsVaultStorageV3 {
    // Contract address of replacement
    IRibbonV2Vault public replacementVault;
}

// We are following Compound's method of upgrading new contract implementations
// When we need to add new storage variables, we create a new version of OptionsVaultStorage
// e.g. OptionsVaultStorageV<versionNumber>, so finally it would look like
// contract OptionsVaultStorage is OptionsVaultStorageV1, OptionsVaultStorageV2
contract OptionsVaultStorage is
    OptionsVaultStorageV1,
    OptionsVaultStorageV2,
    OptionsVaultStorageV3
{

}
