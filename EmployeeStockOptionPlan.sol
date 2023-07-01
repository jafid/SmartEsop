// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title Employee Stock Option Plan Contract
 * @dev This contract manages the granting, vesting, and exercising of stock options for employees.
 *      It allows the company to grant stock options to employees, set vesting schedules, exercise options,
 *      calculate vested options, vest options for eligible employees, and transfer tokens to recipients.
 *      The contract ensures that options are granted and exercised within the specified rules and tracks
 *      the total number of available options and vested options. It also prevents reentrant calls.
 */
contract EmployeeStockOptionPlan is ERC721 {
    struct GrantOption {
        uint256 options;         // Total number of options granted
        uint256 vestingPeriod;   // Duration of the vesting period (in blocks)
        uint256 cliffPeriod;     // Duration of the cliff period (in blocks)
        uint256 startBlock;      // Block number when the vesting period starts
        uint256 vestedOptions;   // Number of options vested
        bool exercised;          // Flag indicating whether options have been exercised
    }

    address public immutable company;           // Address of the company
    uint256 public totalOptions;      // Total number of available options
    uint256 public totalVested;       // Total number of vested options
    uint256 private totalTokens;      // Total number of ERC721 tokens minted
    address[] public employeeList;    // List of employees
    mapping(address => GrantOption) public employeeGrants; // Mapping of employee grants

    event OptionsGranted(address indexed employee, uint256 options);
    event OptionsVested(address indexed employee, uint256 options, uint256 vestedOptions);
    event OptionsExercised(address indexed employee, uint256 options);

    constructor() ERC721("EmployeeStockOptions", "ESO") {
        totalOptions = 1000;
        company = msg.sender;
        totalTokens = 0;
    }

    /**
     * @dev Grant stock options to an employee.
     * @param employee The address of the employee.
     * @param options The number of options to grant.
     */
    function grantStockOptions(address employee, uint256 options) external onlyCompany {
        require(totalOptions >= options, "Not enough options available for granting");
        require(employee != address(0), "Invalid employee address");

        totalOptions -= options;

        employeeGrants[employee] = GrantOption({
            options: options,
            vestingPeriod: 0,
            cliffPeriod: 0,
            startBlock: 0,
            vestedOptions: 0,
            exercised: false
        });

        employeeList.push(employee);

        uint256 tokenId = totalTokens + 1;
        totalTokens = tokenId;
        _safeMint(employee, tokenId);

        emit OptionsGranted(employee, options);
    }

    /**
     * @dev Set the vesting schedule for an employee.
     * @param employee The address of the employee.
     * @param vestingPeriod The duration of the vesting period (in blocks).
     * @param cliffPeriod The duration of the cliff period (in blocks).
     */
    function setVestingSchedule(address employee, uint256 vestingPeriod, uint256 cliffPeriod) external onlyCompany {
        require(employee != address(0), "Invalid employee address");

        GrantOption storage grant = employeeGrants[employee];
        require(grant.options > 0 && grant.startBlock == 0, "No grant found for the employee or vesting schedule already set");

        grant.vestingPeriod = vestingPeriod;
        grant.cliffPeriod = cliffPeriod;
        grant.startBlock = block.number;

        emit OptionsVested(employee, 0, 0);
    }

    /**
     * @dev Exercise vested options.
     * @param options The number of options to exercise.
     */
    function exerciseOptions(uint256 options) external nonReentrant {
        require(options > 0, "Number of options must be greater than zero");

        GrantOption storage grant = employeeGrants[msg.sender];
        require(grant.options > 0 && !grant.exercised, "No grant found for the employee or options already exercised");

        uint256 vestedOptions = calculateVestedOptions(msg.sender) - grant.vestedOptions;
        require(options <= vestedOptions, "Not enough vested options");

        grant.exercised = true;
        grant.vestedOptions += options;

        emit OptionsExercised(msg.sender, options);
    }

    /**
     * @dev Calculate the number of vested options for an employee.
     * @param employee The address of the employee.
     * @return The number of vested options.
     */
    function calculateVestedOptions(address employee) public view returns (uint256) {
        GrantOption storage grant = employeeGrants[employee];

        if (grant.startBlock == 0 || block.number < grant.startBlock + grant.cliffPeriod) {
            return 0;
        }

        if (grant.vestingPeriod == 0) {
            return grant.options;
        }

        uint256 elapsedTime = block.number - grant.startBlock - grant.cliffPeriod;
        uint256 totalVestingPeriod = grant.vestingPeriod;

        if (elapsedTime >= totalVestingPeriod) {
            return grant.options;
        }

        uint256 vestedOptions = (grant.options * elapsedTime) / totalVestingPeriod;

        return vestedOptions;
    }

    /**
     * @dev Vest options for all eligible employees.
     */
    function vestOptions() external onlyCompany {
        uint256 totalVestedOptions;
        uint256 employeeCount = employeeList.length;

        for (uint256 i = 0; i < employeeCount; i++) {
            address employee = employeeList[i];
            GrantOption storage grant = employeeGrants[employee];

            if (grant.options > 0 && !grant.exercised) {
                uint256 vestedOptions = calculateVestedOptions(employee) - grant.vestedOptions;
                if (vestedOptions > 0) {
                    grant.vestedOptions += vestedOptions;
                    totalVestedOptions += vestedOptions;
                    emit OptionsVested(employee, vestedOptions, grant.vestedOptions);
                }
            }
        }

        totalVested += totalVestedOptions;
    }

    modifier onlyCompany() {
        require(msg.sender == company, "Only the company can call this function");
        _;
    }

    bool private inTransaction;

    modifier nonReentrant() {
        require(!inTransaction, "Reentrant call");
        inTransaction = true;
        _;
        inTransaction = false;
    }
}
