# Employee Stock Option Plan

+ This smart contract allows a company to grant stock options to its employees and manage the vesting and exercising of those options. It ensures transparency and automates the process, providing a secure and efficient way to handle employee stock options.

## Features

* Granting Stock Options: The company can grant a specific number of stock options to an employee.
* Setting Vesting Schedule: The company can set a vesting schedule for the granted options, specifying the period over which the options will vest.
* Exercising Options: Once options have vested, an employee can exercise their vested options and receive the corresponding tokens.
* Tracking Vested and Exercised Options: The contract keeps track of the vested and exercised options for each employee.
* SafeMath Library: The contract uses the SafeMath library to prevent mathematical errors and vulnerabilities.

## How to Use

1. Compile and Deploy:
+ The smart contract can be compiled, run, and deployed on Remix Ethereum IDE JavaScript VM.
+ This ensures that the contract is tested in a simulated Ethereum environment before being deployed to the actual network.

2. Grant Stock Options:
+ The company can grant stock options to an employee by calling the grantStockOptions function and specifying the employee's address and the number of options.
+ The contract checks if enough options are available and updates the total options count accordingly.

3. Set Vesting Schedule:
+ After granting options, the company can set a vesting schedule for the employee by calling the setVestingSchedule function.
+ The vesting period and cliff period (a period after which the options start vesting) are specified.
+ The contract ensures that the vesting schedule has not already been set and updates the grant information.

4. Exercise Options:
+ Once options have vested, an employee can exercise their vested options by calling the exerciseOptions function and specifying the number of options to exercise.
+ The contract verifies that the employee has enough vested options and transfers the corresponding tokens to the employee's address.

5. Track Vested and Exercised Options:
+ The contract automatically tracks the number of vested and exercised options for each employee.
+ The calculateVestedOptions function allows anyone to check the number of vested options for a specific employee.

6. Security and Safety:
+ The contract uses the SafeMath library to prevent common mathematical errors and vulnerabilities in smart contracts.


## Additional Information

- The smart contract source code is available on GitHub.
- The contract has been compiled, run, and deployed on Remix Ethereum IDE - - - JavaScript VM to ensure its functionality and compatibility.

Please note that this layman documentation provides a simplified overview of the smart contract. For detailed technical information and a deeper understanding of the contract's functionalities, it is recommended to review the contract's source code and documentation.
