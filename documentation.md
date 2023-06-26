# EmployeeStockOptionPlan Smart Contract Documentation

## Overview
The EmployeeStockOptionPlan smart contract is designed to manage employee stock option plans. 
It allows a company to grant stock options to its employees, set a vesting schedule for the options, and track the vesting and exercise of options. 
The contract is implemented in Solidity, compatible with version 0.8.0 and above.

## Design Decisions
1. **SafeMath Library:** The contract uses the SafeMath library for performing safe mathematical operations to prevent overflow and underflow vulnerabilities.

2. **GrantOption Struct:** The GrantOption struct is used to store information about an employee's granted options.
   It includes fields for the number of options granted, vesting period, cliff period, start time, vested options, and an exercised flag.

3. **Events:** The contract emits three events: OptionsGranted, OptionsVested, and OptionsExercised.
   These events provide a way to track and observe the granting, vesting, and exercise of options.

## Contract Architecture
The contract consists of the following components:

1. **Data Structures and Variables:**

+ **`company`**: Address of the company deploying the contract.
+ **`token`**: Contract for the token used for stock options.
+ **`totalOptions`**: Total number of available options.
+ **`totalVested`**: Total number of vested options.
+ **`grants`**: Mapping to store grant information for each employee.

2. **Events:**
+ **`OptionsGranted`**: Event emitted when stock options are granted to an employee.
+ **`OptionsVested`**: Event emitted when stock options vest for an employee.
+ **`OptionsExercised`**: Event emitted when stock options are exercised by an employee.

3. **Modifiers and Access Control:**
+ **`onlyCompany`**: Modifier to restrict access to only the company.

4. **Constructor**:
+ `constructor`: Initializes the contract by setting the company address and the token contract, and specifying the total number of options.

5. **`Granting Stock Options`:**
+ **grantStockOptions:** Function to grant stock options to an employee. 
- It checks if there are enough options available and updates the total options count. 
- It also stores the grant information for the employee and emits the OptionsGranted event.

6. **Setting the Vesting Schedule:**
+ **`setVestingSchedule`**: Function to set the vesting schedule for an employee's granted options.
+ It checks if the grant exists and if the vesting schedule has already been set.
+ It updates the grant information with the vesting period, cliff period, and start time.
+ It emits a zero-vesting OptionsVested event to mark the start of the vesting schedule.

7. ***Exercising Options:***
+ **`exerciseOptions`**: Function for an employee to exercise their vested options. It checks if the grant exists,
+ if the options have not been exercised, and if the number of options to exercise is greater than zero.
+ It calculates the number of vested options and transfers the tokens to the employee.
+ It updates the grant information and emits the OptionsExercised event.

8. **Tracking Vested and Exercised Options:**
+ **`calculateVestedOptions`**: Function to calculate the number of vested options for an employee based on the vesting schedule.It returns the vested options count.
+ **`vestOptions`**: Function to manually vest options for an employee. It checks if the grant exists, if the options have not been exercised, and if there are vested options available. It updates the grant information and the total vested count. It emits the OptionsVested event.

## Usage Instructions

1. **Compile and Deploy:**
+ The smart contract can be compiled, run, and deployed on Remix Ethereum IDE JavaScript VM.
  This ensures that the contract is tested in a simulated Ethereum environment before being deployed to the actual network.

2. **Grant Stock Options:**
+ The company can grant stock options to an employee by calling the grantStockOptions function and specifying the employee's address and the number of options.
  The contract checks if enough options are available and updates the total options count accordingly.

3. **Set Vesting Schedule:**
+ After granting options, the company can set a vesting schedule for the employee by calling the setVestingSchedule function.
  The vesting period and cliff period (a period after which the options start vesting) are specified.
  The contract ensures that the vesting schedule has not already been set and updates the grant information.

4. **Exercise Options:**
+ Once options have vested, an employee can exercise their vested options by calling the exerciseOptions function and specifying the number of options to exercise.
+ The contract verifies that the employee has enough vested options and transfers the corresponding tokens to the employee's address.

5. **Track Vested and Exercised Options:**
+ The contract automatically tracks the number of vested and exercised options for each employee.
  The calculateVestedOptions function allows anyone to check the number of vested options for a specific employee.

6. **Security and Safety:**
+ The contract uses the SafeMath library to prevent common mathematical errors and vulnerabilities in smart contracts.

+ **Code Comments**
The smart contract code includes inline comments to improve code readability and maintainability. 
The comments provide explanations for the purpose of functions, modifiers, variables, and important steps in the contract logic. 
These comments serve as a guide for developers to understand and modify the contract as needed.
