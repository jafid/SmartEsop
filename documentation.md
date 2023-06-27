# Employee Stock Option Plan Contract

+ The Employee Stock Option Plan (ESOP) contract manages the granting, vesting, and exercising of stock options for employees of a company. It allows the company to grant stock options to employees, set vesting schedules, exercise options, calculate vested options, vest options for eligible employees, and transfer tokens to recipients. The contract ensures that options are granted and exercised within the specified rules and tracks the total number of available options and vested options. It also prevents reentrant calls.

## Contract Architecture

The ESOP contract is implemented in Solidity, a statically typed programming language for writing smart contracts on the Ethereum blockchain. The contract follows the ERC20 token standard for token transfers and implements additional functionality specific to the management of employee stock options.

The contract consists of the following components:

### Structs
+ **`GrantOption:`** Represents the details of a granted stock option, including the number of options granted, vesting period, cliff period, start block number, vested options, and exercise status.
  
### State Variables
+ **`company:`** Address of the company that owns the ESOP contract. This address is set during contract deployment and remains immutable.
+ **`token:`** ERC20 token contract used for granting options.
+ **`totalOptions:`** Total number of available stock options.
+ **`totalVested:`** Total number of vested stock options.
+ **`employeeList:`** List of addresses of employees who have been granted stock options.
+ **`employeeGrants:`** Mapping of employee addresses to their corresponding GrantOption struct.

### Events
+ **`OptionsGranted:`** Event emitted when stock options are granted to an employee.
+ **`OptionsVested:`** Event emitted when stock options are vested for an employee.
+ **`OptionsExercised:`** Event emitted when stock options are exercised by an employee.
+ **`TokensTransferred:`** Event emitted when tokens are transferred from the ESOP contract to a recipient.

### Modifiers
onlyCompany: Modifier that restricts the execution of a function to the company address.
nonReentrant: Modifier that prevents reentrant calls to functions.

### Functions
constructor: Initializes the ESOP contract by setting the token address, total options, and company address during deployment.
grantStockOptions: Grants stock options to an employee by specifying the employee address and the number of options to grant.
setVestingSchedule: Sets the vesting schedule for an employee by specifying the employee address, vesting period, and cliff period.
exerciseOptions: Allows an employee to exercise vested options by specifying the number of options to exercise.
calculateVestedOptions: Calculates the number of vested options for an employee based on the vesting schedule and current block number.
vestOptions: Vests options for all eligible employees, updating their vested option balances.
transferTokens: Transfers tokens from the ESOP contract to a recipient.

## Design Decisions
+ **`Granting and Vesting:`** The contract allows the company to grant stock options to employees and set vesting schedules. The vesting period represents the duration over which the options will become vested, and the cliff period is the initial period before any options vest. This design ensures that options are gradually vested over time, incentivizing employees to stay with the company.

+ **`Vesting Calculation:`** The calculateVestedOptions function calculates the number of vested options for an employee based on the vesting schedule and the current block number. It takes into account the cliff period and the vesting period to determine the vested options. This calculation ensures that options are vested according to the specified schedule.

+ **`Option Exercise:`** The contract allows employees to exercise their vested options. The exerciseOptions function verifies that the employee has sufficient vested options to exercise and updates their vested option balance accordingly. This design allows employees to benefit from the increase in token value when exercising their options.

+ **`Vesting for Eligible Employees:`** The vestOptions function can be called by the company to vest options for all eligible employees. It iterates over the list of employees and calculates the vested options for each employee. If there are vested options, the function updates the employee's vested option balance and emits an event. This design ensures that employees receive their vested options in a timely manner.

+ **`Token Transfer:`** The contract includes a transferTokens function that allows the company to transfer tokens from the ESOP contract to a recipient. This functionality can be used, for example, to distribute tokens to employees upon exercising their options. The function verifies the recipient address and the availability of token balance before performing the transfer.

## Usage Instructions

### Deployment:
1. Deploy the ESOP contract by providing the address of the ERC20 token contract as a constructor parameter.
The totalOptions variable can be adjusted according to the total number of stock options available for granting.
The address deploying the contract will be set as the company address.

2. **Granting Stock Options:**
Call the grantStockOptions function, providing the address of the employee and the number of options to grant.
Ensure that there are enough options available for granting by checking the totalOptions variable.
The function will deduct the granted options from the totalOptions, create a new GrantOption struct for the employee, and add the employee's address to the employeeList.

3. **Setting Vesting Schedule:**
+ Call the setVestingSchedule function, providing the address of the employee, vesting period, and cliff period.
The vesting period represents the duration (in blocks) over which the options will become vested.
The cliff period represents the initial period (in blocks) before any options vest.
The function will update the GrantOption struct for the employee with the vesting schedule details.

4. **Exercising Options:**
+ Call the exerciseOptions function to exercise vested options.
Provide the number of options to exercise.
The function will verify that the employee has sufficient vested options to exercise and update their vested option balance.

5. **`Vesting Options:`**
+ Call the vestOptions function to vest options for all eligible employees.
The function will iterate over the list of employees and calculate the vested options for each employee.
If there are vested options, the function will update the employee's vested option balance and emit an event.

6. **`Transferring Tokens:`**
+ Call the transferTokens function to transfer tokens from the ESOP contract to a recipient.
Provide the recipient's address and the amount of tokens to transfer.
The function will verify the recipient address and the availability of token balance before performing the transfer.

## Security Considerations
+ **`Access Control:`** The contract includes a onlyCompany modifier that restricts access to certain functions to the company address. Ensure that only the company address is granted access to these functions.

+ **`Immutable Company Address:`** The company address is set during contract deployment and remains immutable thereafter. This prevents unauthorized modification of the company address and ensures the integrity of the contract.

+ **`Input Validation:`** The contract includes various input validations to ensure that addresses are valid, option quantities are within bounds, and vesting schedules are set correctly. These validations help prevent potential errors and misuse of the contract.

+ **`Reentrancy Protection:`** The contract includes a nonReentrant modifier to prevent reentrant calls, which can be exploited to manipulate the contract state. This protects against potential reentrancy attacks.

## Gas and Economy
+ The contract has been designed to minimize gas usage where possible by avoiding unnecessary storage reads and writes.
+ The calculateVestedOptions function calculates vested options based on the vesting schedule and the current block number. It avoids unnecessary calculations if options have already vested or the cliff period has not yet passed.
+ The vestOptions function vests options for eligible employees in a single transaction, minimizing gas costs by updating the vested option balances and emitting events only for employees with vested options.
+ The transferTokens function transfers tokens from the ESOP contract to a recipient, ensuring that the contract has sufficient token balance before performing the transfer. This prevents failed transfers and wasted gas.

## ERC20 Compliance
+ The ESOP contract interacts with an ERC20 token contract, which is a separate contract that implements the ERC20 token standard. The token contract is required to have the following functions:

+ **`totalSupply:`** Returns the total supply of tokens.
+ **`balanceOf:`** Returns the token balance of a given account.
+ **`transfer:`** Transfers tokens from the caller's account to a recipient's account.

- The ESOP contract interacts with the token contract to check the available token balance, transfer tokens to employees upon exercising options, and transfer tokens to recipients using the transferTokens function.

## ERC 20 - contracts/EmployeeStockOptionPlan Code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Employee Stock Option Plan Contract
 * @dev This contract manages the granting, vesting, and exercising of stock options for employees.
 *      It allows the company to grant stock options to employees, set vesting schedules, exercise options,
 *      calculate vested options, vest options for eligible employees, and transfer tokens to recipients.
 *      The contract ensures that options are granted and exercised within the specified rules and tracks
 *      the total number of available options and vested options. It also prevents reentrant calls.
 */
contract EmployeeStockOptionPlan {
    struct GrantOption {
        uint256 options;         // Total number of options granted
        uint256 vestingPeriod;   // Duration of the vesting period (in blocks)
        uint256 cliffPeriod;     // Duration of the cliff period (in blocks)
        uint256 startBlock;      // Block number when the vesting period starts
        uint256 vestedOptions;   // Number of options vested
        bool exercised;          // Flag indicating whether options have been exercised
    }

    address public company;           // Address of the company
    ERC20 public token;               // Token contract used for granting options
    uint256 public totalOptions;      // Total number of available options
    uint256 public totalVested;       // Total number of vested options
    address[] public employeeList;    // List of employees
    mapping(address => GrantOption) public employeeGrants; // Mapping of employee grants

    event OptionsGranted(address indexed employee, uint256 options);
    event OptionsVested(address indexed employee, uint256 options, uint256 vestedOptions);
    event OptionsExercised(address indexed employee, uint256 options);
    event TokensTransferred(address indexed from, address indexed to, uint256 value);

    constructor(address _tokenAddress) {
        token = ERC20(_tokenAddress);
        totalOptions = 1000;
        company = msg.sender;
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

    /**
     * @dev Transfer tokens from the contract to a recipient.
     * @param to The address of the recipient.
     * @param value The amount of tokens to transfer.
     */
    function transferTokens(address to, uint256 value) external onlyCompany {
        require(to != address(0), "Invalid recipient address");
        require(value <= token.balanceOf(address(this)), "Insufficient token balance");

        token.transfer(to, value);

        emit TokensTransferred(address(this), to, value);
    }

    /**
     * @dev Modifier: Only the company can call the function.
     */
    modifier onlyCompany() {
        require(msg.sender == company, "Only the company can call this function");
        _;
    }

    bool private inTransaction;

    /**
     * @dev Modifier: Prevent reentrant calls.
     */
    modifier nonReentrant() {
        require(!inTransaction, "Reentrant call");
        inTransaction = true;
        _;
        inTransaction = false;
    }
}

// ERC20 token contract interface
contract ERC20 {
    mapping(address => uint256) balances;
    uint256 totalSupply_;

    function totalSupply() external view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "Invalid recipient address");
        require(value <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= value;
        balances[to] += value;

        return true;
    }
}
