# Changelog

<!--next-version-placeholder-->

## v0.2.0 (2024-02-12)

### Feature

* ✨ Change `CaseResult` to support matches, failed match, and maybe matches ([`577f9a1`](https://github.com/vdvman1/bolt-control-flow/commit/577f9a122e590b587b615283642bc42be7942d37))

### Breaking

* `CaseResult` is now a dataclass instead of a tuple, use the helpers or the constructor to create instances ([`577f9a1`](https://github.com/vdvman1/bolt-control-flow/commit/577f9a122e590b587b615283642bc42be7942d37))

### Documentation

* 📝 Add missing documentation for the types module ([`6702939`](https://github.com/vdvman1/bolt-control-flow/commit/670293966f4d867ebc5cdf5180d50fc0f595cca9))
* 📝 Improve generated API documentation format ([`d822f16`](https://github.com/vdvman1/bolt-control-flow/commit/d822f1630d60c82036310e48caed0d5b2a6d9c8d))
* 📝 Automatically generate API documentation from Python docstrings using Sphinx ([`e7a7c6c`](https://github.com/vdvman1/bolt-control-flow/commit/e7a7c6c58db918513dfef1e0d1679c9a0557725f))

## v0.1.0 (2024-02-02)

### Feature

* ✨ Support overloading the behaviour of `if...else` separately from a lone `if` ([`e189edc`](https://github.com/vdvman1/bolt-control-flow/commit/e189edc0cf654a5ae514f460d48d63e3a038e733))
* ✨ Support overloading of logical `and` and logical `or` ([`a9f6628`](https://github.com/vdvman1/bolt-control-flow/commit/a9f66284c7c5c45da0f87da7bd80af7b36db1344))
