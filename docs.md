## module main
By now it initializes classes, configures relative paths and does testing work.

## module helpers/vector
Gives helper functions for vector operations.
* number: dot_product(R_Vector: v1, R_Vector: v2): calculates dot product between v1 and v2 if possible
* R_Vector: vectorial_sum(R_Vector: v1, R_Vector: v2): calculates sum between v1 and v2, returns  
* R_Vector: tostring(R_Vector: v): converts v to its string representation [x1; x2; ...]
* R_Vector: create_randomly(number: dimension): creates an R_Vector the size of dimension and populates it with random values

## module tests/and, tests/or, tests/xor
Tests for perceptron type Units, that compute logical functions based on their inputs.

## module tests/vector_operations
Shows how R_Vector class works (dot product, vectorial sum, tostring).

## class ClassPrototype
Base class for all the rest.
* ClassPrototype: new() -> creates instance
* any: get(string: member) -> retrieves a member's value
* ClassPrototype: set(string: member, any: value) -> gives a new value to a member
* remove() -> destroys the instance

## class Unit
Inherits ClassPrototype.
It represents a Cell in a NeuralNetwork.
* Unit: set(string: member, any: value) -> overriden to check if the member being set is activation_function
* number: calculate_output(R_Vector input) -> multiplies input with weight, adds bias to the result and finally applies the activation_function to the sum of both
* number: parent_network_id -> the id of the neural network where it's going to work.
* R_Vector/number: weight -> scalar or vector that's multiplied with the input
* number: bias -> scalar that's added to the result of input * weight