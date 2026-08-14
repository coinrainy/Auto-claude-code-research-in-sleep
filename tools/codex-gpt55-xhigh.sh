#!/usr/bin/env bash
set -euo pipefail

for arg in "$@"; do
    case "$arg" in
        -m|--model|--model=*)
            echo "error: model is pinned to gpt-5.5 by this project wrapper" >&2
            exit 2
            ;;
    esac
done

exec codex --model gpt-5.5 -c 'model_reasoning_effort="xhigh"' "$@"
