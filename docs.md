# Directory Structure (.)
Up to date lua community doesn't have conventional directory structure, so it may vary from a project to another. This library is intended to be embedded in different kind of works, and namespace pollution is something we must avoid. To reduce coding time in development environment, we take no mesure to do it.
As we use really common names, you would like to take a little time to understand how the whole library is required.

    - the only module that needs to be required is main.lua, so you would do something alike: `lunatic = require("lunatic.main")`, depending on your package.path
    - main.lua implements addRelPath(), which registers every lunatic's directory in package.path
    - registering a directory here means that any .lua file inside it can be required without specifying it's path. So for example "./src/helpers/neural_network.lua" is required in "./src/cls/NeuralNetwork" this way: `local vector = require("vector")`

So if you don't work this way, in order to embedded lunatic, you can proceed in two ways:
    - either you remove `addRelPath()` and every call to it to register lunatic's directories, and then modify the `require()` calls in every module
    - or you can make your code compatible with our directory structure, by moving main.lua to your app's root, registering your directories and lunatic's, and avoiding using the same names.

We hope normalizing this in the future so you can import the library without boilerplate. By now we think it's good practice to don't mention paths in require() because they can be changed frequently in this phase.

# Modules (./src)

## main
By now it initializes classes, configures relative paths and does testing work

## src/helpers/

### neural_network
Activation functions (sigmoid, tanh, relu, perceptron)

### test_dispatcher
Runner functions to be used in /tests modules

### vector
Gives helper functions for vector operations
* num: dot_product(R_Vector: v1, R_Vector: v2) -> calculates dot product between v1 and v2 if possible
* R_Vector: vectorial_sum(R_Vector: v1, R_Vector: v2) -> calculates sum between v1 and v2, returns  
* str: tostring(R_Vector: v) -> converts v to its string representation [x1; x2; ...]
* R_Vector: create_randomly(num: dimension) -> creates an R_Vector the size of dimension and populates it with random values
* num: flatten(R_Vector: v) -> retrieves the first value from v
* R_Vector: softmax(R_Vector: v) -> retrieves a softmaxed version of v

### token
Gives helper functions for Vocabulary generation

### file
Gives helper functions for file reading


# Classes (./src/cls/)
### ClassPrototype
Base class for all the rest
* ClassPrototype: new() -> creates instance
* any: get(str: member) -> retrieves a member's value
* ClassPrototype: set(str: member, any: value) -> gives a new value to a member
* remove() -> destroys the instance

### Unit
Inherits ClassPrototype
It represents a Cell in a NeuralNetwork
* Unit: set(str: member, any: value) -> overriden to check if the member being set is activation_function
* num: calculate_output(R_Vector input) -> multiplies input with weight, adds bias to the result and finally applies the activation_function to the sum of both
* num: parent_network_id -> the id of the neural network where it's going to work.
* R_Vector/num: weight -> scalar or vector that's multiplied with the input
* num: bias -> scalar that's added to the result of input * weight

### Layer
Inherits ClassPrototype
* Layer: push(Unit u) -> adds u to the end of units
* Layer: pop() -> removes the last unit in units
* R_Vector: get_output(R_Vector: input) -> retrieves a vector where its values are the result of the dot producto between input and the layer's units
* table: units -> units appended to the layer

### NeuralNetwork
Inherits ClassPrototype
* NeuralNetwork: push(Layer l) -> adds l to the end of layers
* Layer: pop() -> removes the last layer in layers
* num: get_output(R_Vector: input) -> retrieves the scalar that results from the dot product between the last hidden layer and the output one
* table: layers -> layers appended to the network

### Document
Inherits ClassPrototype

### DocumentProperty
Inherits ClassPrototype

### Vocabulary
Inherits ClassPrototype


## Tests (./tests/)
### and, or
Tests for perceptron type Units, that compute logical functions based on their inputs

### xor
Uses a neural network which units have predefined weights and biases to compute XOR logical function

### vector_operations
Shows how R_Vector class works (dot product, vectorial sum, tostring)

### document_parsing
Tests inducing vocabularies from sample documents 