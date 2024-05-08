#!/bin/bash
ROOT_DIR=$(git rev-parse --show-toplevel)
cd $ROOT_DIR

if ! command -v pre-commit &> /dev/null
then
		brew install pre-commit
		printf '%s\n' "🌴 DONE Installed pre-commit"
else
		printf '%s\n' "🌴 \`pre-commit\` is already installed"
fi

if pre-commit install --hook-type pre-commit --config .pre-commit-config.yaml; then
		printf '%s\n' "🌴 DONE: config pre-commit"
else
		printf '\t%s\n' "💔 FAIL"
fi

if pre-commit install --hook-type pre-push --config .pre-push-config.yaml;  then
		printf '%s\n' "🌴 DONE: config pre-push"
else
		printf '\t%s\n' "💔 FAIL"
fi
