#!/bin/bash
set -e
set -x 

echo "Running $1"

if [ "$1" == "tests" ]; then
    psql -c 'create database byro;' -U postgres
    python -m byro check
    pytest --cov=byro tests
    codecov
fi

if [ "$1" == "style" ]; then
    if [  $(python -c "import sys; print(sys.version_info[1])") -gt 5 ]; then
        pip install ".[dev]"
        isort --check-only --recursive --diff .
        black --check .
    fi
fi

if [ "$1" == "docs" ]; then
    cd ../docs
    pip install -r requirements.txt
    make html
    make linkcheck
    npm install -g write-good
    write-good **/*.rst --no-passive --no-adverb || true
fi
