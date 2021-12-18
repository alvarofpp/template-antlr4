#!/bin/bash

# Colors
GREEN='\033[1;32m'
NC='\033[0m'

# Functions
function printHeader() {
  # shellcheck disable=SC2059
  printf "${GREEN}--- $1 ---${NC}\n"
}
function getInput() {
  # shellcheck disable=SC2162
  read -p "$1 [\"$2\"]: " VAR
  VAR=${VAR:-"$2"}
  echo "$VAR"
}
function getExtension() {
  local EXTENSION
  case $1 in
    "C#") EXTENSION='cs' ;;
    "Java") EXTENSION='java' ;;
    "Python2") EXTENSION='py' ;;
    "Python3") EXTENSION='py' ;;
    "JavaScript") EXTENSION='js' ;;
    "Go") EXTENSION='go' ;;
    "C++") EXTENSION='cpp' ;;
    "Swift") EXTENSION='swift' ;;
    "PHP") EXTENSION='php' ;;
    "Dart") EXTENSION='dart' ;;
  esac

  if [[ -z "$EXTENSION" ]];
  then
    echo "java"
  else
    echo "$EXTENSION"
  fi
}

# Main
# Get data
printHeader 'Project'
TITLE=$(getInput 'Title' 'Title here')
DESCRIPTION=$(getInput 'Description' 'Description here')

printHeader 'Code Generation Target'
TARGET_LANGUAGE=$(getInput 'Target language' 'Java')
TARGET_EXTENSION=$(getExtension "$TARGET_LANGUAGE")

printHeader 'Grammar'
GRAMMAR=$(getInput 'The name of your grammar' 'Expr')

# Get stubs and replace variables
STUB_FOLDER='.stubs'

sed "s/{{TITLE}}/${TITLE}/" "${STUB_FOLDER}/README.stub" \
  | sed "s/{{DESCRIPTION}}/${DESCRIPTION}/" > 'README.md'

sed "s/{{TARGET_LANGUAGE}}/${TARGET_LANGUAGE}/" "${STUB_FOLDER}/Makefile.stub" \
  | sed "s/{{TARGET_EXTENSION}}/${TARGET_EXTENSION}/" \
  | sed "s/{{GRAMMAR}}/${GRAMMAR}/" > 'Makefile'

sed "s/{{GRAMMAR}}/${GRAMMAR}/" "${STUB_FOLDER}/Grammar.stub" > "src/${GRAMMAR}.g4"
