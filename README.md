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

## Installation

### Install globally via Homebrew on macOS

On macOS, `lcars` can be installed via Homebrew with:

```
brew install built-fast/devtools/lcars
```

### Install globally via make

macOS and most Linux distributions add `/usr/local/bin` to `$PATH` and
`/usr/local/share/man` to `$MANPATH`. If you are the only user on the machine,
or if you want to make `lcars` available for all users, you can install
it globally as follows:

```
git clone https://github.com/built-fast/lcars
cd lcars
sudo make install PREFIX=/usr/local
```

### Install locally via make

If you don't want a global installation, another common pattern is to install
to `~/.local`. This is enabled on Ubuntu by default.

```
git clone https://github.com/built-fast/lcars
cd lcars
make install PREFIX=~/.local
```

To test, verify that `lcars help` works and that `man lcars` prints the man
page.

If you see `lcars: command not found`, you need to update your `$PATH`.
If you are using Bash, add the following to `~/.bash_profile`, or if you are
using ZSH, add it to `~/.zshenv`:

```
export PATH="$HOME/.local/bin:$PATH"
```

If `man lcars` reports `No manual entry for lcars`, you need to
update your `$MANPATH`. This can be done by adding the following to
`~/.manpath` (note, change USER to your username):

```
MANDATORY_MANPATH /home/USER/.manpath
```

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
  app:decrypt         Decrypts input data using Laravel's encryption service
  app:deps:outdated   Show outdated dependencies for the current app
  app:encrypt         Encrypts input data using Laravel's encryption service
  app:environment     Prints the current application environment
  app:eval            Runs the given PHP code in the context of a Laravel application
  app:new             Creates a new Laravel app with sensible defaults
  app:reset           Fully resets the application database and clears caches.
  app:root            Prints the application root path
  cli:aliases         Lists all LCARS aliases
  cli:commands        Lists all LCARS commands
  cli:help            Prints help for LCARS commands
  cli:update          Updates LCARS
  docs                Open Laravel documentation pages
  hash:md5            Hashes a string or file contents using MD5
  hash:random         Generates a random hash using OpenSSL
  hash:sha1           Hashes a string or file contents using SHA-1
  hash:sha256         Hashes a string or file contents using SHA-256
  inspect:headers     Makes a cURL request and prints the headers
  inspect:ssl:expiry  Prints SSL expiration dates for domains
  php:ext             Checks if a PHP extension is installed
  test                Runs Pint, Pest, PHPStan, and ShellCheck tests
  test:annotate:cl2pr Convert Clover XML test results to GitHub Actions annotations
  test:annotate:cs2pr Convert Checkstyle XML test results to GitHub Actions annotations
  test:annotate:ju2pr Convert JUnit XML test results to GitHub Actions annotations
  test:pest           Runs Pest test suite
  test:phpstan        Runs PHPStan on PHP files in the project
  test:pint           Runs Pint on PHP files in the project
  test:shellcheck     Runs ShellCheck on all Bash files in the project
  util:copy           Copies strings to the clipboard
  util:git:stats      Shows lines added and deleted by author in a git repo
  util:ip             Prints public IP address using CloudFlare DNS
  util:open           Opens a file or URL with the default application
  util:paste          Pastes the contents of the clipboard
  util:path           Prints your current PATH
  util:retry          Retries a command
  util:screenshot     Saves a screenshot to the specified path

See `lcars help <command>' for information on a specific command.

ALIASES
  commands:    cli:commands
  console:     app:console
  hash:        hash:sha256
  help:        cli:help
  test:types:  test:phpstan
```

## Development

### Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository at https://github.com/built-fast/lcars
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test them locally
4. Run the test suite: `make test` (requires `gh extension install built-fast/gh-shellcheck`)
5. If required, update `doc/man/lcars.1.md` with any new commands or options
   - Use `make man` to generate the man page (requires `pandoc`; i.e. `brew
     install pandoc`)
6. Commit your changes with a clear message
7. Push to your fork and submit a pull request

Please ensure your code follows the existing style and passes ShellCheck.

### Homebrew Formula

This project includes automated release workflows:

- **Automated Releases**: When a new tag matching `v*` is pushed, GitHub
  Actions automatically creates a release with a zip archive
- **Homebrew Integration**: Releases automatically trigger an update to the
  Homebrew tap at [`built-fast/homebrew-devtools`](https://github.com/built-fast/homebrew-devtools)
- **Archive Generation**: The workflow uses `make archive` to create properly
  formatted release packages

The automation ensures consistent releases and keeps the Homebrew formula
up-to-date without manual intervention.

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
