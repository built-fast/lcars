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

# ASCII color codes
color:codes() {
  local name="${1:-normal}"

  case "$name" in
    normal) echo 0 ;;
    bold) echo 1 ;;
    dim) echo 2 ;;
    italic) echo 3 ;;
    underline) echo 4 ;;
    invert) echo 7 ;;
    black) echo 30 ;;
    red) echo 31 ;;
    green) echo 32 ;;
    yellow) echo 33 ;;
    blue) echo 34 ;;
    magenta) echo 35 ;;
    cyan) echo 36 ;;
    white) echo 37 ;;

    bg-black) echo 40 ;;
    bg-red) echo 41 ;;
    bg-green) echo 42 ;;
    bg-yellow) echo 43 ;;
    bg-blue) echo 44 ;;
    bg-magenta) echo 45 ;;
    bg-cyan) echo 46 ;;
    bg-white) echo 47 ;;

    *) echo "Invalid color name: $name" >&2 && return 1 ;;
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
  [[ "${_LCARS_IS_TTY-}" == yes ]] || return 0

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
        spec="$spec;$(color:codes bold)"
        ;;
      --dim)
        spec="$spec;$(color:codes dim)"
        ;;
      --italic)
        spec="$spec;$(color:codes italic)"
        ;;
      --invert)
        spec="$spec;$(color:codes invert)"
        ;;
      --underline)
        spec="$spec;$(color:codes underline)"
        ;;
      --bright)
        code=$((code + 60))
        ;;
      bg-*)
        bg_spec="$bg_spec;$(color:codes "$arg")"
        ;;
    esac
  done

  printf "\e[%s%s%sm" "$code" "$spec" "$bg_spec"
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

  printf "%s%s%s" "$(color:on "$@")" "${text}" "$(color:off)"
}
export -f str:color

# Checks if the given composer package is installed.
composer:is_installed() {
  composer show "$@" > /dev/null 2>&1
}
export -f composer:is_installed
