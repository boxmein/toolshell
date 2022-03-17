# woot

Z-Shell based domain specific language for tooling, scripting, workflows etc.

Helps you write shell scripts that help users run common tasks in your project,
without figuring out the tools, build systems, scripts, run commands etc
involved.

Skip to:

- [Install](#install)
- [Examples](#examples)
- [Documentation](#documentation)
- [Project governance](#governance)

## As a project user

You don't need to install anything, simply invoking `./x --help` will show you
how to do things in the project.

## As a project contributor

Use this as a front-end for your various build tools, scripts and other tooling
you have built up. Your stack remains, and there's no real DSL.

Since it's all a shell script, you can generate scripts in a loop.

### Installation

<a name="install" id="install"></a>

Download the woot script from this repo into your own repo:

```shell
wget -o ./woot.inc https://raw.githubusercontent.com/boxmein/woot/master/woot
```

Author a build script: [see examples](#examples)

```shell
cat <<EOF > x
#!/bin/zsh
set -e
PROJECT_NAME=myproject
. ./woot.inc 

start with yarn start
EOF
```

Make it executable and add it to your repo:

```shell
chmod +x ./x
git add ./x
git commit -m "frontend for tooling"
```

## Examples

<a name="examples" id="examples"></a>

<details><summary>Python 3</summary>

```shell
#!/bin/zsh
set -e
TOOL_NAME=./x
PROJECT_NAME=mitmproxy-scripts
. ./woot.inc # change this to the right import for your repo

check "pip3 show mitmproxy"
tool python3 3

start "python3 ./mitmfaultinjection.py"

woot
```

</details>

<details><summary>Rust</summary>

```shell
#!/bin/zsh
set -e
TOOL_NAME=./x
PROJECT_NAME=myrustproject
. ./woot.inc # change this to the right import for your repo

tool cargo

build "cargo build"

run formatter "cargo fmt"
run linter "cargo clippy"
run check "cargo check"

start "./target/debug/myrustproject"

cleanup target

woot
```
</details>

<details><summary>Kotlin + Gradle</summary>

```shell
#!/bin/zsh
set -e
TOOL_NAME=./x
PROJECT_NAME=mygradleproject
. ./woot.inc # change this to the right import for your repo

build "./gradlew :build"
start "./gradlew :run"

run "gradle task list" "./gradlew :tasks"
run "tests "./gradlew :check"
run "create jar" "./gradlew :jar "
run "create distribution zip" "./gradlew :distZip"
run "install" "./gradlew :installDist"
run "docker build" "./gradlew :docker"
run "upload docker image" "./gradlew :dockerPush"
run "javadoc" "./gradlew :javadoc"
# add more gradle tasks here if needed

cleanup build .gradle

woot
```
</details>

# Documentation

<a name="documentation" id="documentation"></a>

## Features

These are current features of the shell script DSL:

- It's all zsh
- `build "<command>"` for invoking build
- `start "<command>"` for starting developer mode
- `cleanup ./build` for removing folders as a cleanup task
- `run "<task name>" "<command>"` for adding project-specific scripts
- `tool <command_name> <version_range>` for making sure tools exist
- `check "<command_name>"` for free-form checks

## File structure

Assuming that you make your build script into the file `./x`:

Since the script you write with `./x` is a regular zsh script, you have to
source the DSL commands into it.

Here's an empty build file to start with:

```shell
#!/bin/zsh
set -e
TOOL_NAME=./x # change to the name of the script
PROJECT_NAME= # change to project
. ./woot.inc # change to match where you wget'ed

# commands go here...

woot
```

## Command reference

Commands from ideal-build-tool are implemented as zsh functions and aliases.

### `woot` - Invocation

Simply starts the machinery of the tool. You should invoke `woot` at the end
of the build script.

Reference:

Runs registered commands depending on the CLI arguments.

- Parses command line arguments
- Handles -v and --help
- When no arguments are passed: 
  - Starts fuzzy finder `fzf` with list of runnable commands. 
  - When a command is selected, runs it.
- When 1 argument is passed, parses it as a command name and runs it.
  - When `start` is the first argument, runs the command registered as the start
    script.
  - When `build` is the first argument, runs the command registered as the build
    script.
  - Lookups the script registered with that name and runs it.
- When more than 1 arguments are passed:
  - Looks up the script registered with that name and runs it.

Syntax:

```
woot
```

### `start` - Define start script

Registers a command to run when `./x start` is run.

Shows the "./x start" command in the help text.

Syntax:

```
start "<command>"
```

Example:

```
start "python3 ./mycommand.py"
```

### `build` - Define build script 

Registers a command to run when `./x build` is run.

Shows the "./x build" command in the help text.

Syntax:

```
build "<command>"
```

Example:

```
build "./gradlew :build"
```

### `cleanup` - Define cleanup folders

Registers folders to delete when `./x cleanup` is run.

Syntax:

```
cleanup <folder> <folder...>
```

Example:

```
cleanup target/ ./dist/ ./__cache__/
```

### `run` - define custom scripts 

Registeres a custom script.

Custom scripts can be invoked:

- On the command line: `./x <script name>`
- With the fuzzy finder: `./x`, select `<script name>`, press the Enter key.

Custom scripts appear in the help as:

```
additional scripts:
./x <script name>
```

Syntax:

```
run <script name> with <command>
```

Example:

```
run "tests" "cargo test"

run "dependency updates" "yarn upgrade-interactive"
```

### `tool` - Check for tools

Checks that `<commandname>` is available in the `PATH`. If not, shows an error
message and exits the script.

If `<version_check>` is provided, runs `<commandname> --version` and matches the
output to the `version_check` string. If the output of `<commandname> --version`
does not contain the `version_check` string, shows an error message and exits
the script.

Syntax:

```
tool <commandname> <version_check>
```

Example:

```
tool yarn 1.22
```

### `check` - Generic checks

Runs a command to validate that something is OK before continuing with the 
tooling script.

This is useful to check that the user's environment is set up correctly, or
that the project is in a clean state.

If the command returns a nonzero status code, shows an error message and exits.

If the command returns a zero status code, silently continues.

Syntax:

```
check "<command>"
```

Example:

```
# Check that docker is up.
check "docker ps"
```

# Project governance

<a name="governance" id="governance"></a>

## Name

`woot`

## Governance

Currently: benevolent dictator for life

## Contributing

Standard GitHub flow: fork, pull-request, validate, merge

## Licensing

MIT license

## Roadmap

- Specializations
  - Specialized sourceable Zsh scripts that help with certain project
    environments
  - Yarn, NPM, Node, Lerna, Yarn Workspaces, etc
  - Gradle
  - Bazel
  - Pip, Poetry, Pipenv
  - Docker


## Non-goals

- **Dependency graphs, caching, etc** -- many other tools do it better. Invoke
  those tools with this.
- **Downloading tools** -- Package managers etc vary a lot. You might have
  vendoring or multiple SDKs installed. You can use `tool TOOLNAME VERSION` to
  check for existence.
- **Installable CLI** - woot should be vendored into the repo.
- **Package manager packages** - woot should be vendored into the repo.