# LCARS - Laravel CLI and Reusable Scripts

LCARS is a command-line toolkit that enhances Laravel development workflows
with convenient utilities and shortcuts. It provides quick access to common
Laravel tasks, testing tools, development utilities, and documentation
browsing—all through a unified CLI interface.

Key features:

- **Testing Suite**: Run Pest, PHPStan, Pint, and ShellCheck with simple
  commands
- **Documentation**: Browse Laravel docs with fuzzy search using `fzf`
- **Development Utilities**: Hash generation, HTTP header and SSL inspection,
  clipboard operations, and more

## Usage

```
Usage: lcars <command>

NAME
  lcars -- Laravel CLI and Reusable Scripts

SYNOPSIS
  lcars <command>

DESCRIPTION
  LCARS contains CLI tools for working with Laravel projects.

OPTIONS
  -h
      Print short help and exit.

  --help
      Print full help text and exit. Same as `lcars help`.

  --root
      Print the root directory that LCARS is installed to and exit.

COMMANDS
  app:artisan         Interactive Laravel Artisan command launcher with fuzzy search
  app:console         Opens the Tinker console
  app:environment     Prints the current application environment
  app:eval            Runs the given PHP code in the context of a Laravel application
  app:reset           Fully resets the application database and clears caches.
  app:root            Prints the application root path
  cli:aliases         Lists all LCARS aliases
  cli:commands        Lists all LCARS commands
  cli:config:edit     Opens the LCARS config file in $EDITOR
  cli:config:get      Gets a local LCARS config
  cli:config:set      Sets a local LCARS config
  cli:help            Prints help for LCARS commands
  cli:update          Updates LCARS
  docs                Open Laravel documentation pages
  hash:md5            Hashes a string or file contents using MD5
  hash:random         Generates a random hash using OpenSSL
  hash:sha1           Hashes a string or file contents using SHA-1
  hash:sha256         Hashes a string or file contents using SHA-256
  inspect:headers     Makes a cURL request and prints the headers
  inspect:php:ext     Checks if a PHP extension is installed
  inspect:ssl:expiry  Prints SSL expiration dates for domains
  quote               Satisfaction is not guaranteed
  test                Runs Pint, Pest, PHPStan, and ShellCheck tests
  test:pest           Runs Pest test suite
  test:phpstan        Runs PHPStan on PHP files in the project
  test:pint           Runs Pint on PHP files in the project
  test:shellcheck     Runs ShellCheck on all Bash files in the project
  util:copy           Copies strings to the clipboard
  util:ip             Prints public IP address using CloudFlare DNS
  util:paste          Pastes the contents of the clipboard
  util:path           Prints your current PATH
  util:retry          Retries a command

See `lcars help <command>' for information on a specific command.

ALIASES
  commands:    cli:commands
  console:     app:console
  hash:        hash:sha256
  help:        cli:help
  test:types:  test:phpstan
```

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
