#!/usr/bin/env bash

# Prints the given message to STDERR and exits non zero.
#
# $1 - Message
abort() {
  warn "$(program_name): $1"
  exit 1
}
export -f abort

# Prints the current program name, eg: "lcars" or "lcars help".
program_name() {
  printf "%s\\n" "${0//*\/lcars-/lcars }"
}
export -f program_name

# Prints the given message to STDERR
#
# $1 - Message
warn() {
  echo "${1:-}" >&2
}
export -f warn

getopt() {
  "$_LCARS_ROOT/vendor/getopt/bin/getopt" "$@"
}
export -f getopt

# Checks if the given bash variable is set and not blank.
#
# $1 - variable name
#
# Returns 0 if the variable is set, non-zero if it is unset.
var_is_set() {
  local name="$1"

  [[ "${!name-}" ]]
}
export -f var_is_set

# Checks if the given bash variable is set, otherwise aborts.
#
# $1 - variable name
#
# Returns 0 if the variable is set, non-zero if it is unset.
require_var() {
  local name="$1"

  var_is_set "$name" || {
    warn "Variable \`$name' is not set!"
    return 1
  }
}
export -f require_var

# Checks if an array contains the given value.
#
# $1 - key
# $@ - array
#
# Eg:
#   array=(foo bar baz)
#   array_includes "baz" "${array[@]}"
array_has() {
  local item

  for item in "${@:2}"; do
    [[ "$item" == "$1" ]] && return 0
  done

  return 1
}
export -f array_has

# Strips blank lines from the start or end of the given text.
#
# $1 - String (default is STDIN)
#
# See: https://stackoverflow.com/a/7363393
#
# Eg:
#   { echo; echo one; echo } | strip_lines
#   strip_lines "\none\n\n"
strip_lines() {
  awk '
    /[[:graph:]]/ { p = 1; for (i = 1; i <= n; i++) print ""; n =0 ; print; }
    p && /^[[:space:]]*$/ { n++ }
  ' <<< "${1:-$(cat)}"
}
export -f strip_lines

# Checks if the given PHP extension is installed.
#
# $1 - Extension name
php:has_extension() {
  local extension="$1"

  if ! php:cli -m | grep "$extension" &> /dev/null; then
    warn "PHP extension '$extension' is not installed."
    return 1
  fi

  return 0
}
export -f php:has_extension

# Returns the path to the PHP binary.
php:bin() {
  local php_bin

  if ! php_bin="$(command -v php)"; then
    warn "PHP is not installed, or it is not in your PATH."
    return 1
  fi

  # TODO try remi and others

  echo "$php_bin"
}
export -f php:bin

# Executes the given PHP command using the PHP binary.
php:cli() {
  local php_bin

  php_bin="$(php:bin)"

  if [[ -z "$php_bin" ]]; then
    warn "PHP is not installed, or it is not in your PATH."
    return 1
  fi

  "$php_bin" "$@"
}
export -f php:cli

# Simple wrapper for `jq` with custom colors.
#
# $@ - jq arguments
jq() {
  if ! command -v jq > /dev/null; then
    abort "jq is not installed. Please install it from https://stedolan.github.io/jq/"
  fi

  export JQ_COLORS="0;02:0;35:0;35:0;36:0;92:1;39:1;39:1;34"

  command jq "$@"
}
export -f jq

# Reads a JSON file containing an array and returns a random element from it.
jq:array:random() {
  local content count

  content="$(cat)"

  count="$(jq -r length <<< "$content")"

  jq -r --arg i "$((RANDOM % count))" '.[$i|tonumber]' <<< "$content" 2> /dev/null
}
export -f jq:array:random

lcars:config:file() {
  : "${LCARS_CONFIG:="${XDG_CONFIG_HOME:-$HOME/.config}/lcars.json"}"

  printf "%s\n" "$LCARS_CONFIG"
}
export -f lcars:config:file

lcars:config:read() {
  local file

  file="$(lcars:config:file)"

  if [[ -f "$file" ]]; then
    cat "$file"
  else
    echo "{}"
  fi
}
export -f lcars:config:read

lcars:config:get() {
  local key="$1" data="${2-}"

  if [[ -z "$key" ]]; then
    warn "Usage: lcars:config:get <key> [<data>]"
    return 1
  fi

  if [[ -z "$data" ]]; then
    data="$(lcars:config:read)"
  fi

  jq --arg k "$key" -r '.[$k]' <<< "$data" 2> /dev/null
}
export -f lcars:config:get

lcars:config:set() {
  local key="$1" value="${2-}" data="${3-}" tmpconfig

  if [[ -z "$key" ]]; then
    warn "Usage: lcars:config:get <key> [<data>]"
    return 1
  fi

  if [[ -z "$data" ]]; then
    data="$(lcars:config:read)"
  fi

  tmpconfig="$(mktemp -t lcars-config-XXXXXX.json)"

  # trap 'rm -f "$tmpconfig"' EXIT

  if ! jq --arg k "$key" --arg v "$value"  '.[$k] = $v' <<< "$data" > "$tmpconfig"; then
    warn "Failed to update config file."
    rm -f "$tmpconfig"
    return 1
  fi

  mkdir -p "$(dirname "$(lcars:config:file)")"

  mv -f "$tmpconfig" "$(lcars:config:file)" || {
    warn "Failed to move temporary config file to final location."
    rm -f "$tmpconfig"
    return 1
  }
  rm -f "$tmpconfig"
}
export -f lcars:config:set

# Hashes the given file using sha256.
hash:sha256() {
  if command -v sha256sum &> /dev/null; then
    sha256sum | awk '{ print $1 }'
  elif command -v shasum &> /dev/null; then
    shasum -a 256 | awk '{ print $1 }'
  else
    abort "No sha256sum or shasum found"
  fi
}
export -f hash:sha256

# Hashes the given file using md5.
hash:md5() {
  if command -v md5sum &> /dev/null; then
    md5sum | awk '{ print $1 }'
  elif command -v md5 &> /dev/null; then
    md5 | awk '{ print $4 }'
  else
    abort "No md5sum or md5 found"
  fi
}
export -f hash:md5

# Hashes the given file using sha1.
hash:sha1() {
  if command -v sha1sum &> /dev/null; then
    sha1sum | awk '{ print $1 }'
  elif command -v shasum &> /dev/null; then
    shasum -a 1 | awk '{ print $1 }'
  else
    abort "No sha1sum or shasum found"
  fi
}
export -f hash:sha1

# Generate a random hash.
hash:random() {
  openssl rand -hex 32
}
export -f hash:random

# ASCII color codes
color:codes() {
  local name="${1:-normal}"

  case "$name" in
    normal)    echo 0 ;;
    bold)      echo 1 ;;
    dim)       echo 2 ;;
    italic)    echo 3 ;;
    underline) echo 4 ;;
    invert)    echo 7 ;;
    black)     echo 30 ;;
    red)       echo 31 ;;
    green)     echo 32 ;;
    yellow)    echo 33 ;;
    blue)      echo 34 ;;
    magenta)   echo 35 ;;
    cyan)      echo 36 ;;
    white)     echo 37 ;;

    bg-black)   echo 40 ;;
    bg-red)     echo 41 ;;
    bg-green)   echo 42 ;;
    bg-yellow)  echo 43 ;;
    bg-blue)    echo 44 ;;
    bg-magenta) echo 45 ;;
    bg-cyan)    echo 46 ;;
    bg-white)   echo 47 ;;

    *) echo "Invalid color name: $name" >&2  && return 1 ;;
  esac
}
export -f color:codes

# Sets the given color for any subsequent text printed to the console.
#
# Call `color:off` to reset the color when done
#
# Eg:
#   color:on red --bold
#   echo "This text is bold red"
#   color:off
#
#   color:on normal --italic
#   echo "This text is italic in the normal/default color"
#   color:off
#
# $1 - color name
# $@ - args
#     --bold
#     --italic
#     --bright
#     --invert
#     --dim 4
color:on() {
  [[ "${NO_ANSI-}" == "1" ]] && return 0

  local name="$1" code spec bg_spec=""

  shift

  code="$(color:codes "$name")"

  if [[ "$name" == "normal" ]]; then
    spec="${code}m"
  fi

  spec=""
  for arg in "$@"; do
    case "$arg" in
      --bold)
        spec="$spec;$(color:codes bold)" ;;
      --dim)
        spec="$spec;$(color:codes dim)" ;;
      --italic)
        spec="$spec;$(color:codes italic)" ;;
      --invert)
        spec="$spec;$(color:codes invert)" ;;
      --underline)
        spec="$spec;$(color:codes underline)" ;;
      --bright)
        code=$((code + 60)) ;;
      bg-*)
        bg_spec="$bg_spec;$(color:codes "$arg")" ;;
    esac
  done

  echo -n -e "\033[${code}${spec}${bg_spec}m"
}
export -f color:on

# Resets the color to the default.
color:off() {
  color:on normal
}
export -f color:off

# Prints the given text in the given color.
#
# $1 - text
# $@ - color:on args
str:color() {
  local text="$1"

  shift

  printf "%s" "$(color:on "$@")${text}$(color:off)"
}
export -f str:color

# Print the application root
app:root() {
  php artisan tinker --execute "echo base_path() . PHP_EOL;"
}
export -f app:root

app:environment() {
  php artisan tinker --execute "echo app()->environment() . PHP_EOL;"
}
export -f app:environment

# Checks if the given composer package is installed.
composer:is_installed() {
  composer show "$@" >/dev/null 2>&1
}
export -f composer:is_installed
