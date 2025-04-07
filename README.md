![Lunatic library logo](https://media-hosting.imagekit.io/2d533594aad043c1/Lunatic-logo-v4.png?Expires=1838676237&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=00O3BubhDtn2ynQA-wF3-J4K7Q8BjvbhUeXm0ytFM56VdbFS~kG-gQ67tzYCdsWAEBxxHR-wGasptTsBjGp1aTZ296C1R9nO7zt9MPOLXNa-B1hidC9suxg5Hc~FJqZB1oNNltPJ7IoBIB4nQjx6iRYy-adFi6eR2F2q0yZ~BwLGovUg0nstmmYvpRh3pRvddFEP6vMynpre9AVEdO-r7OVW6gRc3reardMny4WnPhumn6U0~iYfyczNQJjySjzgzl0XW~EPJGX4urqHG25lgRvIsQIyG~LaSe8xej3vm5YwSgm6ZgoO2lWxKx99GFU2fTKBWyptDUNzSQ8xSff0Og__)
LLM in lua with tools like database storage handling.

At it's core, it works through 3 different parts represented by classes, that can work together when the library is implemented:
* Learner: it does the learning tasks. It digests the information given, and process it in a way that can be stored. It extracts meaningul data from different kind of text sources.
* Speaker: it uses hybrid text processing (autoregressive+autoencoding) to give the most natural and expected answer to the inserted input.
* Middleman: it offers the API to receive external communication.

## Bibliography
* Speech and Language Processing (J. Daniel & M. James H.) 3rd ed. (2025)
