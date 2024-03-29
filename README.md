# toolshell

```shell
#!/bin/zsh

# add some boilerplate, and customize the help message
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell.inc

# set up your project's commands and checkers
add_check "[[ -f .yarn/install-state.gz ]]" "yarn --immutable"
set_start_command "yarn start"

# call main to parse the cli arguments and perform the required actions
toolshell_main
```

Z-Shell based domain specific language for tooling, scripting, workflows etc.

Helps you write shell scripts that help users run common tasks in your project,
without figuring out the tools, build systems, scripts, run commands etc
involved.

Skip to:

- [Install](#install)
- [Examples](#examples)
- [Documentation](#documentation)
- [Project governance](#governance)

## Using toolshell for my own project

1. Download the toolshell.inc file to your repo
2. Create a util.zsh file that imports the toolshell.inc file and invokes toolshell_main: 
   ```shell
   #!/bin/zsh
   SCRIPT_NAME=util.zsh
   PROJECT_NAME=mycoolapp
   source ./toolshell.inc
   
   # fill in later
   
   toolshell_main
   ```

3. Add commands, cleanup folders etc
  ```shell
  #!/bin/zsh
  SCRIPT_NAME=util.zsh
  PROJECT_NAME=mycoolapp
  source ./toolshell.inc
   
  requires_tool node 16
  set_start_command "yarn start"
  set_build_command "yarn build"

  toolshell_main
  ```

4. Done

### Installation

<a name="install" id="install"></a>

Download the toolshell inc file:

```shell
wget -o ./toolshell.inc https://raw.githubusercontent.com/boxmein/toolshell/master/build/toolshell.inc
```

Create some subcommands: [see examples](#examples)

```shell
cat <<EOF > util.zsh
#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=mycoolapp
source ./toolshell.inc

# check that some commands are installed
requires_tool yarn 1.22.0
requires_tool node

# add command-aliases (e.g. ./x test)
add_command tests "yarn test"
add_command build "yarn build"
add_command publish "yarn publish"
add_command lint "yarn lint"

# set what ./x start does
set_start_command "yarn start"

# delete build/ when running ./x cleanup
add_cleanup_dir build

# parse cli flags, and perform actions
toolshell_main
EOF
```

Make it executable and add it to your repo:

```shell
chmod +x ./util.zsh
git add ./util.zsh
git commit -m "common utilities"
```

## Examples

<a name="examples" id="examples"></a>

<details><summary>Python 3</summary>

```shell
#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell.inc

requires_tool python3 3
requires_tool pip3

add_check "pip3 show mitmproxy"

set_start_command "python3 ./mitmfaultinjection.py"

toolshell_main
```

</details>

<details><summary>Rust</summary>

```shell
#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell.inc

requires_tool cargo

set_build_command "cargo build"

add_command formatter "cargo fmt"
add_command linter "cargo clippy"
add_command check "cargo check"

set_start_command "./target/debug/myrustproject"

add_cleanup_dir target

toolshell_main
```
</details>

<details><summary>Kotlin + Gradle</summary>

```shell
#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell.inc

set_build_command "./gradlew :build"
set_start_command "./gradlew :run"

add_command "gradle task list" "./gradlew :tasks"
add_command "tests" "./gradlew :check"
add_command "create jar" "./gradlew :jar "
add_command "create distribution zip" "./gradlew :distZip"
add_command "install" "./gradlew :installDist"
add_command "docker build" "./gradlew :docker"
add_command "upload docker image" "./gradlew :dockerPush"
add_command "javadoc" "./gradlew :javadoc"
# add more gradle tasks here if needed

add_cleanup_dir build .gradle

toolshell_main
```
</details>

# Documentation

<a name="documentation" id="documentation"></a>

## Features

These are current features of the shell script DSL:

- It's all zsh
- `set_build_command "<command>"` - command to run with  `./x build`
- `set_start_command "<command>"` - command to run with `./x start`
- `add_cleanup_dir ./build` - removes `./build` when you call `./x clean`
- `add_command "<cmdname>" "<commands...>"` - add a command alias (`./x cmdname = zsh -c commands...`) 
- `requires_tool <command_name> [version_range]` - check if command_name is in PATH
- `add_check "<command_name>"` - must exit with status 0 before the rest of the tools work
- `add_initializer "<check_command>" "<fixer>"` - run check_command, if it fails, offer to run fixer (useful escape hatch for ensuring the project is ready)

It also includes a useful library:

- Installing tools from package managers
- Comparing file ages
- Matching semver ranges
- Synchronizing files to a remote server

## File structure

Assuming that you make your build script into the file `./x`:

Since the script you write with `./x` is a regular zsh script, you have to
source the DSL commands into it.

Here's an empty build file to start with:

```shell
#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell.inc
# commands go here...

toolshell_main
```

## Command reference

It's nicer to start from an example. Some are above, some are in the [examples](./examples) folder.

### `toolshell_main` - parse cli arguments and perform actions

Runs registered commands depending on the CLI arguments.

Reference:

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

```shell
toolshell_main
```

### `set_start_command`

Registers a command to run when `./x start` is run.

Shows the "./x start" command in the help text.

Syntax:

```shell
set_start_command "<command>"
```

Example:

```shell
set_start_command "python3 ./mycommand.py"
```

### `set_build_command`

Registers a command to run when `./x build` is run.

Shows the "./x build" command in the help text.

Syntax:

```shell
set_build_command "<command>"
```

Example:

```shell
set_build_command "./gradlew :build"
```

### `add_cleanup_dir`

Registers folders to delete when `./x cleanup` is run.

Syntax:

```shell
add_cleanup_dir <path> <path...>
```

Example:

```shell
add_cleanup_dir target/ ./dist/ ./__cache__/
```

### `add_command` - define custom scripts 

Registeres a custom script.

Custom scripts can be invoked:

- On the command line: `./x <cmd>`
- With the fuzzy finder: `./x`, select `<cmd>`, press the Enter key.

Custom scripts appear in the help as:

```log
additional scripts:
./util.zsh run build: alias for "yarn build"
```

Syntax:

```shell
add_command "<cmd>" "<command>"
```

Example:

```shell
add_command "tests" "cargo test"

add_command "dependency updates" "yarn upgrade-interactive"
```

### `requires_tool` - Check for tools

`requires_tool "<tool>" "<version>"`

Checks that a given command line utility is available in the `PATH`. 
If not, shows an error message and exits the script.

If `<version>` is provided, runs `<commandname> --version` and matches the output to the `version` string. If the output of `<commandname> --version` does not contain the `version` string, shows an error message and exits the script.

For example:

```shell
requires_tool python3 3.10
# invokes `python3 --version | grep 3.10`
# if matches: OK
# if not matches: error, exit
```

If "--offer-install" is set, and the tool is missing, will offer to install the tool using the system package manager by running a command like `apt-get install <cmd>`.

Syntax:

```shell
requires_tool [--offer-install] <commandname> <version_check>
```

Example:

```shell
requires_tool yarn 1.22
requires_tool --offer-install make
```

### `add_check` - add a command that has to succeed

Runs a command to validate that something is OK before continuing with the  tooling script.

This is useful to check that the user's environment is set up correctly, or that the project is in a clean state.

If the command returns a nonzero status code, shows an error message and exits.

If the command returns a zero status code, silently continues.

Syntax:

```shell
add_check "<command>"
```

Example:

```shell
# Check that docker is up.
add_check "docker ps"
```

### `add_initializer` - Initialization steps

Runs a command to detect if the project is ready to run. If the command exits with a nonzero status code, it will invoke the second command to correct the problem.

Syntax:

```shell
add_initializer "<command>" "<command>"
```

Example:

```shell
add_initializer "_toolshell_is_newer_than package.json node_modules/.yarn-integrity" \
  "yarn install --immutable"
```

## Helpers

`toolshell` includes a number of helper functions for use in your tooling.

### `_toolshell_is_newer_than` - File age comparisons

Checks if file A is newer than file B. Returns zero status code if file A is 
newer.

Returns status code 1 if file B does not exist, or file B is older than file A.

Syntax:

```shell
_toolshell_is_newer_than "file_a" "file_b`
```

Example:

```shell
if _toolshell_is_newer_than package.json node_modules/.yarn-integrity; then 
  yarn install --immutable
fi
```

### `_toolshell_fs_file_modified_time` - Get time that file was modified


### `_toolshell_git_file_modified_time` - Get time that path was modified via git commit


### `_toolshell_range_matches_version` - Check if version matches range

Uses semver rules to determine if a version matches a specified version range.

Returns status code 0 if matches, status code 1 if does not match.

Supported version ranges:

- Caret syntax `^1.2.0` - pass if minor or patch version is greater than or
  equal to desired
- Tilde syntax `~1.2.0` - pass if patch version is greater than or equal to
  desired
- Greater-than syntax `>=1.2.0` - pass if all versions are greater-than or equal
  to desired

Syntax:

```shell
_toolshell_range_matches_version "<desired_range>" "<actual_version>"
```

Example:

```shell
_toolshell_range_matches_version "^1.0.0" "1.2.5" # ok
_toolshell_range_matches_version ">=1.0.0" "2.8.04" # ok
_toolshell_range_matches_version "~12.3.2200" "1.2.3" # fail
```


# Project governance

<a name="governance" id="governance"></a>

## Name

`toolshell`

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
- **Installable CLI** - toolshell should be vendored into the repo.
- **Package manager packages** - toolshell should be vendored into the repo.

