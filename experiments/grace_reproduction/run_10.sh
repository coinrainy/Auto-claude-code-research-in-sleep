#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
GRACE_ROOT="${GRACE_ROOT:-${REPO_ROOT}/../GRACE}"
DATA_ROOT="${DATA_ROOT:-/root/autodl-tmp/G-02-baseline-data/pyg}"
PYTHON_BIN="${PYTHON_BIN:-${REPO_ROOT}/../.venv-g02/bin/python}"
RESULT_ROOT="${RESULT_ROOT:-${SCRIPT_DIR}/results}"

if [[ ! -x "${PYTHON_BIN}" ]]; then
  PYTHON_BIN=python
fi

if [[ ! -f "${GRACE_ROOT}/train.py" ]]; then
  echo "GRACE checkout not found: ${GRACE_ROOT}" >&2
  exit 2
fi

"${PYTHON_BIN}" "${GRACE_ROOT}/train.py" \
  --dataset Cora \
  --gpu_id 0 \
  --config "${GRACE_ROOT}/config.yaml" \
  --data_root "${DATA_ROOT}" \
  --runs 10 \
  --epochs 200 \
  --progress_every 50 \
  --output_dir "${RESULT_ROOT}/cora_1_1_8_10run" \
  --resume

"${PYTHON_BIN}" "${GRACE_ROOT}/train.py" \
  --dataset CiteSeer \
  --gpu_id 0 \
  --config "${GRACE_ROOT}/config.yaml" \
  --data_root "${DATA_ROOT}" \
  --runs 10 \
  --epochs 200 \
  --progress_every 50 \
  --output_dir "${RESULT_ROOT}/citeseer_1_1_8_10run" \
  --resume
