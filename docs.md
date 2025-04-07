## main.lua
By now it initializes classes, configures relative paths and does testing work.

## ClassPrototype
Base class for all the rest.
* new: creates instance
* get: retrieves a member's value
* set: gives a value to a member
* remove: destroys the instance

## Unit
Inherits ClassPrototype. It represents Cells
* set: overriden to check if the member being set is activation_function
* calculate_output: multiplies input with weight, adds bias to the result and finally applies the activation_function to the sum of both.

* parent_network_id: the id of the neural network where it's going to work.
* weight: the number that's multiplied with the input
* bias: the number that's added to the result of input * weight