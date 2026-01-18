# CHANGELOG


## v0.4.0 (2026-01-18)

### Chores

- Add condition to semantic release
  ([`7de8603`](https://github.com/vdvman1/bolt-control-flow/commit/7de86034281bd65ffaaaf8f1c2e2e129f33104bc))

- Fix ci
  ([`673eef1`](https://github.com/vdvman1/bolt-control-flow/commit/673eef19f47f9b076a49da0135cbcc8c2144fdee))

- Fix ci
  ([`44fe718`](https://github.com/vdvman1/bolt-control-flow/commit/44fe71816d5d5a5faf1f9e980e6e91cdc36ea6a1))

- Fix doc build
  ([`5bf0981`](https://github.com/vdvman1/bolt-control-flow/commit/5bf09810d455cf31d5e20d81bfd9ef69dd7cd17e))

- Fix poetry ref
  ([`33e5dfb`](https://github.com/vdvman1/bolt-control-flow/commit/33e5dfb78b6fec3666a2236c111980423227ef79))

### Features

- Update to 3.14, uv, beet/bolt
  ([`4654335`](https://github.com/vdvman1/bolt-control-flow/commit/4654335f465d1b0f70e5fc8dee9308a905af8de2))

- Update to 3.14, uv, etc
  ([`1bf64fc`](https://github.com/vdvman1/bolt-control-flow/commit/1bf64fc7da099c392216c06dcc34a894928724ad))


## v0.3.0 (2024-02-23)

### Bug Fixes

- ♻️ Move testing helpers into a separate plugin to avoid adding them to all projects
  ([`edebd37`](https://github.com/vdvman1/bolt-control-flow/commit/edebd37e91f26da20f62141668b456b9bd4d9585))

BREAKING CHANGE: Must now require `bolt_control_flow.testing` to get access to the testing helpers

- ⬆️ Fix codegen in Bolt v0.47.0
  ([`52c0a3c`](https://github.com/vdvman1/bolt-control-flow/commit/52c0a3c95e41ada2a999d07a7bd14225c2c2eb11))

BREAKING CHANGE: Minimum Bolt version is now v0.47.0

### Breaking Changes

- Minimum Bolt version is now v0.47.0


## v0.2.0 (2024-02-12)

### Build System

- 🔧 Point pip doc and homepage URLs to the new documentation site
  ([`387c725`](https://github.com/vdvman1/bolt-control-flow/commit/387c7254cf58f14e287b57920485b9f149cf74a3))

### Documentation

- 📝 Add missing documentation for the types module
  ([`6702939`](https://github.com/vdvman1/bolt-control-flow/commit/670293966f4d867ebc5cdf5180d50fc0f595cca9))

Also add warnings in the documentation of internal modules and classes

- 📝 Automatically generate API documentation from Python docstrings using Sphinx
  ([`e7a7c6c`](https://github.com/vdvman1/bolt-control-flow/commit/e7a7c6c58db918513dfef1e0d1679c9a0557725f))

To build the docs, make sure to install the project with `poetry install --with docs`

- 📝 Improve generated API documentation format
  ([`d822f16`](https://github.com/vdvman1/bolt-control-flow/commit/d822f1630d60c82036310e48caed0d5b2a6d9c8d))

### Features

- ✨ Change `CaseResult` to support matches, failed match, and maybe matches
  ([`577f9a1`](https://github.com/vdvman1/bolt-control-flow/commit/577f9a122e590b587b615283642bc42be7942d37))

Matches is a match that is known to pass at build time, failed is a match that is known to fail at
  build time, and maybe is a match that isn't known until runtime

BREAKING CHANGE: `CaseResult` is now a dataclass instead of a tuple, use the helpers or the
  constructor to create instances

### Breaking Changes

- `caseresult` is now a dataclass instead of a tuple, use the helpers or the constructor to create
  instances


## v0.1.0 (2024-02-02)

### Build System

- ⬆️ Update minimum Bolt version
  ([`bff6559`](https://github.com/vdvman1/bolt-control-flow/commit/bff655950e98d649a7ab96d1baaac83c4f087050))

This library reimplements the new location of `__not__` for the fallback `else` implementation, so
  it may break libraries that require the old location As such, this library requires versions of
  Bolt that implement the new location

### Chores

- Setup project from template
  ([`d94cce6`](https://github.com/vdvman1/bolt-control-flow/commit/d94cce61beaa648042430ec8b84e06fdf8b83cb9))

### Continuous Integration

- 👷 Enable publishing to PyPI
  ([`7c5ff05`](https://github.com/vdvman1/bolt-control-flow/commit/7c5ff052ebfe9bc61fd3fc085da69ce7c247864e))

### Features

- ✨ Support overloading of logical `and` and logical `or`
  ([`a9f6628`](https://github.com/vdvman1/bolt-control-flow/commit/a9f66284c7c5c45da0f87da7bd80af7b36db1344))

Use `__logical_and__` to overload the behaviour of logical `and`, and use `__logical_or__` to
  overload the behaviour of logical `or` `__rlogical_and__` and `__rlogical_or__` will also be
  called if the left value implements the matching dunder but doesn't know how to handle the right
  value, so that the right value can extend the behaviour of the left value

- ✨ Support overloading the behaviour of `if...else` separately from a lone `if`
  ([`e189edc`](https://github.com/vdvman1/bolt-control-flow/commit/e189edc0cf654a5ae514f460d48d63e3a038e733))

Implement `__multibranch__` to wrap the entire `if...else`, yielding a value that implements
  `__case__` to handle the `if` (true) and the `else` (false) cases.

The design is also prepared for implementing `match` in a future version

### Testing

- ✅ Add tests of the original Bolt conditional behaviour to ensure the library doesn't break
  anything
  ([`c3083c2`](https://github.com/vdvman1/bolt-control-flow/commit/c3083c2fe7fbf8e5243ac0529f5914a95c3ab419))

- 🔥 Remove basic example from the bolt-library-starter
  ([`b57a12d`](https://github.com/vdvman1/bolt-control-flow/commit/b57a12dcf942f7a8bdc35abcf9a2fd48634cc527))
