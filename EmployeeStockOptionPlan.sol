// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Importing necessary libraries and contracts
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";



contract EmployeeStockOptionPlan {
    using SafeMath for uint256;     // Using SafeMath library for safe mathematical operations
 
    // Define the necessary data structures and variables

    // Structure to hold information about an employee's granted options    
        struct GrantOption {
        uint256 options;            // Number of options granted
        uint256 vestingPeriod;      // Period over which the options vest
        uint256 cliffPeriod;        // Period after which the options start vesting
        uint256 startTime;          // Time when the vesting starts
        uint256 vestedOptions;      // Number of options that have vested
        bool exercised;             // Flag indicating if the options have been exercised
    }

        address public company;         // Address of the company
        IERC20 public token;            // Contract for the token used for stock options
        uint256 public totalOptions;    // Total number of available options
        uint256 public totalVested;     // Total number of vested options

    mapping(address => GrantOption) public grants;   // Mapping to store grants for each employee

    
    // Implement the necessary events

     // Event emitted when stock options are granted to an employee
    event OptionsGranted(address indexed employee, uint256 options);

     // Event emitted when stock options vest for an employee
    event OptionsVested(address indexed employee, uint256 options);

     // Event emitted when stock options are exercised by an employee
    event OptionsExercised(address indexed employee, uint256 options);

    // Implement the constructor
    constructor(IERC20 _token, uint256 _totalOptions) {
        company = msg.sender;
        token = _token;
        totalOptions = _totalOptions;
    }


    // Implement the functions for granting stock options

    // Function to grant stock options to an employee
    function grantStockOptions(address employee, uint256 options) external onlyCompany {
        require(totalOptions >= options, "Not enough options available for granting");

        totalOptions = totalOptions.sub(options);

        grants[employee] = GrantOption({
            options: options,
            vestingPeriod: 0,
            cliffPeriod: 0,
            startTime: 0,
            vestedOptions: 0,
            exercised: false
        });

        emit OptionsGranted(employee, options);
    }

    
    // Implement the functions for setting the vesting schedule

    // Function to set the vesting schedule for an employee's granted options
    function setVestingSchedule(address employee, uint256 vestingPeriod, uint256 cliffPeriod) external onlyCompany {
        GrantOption storage grant = grants[employee];
        require(grant.options > 0, "No grant found for the employee");
        require(grant.startTime == 0, "Vesting schedule has already been set");

        grant.vestingPeriod = vestingPeriod;
        grant.cliffPeriod = cliffPeriod;
        grant.startTime = block.timestamp;

        emit OptionsVested(employee, 0); // Emit a zero-vesting event to mark the start of the vesting schedule
    }

    
    // Implement the functions for exercising options

     // Function for an employee to exercise their vested options
    function exerciseOptions(uint256 options) external {
        GrantOption storage grant = grants[msg.sender];
        require(grant.options > 0, "No grant found for the employee");
        require(!grant.exercised, "Options have already been exercised");
        require(options > 0, "Number of options must be greater than zero");

        uint256 vestedOptions = calculateVestedOptions(msg.sender).sub(grant.vestedOptions);
        require(options <= vestedOptions, "Not enough vested options");

        grant.exercised = true;
        grant.vestedOptions = grant.vestedOptions.add(options);

        token.transfer(msg.sender, options);

        emit OptionsExercised(msg.sender, options);
    }

    
    // Implement the functions for tracking vested and exercised options

    // Function to calculate the number of vested options for an employee
    function calculateVestedOptions(address employee) public view returns (uint256) {
       GrantOption storage grant = grants[employee];

        if (grant.startTime == 0) {
            return 0; // Vesting schedule not set
        }

        if (block.timestamp < grant.startTime.add(grant.cliffPeriod)) {
            return 0; // Cliff period ongoing, no vested options yet
        }

        if (grant.vestingPeriod == 0) {
            return grant.options; // Vesting period is zero, all options are immediately vested
        }

        uint256 elapsedTime = block.timestamp.sub(grant.startTime).sub(grant.cliffPeriod);
        uint256 totalVestingPeriod = grant.vestingPeriod;

        if (elapsedTime >= totalVestingPeriod) {
            return grant.options; // Fully vested
        }

        uint256 vestedOptions = grant.options.mul(elapsedTime).div(totalVestingPeriod);

        return vestedOptions;
    }

    // Function to manually vest options for an employee
    function vestOptions(address employee) external onlyCompany {
        GrantOption storage grant = grants[employee];
        require(grant.options > 0, "No grant found for the employee");
        require(!grant.exercised, "Options have already been exercised");

        uint256 vestedOptions = calculateVestedOptions(employee).sub(grant.vestedOptions);
        require(vestedOptions > 0, "No vested options available");

        grant.vestedOptions = grant.vestedOptions.add(vestedOptions);
        totalVested = totalVested.add(vestedOptions);

        emit OptionsVested(employee, vestedOptions);
    }

    
    // Implement the necessary modifiers and access control

    // Modifier to restrict access to only the company
        modifier onlyCompany() {
        require(msg.sender == company, "Only the company can call this function");
        _;
    }

    
    // Add any additional functions or modifiers as needed
}
