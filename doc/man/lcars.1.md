% LCARS(1) lcars | User Commands
% 
% June 2025

# NAME

lcars - Laravel CLI and Reusable Scripts

# SYNOPSIS

**lcars** [*OPTION*] *COMMAND* [*ARGS*...]

**lcars** **\-\-help** | **-h**

**lcars** **\-\-root**

# DESCRIPTION

LCARS is a comprehensive CLI toolkit designed specifically for Laravel development workflows. It combines Laravel-specific application management tools with general development utilities for testing, system inspection, cryptographic operations, and productivity enhancements.

The command structure follows a clear namespace pattern with colons separating categories from specific actions, making it easy to discover and organize related functionality.

# OPTIONS

**-h**
:   Print short help and exit.

**\-\-help**
:   Print full help text and exit. Same as `lcars help`.

**\-\-root**
:   Print the root directory that LCARS is installed to and exit.

# COMMANDS

## Application Management (app:)

Laravel application integration for development and deployment tasks:

**app:artisan** [*command*] [*arguments*...]
:   Interactive Laravel Artisan command launcher with fuzzy search. When called without arguments, presents a searchable list of all available Artisan commands. Use arrow keys to navigate, type to filter, press '?' for help preview, and Enter to execute.

**app:console**
:   Opens the Laravel Tinker REPL console for interactive PHP evaluation.

**app:decrypt** [*data*]
:   Decrypts input data using Laravel's encryption service. Reads from stdin if no data provided.

**app:encrypt** [*data*]
:   Encrypts input data using Laravel's encryption service. Reads from stdin if no data provided.

**app:environment**
:   Prints the current Laravel application environment (e.g., local, staging, production).

**app:eval** *code*
:   Runs PHP code in the context of a Laravel application with full framework access.

**app:reset**
:   Fully resets the application database, runs migrations, and clears all caches. Use with caution.

**app:new** *app-name* [*options*]
:   Creates a new Laravel application with sensible defaults including Pest/PHPUnit for testing, Pint for code formatting, and Larastan for static analysis. Supports database selection (sqlite, mysql, mariadb, pgsql, sqlsrv), test framework choice (pest, phpunit), Pint mode (standard, strict), PHPStan level (0-9), and optional Laravel Sail removal.

**app:root**
:   Prints the Laravel application root directory path.

## CLI Management (cli:)

LCARS tool management and configuration:

**cli:aliases**
:   Lists all LCARS command aliases and their targets.

**cli:commands**
:   Lists all available LCARS commands. Used internally by the help system.

**cli:config:edit**
:   Opens the LCARS configuration file in the default editor ($EDITOR).

**cli:config:get** *key*
:   Gets a local LCARS configuration value by key.

**cli:config:set** *key* *value*
:   Sets a local LCARS configuration value.

**cli:help** [*command*]
:   Prints help for LCARS commands. Without arguments, shows overview. With command name, shows detailed help.

**cli:update**
:   Updates LCARS to the latest version from the repository.

## Cryptographic Operations (hash:)

Hashing and cryptographic utilities:

**hash:md5** [*string*]
:   Hashes a string or file contents using MD5. Reads from stdin if no string provided.

**hash:random** [*length*]
:   Generates random hashes using OpenSSL. Default length varies by implementation.

**hash:sha1** [*string*]
:   Hashes a string or file contents using SHA-1. Reads from stdin if no string provided.

**hash:sha256** [*string*]
:   Hashes a string or file contents using SHA-256. Reads from stdin if no string provided.

## System Inspection (inspect:)

Tools for examining system states and network resources:

**inspect:headers** *url*
:   Makes cURL requests and prints HTTP headers for the specified URL.

**inspect:php:ext** *extension*
:   Checks if specified PHP extensions are installed and available.

**inspect:ssl:expiry** *domain*...
:   Prints SSL certificate expiration dates for one or more domains. Supports custom ports (domain:port).

## Testing and Code Quality (test:)

Comprehensive testing and code quality tools for PHP/Laravel development:

**test** [*tool*]
:   Runs complete test suite including Pint, Pest, PHPStan, and ShellCheck. Can run individual tools by specifying: shellcheck, pint, pest, phpstan, or types.

**test:pest** [*args*...]
:   Runs the Pest PHP testing framework with optional arguments.

**test:phpstan** [*args*...]
:   Runs PHPStan static analysis on PHP files with optional arguments.

**test:pint** [*args*...]
:   Runs Laravel Pint code formatting on PHP files with optional arguments.

**test:annotate:cl2pr**
:   Converts Clover XML test results to GitHub Actions annotation format. Reads XML data from stdin and outputs a markdown coverage report with file-by-file statistics, color-coded coverage indicators (🔴 < 50%, 🟡 < 70%, 🟢 ≥ 70%), and GitHub-style callout blocks. Suitable for GitHub Actions step summaries.

**test:annotate:cs2pr** [*options*]
:   Converts Checkstyle XML test results to GitHub Actions annotation format. Reads XML data from stdin. Based on the popular cs2pr utility. Options include \-\-graceful-warnings, \-\-colorize, \-\-notices-as-warnings, \-\-errors-as-warnings, \-\-prepend-filename, \-\-prepend-source.

**test:annotate:ju2pr** [*options*]
:   Converts JUnit XML test results to GitHub Actions annotation format. Extracts test failures and errors with file paths and line numbers from stack traces. Compatible with Vim error format for editor integration. Options include \-\-graceful-warnings and \-\-colorize.

**test:shellcheck**
:   Runs ShellCheck analysis on all Bash files in the project.

**test:types** [*args*...]
:   Alias for test:phpstan - runs PHPStan type checking.

## System Utilities (util:)

General system utility functions:

**util:copy** [*string*]
:   Copies strings to the system clipboard. Works with pbcopy (macOS) and xclip (Linux). Reads from stdin if no string provided.

**util:git:stats** [*git-log-options*]
:   Shows lines added and deleted by author in a git repo. Displays git statistics grouped by author, showing lines added, deleted, and net change. All git log options are supported and passed through, such as \-\-since="1 year ago", \-\-author="name", \-\-until="2023-12-31", main..feature-branch.

**util:ip** [**-4**|**-6**]
:   Gets public IP address using CloudFlare DNS. Supports both IPv4 (default) and IPv6.

**util:open** *file-or-url*
:   Opens a file or URL with the default application. Cross-platform wrapper around system open commands (xdg-open on Linux, open on macOS, explorer.exe on Windows).

**util:paste**
:   Pastes contents from the system clipboard to stdout.

**util:path**
:   Displays the current PATH environment variable in a readable format.

**util:retry** [*options*] *command*
:   Retries failed commands with configurable attempts and delay.

**util:screenshot** *file*
:   Takes an interactive screenshot and saves it to the specified file path. Allows selection of screen regions or windows. Press space to capture a window, or click and drag to select a custom region. Screenshots are saved in PNG format. macOS only.

## Standalone Commands

**completions**
:   Provides shell completion functionality for LCARS commands. Used by shell completion systems.

**console**
:   Alias for app:console - opens Laravel Tinker REPL.

**docs** [*search-term*]
:   Opens Laravel documentation pages in the default browser. Supports search.

**help** [*command*]
:   General help system for LCARS commands. Shows command overview or detailed help for specific commands.


# EXAMPLES

Create new Laravel application:
:   **lcars app:new** myapp \-\-database=mysql \-\-test-framework=pest

Launch interactive Artisan command selector:
:   **lcars app:artisan**

Run specific Artisan command:
:   **lcars app:artisan** migrate:status

Hash a string with SHA-256:
:   **echo** "hello world" **|** **lcars hash:sha256**

Check SSL certificate expiration:
:   **lcars inspect:ssl:expiry** example.com google.com:443

Run complete test suite:
:   **lcars test**

Run only PHP code style checks:
:   **lcars test** pint

Convert test coverage to GitHub annotations:
:   **pest \-\-coverage \-\-coverage-clover clover.xml && lcars test:annotate:cl2pr < clover.xml**
:   **pest \-\-coverage \-\-coverage-clover >(lcars test:annotate:cl2pr)**

Convert Pint results to GitHub annotations:
:   **pint \-\-test \-\-report checkstyle | lcars test:annotate:cs2pr**

Convert test failures to GitHub annotations:
:   **pest \-\-log-junit junit.xml && lcars test:annotate:ju2pr < junit.xml**
:   **pest \-\-log-junit >(lcars test:annotate:ju2pr)**

Copy text to clipboard:
:   **lcars util:copy** "Important text to save"

Get public IP address:
:   **lcars util:ip**

Open a file or URL:
:   **lcars util:open** ~/Documents/file.pdf
:   **lcars util:open** https://laravel.com

Open Laravel Tinker console:
:   **lcars console**

Take an interactive screenshot:
:   **lcars util:screenshot** ~/Desktop/screenshot.png

Get help for a specific command:
:   **lcars help** app:artisan

# ENVIRONMENT

**LCARS_DEBUG**
:   When set, enables debug mode with verbose script execution tracing.

**EDITOR**
:   Used by cli:config:edit to determine which editor to open configuration files with.

# FILES

**~/.lcars/config**
:   User configuration file for LCARS settings.

**$_LCARS_ROOT/libexec/**
:   Directory containing all LCARS command implementations.

**$_LCARS_ROOT/share/lcars/stdlib.sh**
:   Standard library functions used by LCARS commands.


# EXIT STATUS

**0**
:   Success

**1**
:   General error (command not found, invalid arguments, etc.)

**2**
:   Command-specific error (test failures, network issues, etc.)

# REPORTING BUGS

Report bugs and issues at: <https://github.com/built-fast/lcars/issues>

# AUTHORS

Written by the BuiltFast.com team.

# LICENSE

MIT License

Copyright (c) 2025 BuiltFast.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# SEE ALSO

**artisan**(1), **composer**(1), **php**(1)

Laravel Documentation: <https://laravel.com/docs>
