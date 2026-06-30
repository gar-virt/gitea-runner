# Steffen's Customized Gitea Runner

This is a recipe for building the official Gitea Runner for multiple platforms, with patches that allow additional use cases.

## Changes

- Added a `run-task` command for running a single given task, allowing e.g. a controller to delegate tasks received from a Gitea instance.

## Building

Prerequisites:
- Linux
- Docker
- Make

Build the project with the `make` command, then find the artifacts in `./upstream/source/dist/release`.

## License

This recipe and any original code is licensed under the terms in the `LICENSE` file.

Patch files follow patched projects' established pattern for embedding notices.
