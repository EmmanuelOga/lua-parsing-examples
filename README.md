Four small lua programs showcasing hand made, left-to-right, leftmost
derivation (LL(k)) parsers.

* ll1: ll(1) parser (1 token lookahead)
* llk: ll(k) parser (k tokens of lookahead, in this case k = 2)
* llbacktrack: arbirtrary lookahead parser with backtracking.
* llbt-memoize: arbirtrary lookahead parser with backtracking and
  memoization (packrat like).

The examples are based off the first chapters of LIP
(http://pragprog.com/book/tpdsl/language-implementation-patterns),
a seriously recommended reading!
