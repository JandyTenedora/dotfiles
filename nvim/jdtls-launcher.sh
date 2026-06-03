#!/usr/bin/env bash
export JAVA_HOME="$HOME/.sdkman/candidates/java/21.0.7-tem"
exec python3 "$HOME/.local/share/nvim/mason/packages/jdtls/bin/jdtls" "$@"
