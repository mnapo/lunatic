## module main
By now it initializes classes, configures relative paths and does testing work.

## module helpers/vector
Gives helper functions for vector operations.
* R_Vector dot_product(R_Vector v1, R_Vector v2): calculates dot product between v1 and v2 if possible
* R_Vector vectorial_sum(R_Vector v1, R_Vector v2): calculates sum between v1 and v2, returns  
* R_Vector tostring(R_Vector v): converts v to its string representation [x1; x2; ...]

## module tests/and, tests/or, tests/xor
Tests for perceptron type Units, that compute logical functions based on their inputs.

## module tests/vector_operations
Shows how R_Vector class works (dot product and vectorial sum).

## class ClassPrototype
Base class for all the rest.
Methods:
* new: creates instance
* get: retrieves a member's value
* set: gives a value to a member
* remove: destroys the instance

## class Unit
Inherits ClassPrototype.
It represents a Cell in a NeuralNetwork.
Methods:
* set: overriden to check if the member being set is activation_function
* calculate_output: multiplies input with weight, adds bias to the result and finally applies the activation_function to the sum of both.
Properties:
* parent_network_id: the id of the neural network where it's going to work.
* weight: scalar or vector that's multiplied with the input
* bias: scalar that's added to the result of input * weight