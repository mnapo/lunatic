<img src="https://media-hosting.imagekit.io/aa314951557d42df/Lunatic-logo-v5.png?Expires=1838676681&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=I~YpFx92zWoRjnafSU0905HlBistP-48yCRTR38RglBw~vRMgfzyg8CdJSRRR9bJTu~mo71mpsvHC4JzDgqZfGC9X38mgNJM6nn7V94DLPz-PcbUOHiTkREe2unnmADkqQu8Oj23VjylGV8IrFwe0kOKTQJePMLG7gqhrphBRsEsMBqXHx33Y1-s0OpCbkXKkaYYMmZXWObJkivtQdBZAUlO6MlfLHx4PphgtGEEB7ahFvJRnArRfq6S4HRV1RlSl5fpS335ctHvzi4YfC72uqxlqmNQIrwIjq7dMEtsTWoNTgnSnZutazk6QVd6TtEZQRB4PJfXNRv1RPKRkMqkOw__" align="right" width="174px" height="144px" alt="Lunatic library logo" />
LLM in Lua with tools like database storage handling.

At it's core, it works through 3 different parts represented by classes, that can work together when the library is implemented:
* **Learner:** it does the learning tasks. It digests the information given, and process it in a way that can be stored. It extracts meaningul data from different kind of text sources.
* **Speaker:** it uses hybrid text processing (autoregressive+autoencoding) to give the most natural and expected answer to the inserted input.
* **Communicator:** it offers the API to receive external communication.

## Installation
By now you can require "lunatic/main".
See "Directory Structure" to check importing specifications.

## Testing
In order to run a test, you can register it with ```tests.register(name)```, being ```name``` an string with the name of these unit tests:
```
vectorial
network
documents
```

## Acknowledgments
* Speech and Language Processing (J. Daniel & M. James H.) 3rd ed. (2025)
