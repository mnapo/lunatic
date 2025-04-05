# lunatic
LLM in lua with tools like database storage handling

At it's core, it works through 3 different parts represented by classes, that can work together when the library is implemented:
* Learner: it does the learning tasks. It digests the information given, and process it in a way that can be stored. It extracts meaningul data from different kind of text sources.
* Speaker: it uses hybrid text processing (autoregressive+autoencoding) to give the most natural and expected answer to the inserted input.
* Middleman: it offers the API to receive external communication.
