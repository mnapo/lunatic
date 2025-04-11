## module main
By now it initializes classes, configures relative paths and does testing work.

## module helpers/vector
Gives helper functions for vector operations.
* num: dot_product(R_Vector: v1, R_Vector: v2): calculates dot product between v1 and v2 if possible
* R_Vector: vectorial_sum(R_Vector: v1, R_Vector: v2): calculates sum between v1 and v2, returns  
* str: tostring(R_Vector: v): converts v to its string representation [x1; x2; ...]
* R_Vector: create_randomly(num: dimension): creates an R_Vector the size of dimension and populates it with random values
* num: flatten(R_Vector: v): retrieves the first value from v

## module tests/and, tests/or, tests/xor
Tests for perceptron type Units, that compute logical functions based on their inputs.

## module tests/vector_operations
Shows how R_Vector class works (dot product, vectorial sum, tostring).

## class ClassPrototype
Base class for all the rest.
* ClassPrototype: new() -> creates instance
* any: get(str: member) -> retrieves a member's value
* ClassPrototype: set(str: member, any: value) -> gives a new value to a member
* remove() -> destroys the instance

## class Unit
Inherits ClassPrototype.
It represents a Cell in a NeuralNetwork.
* Unit: set(str: member, any: value) -> overriden to check if the member being set is activation_function
* num: calculate_output(R_Vector input) -> multiplies input with weight, adds bias to the result and finally applies the activation_function to the sum of both
* num: parent_network_id -> the id of the neural network where it's going to work.
* R_Vector/num: weight -> scalar or vector that's multiplied with the input
* num: bias -> scalar that's added to the result of input * weight

## class Layer
Inherits ClassPrototype
* Layer: push(Unit u) -> adds u to the end of units
* Layer: pop() -> removes the last unit in units
* R_Vector: get_output(R_Vector: input) -> retrieves a vector where its values are the result of the dot producto between input and the layer's units
* table: units -> units appended to the layer

## class NeuralNetwork
Inherits ClassPrototype
* NeuralNetwork: push(Layer l) -> adds l to the end of layers
* Layer: pop() -> removes the last layer in layers
* num: get_output(R_Vector: input) -> retrieves the scalar that results from the dot product between the last hidden layer and the output one
* table: layers -> layers appended to the network