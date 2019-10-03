#!/bin/bash
set -e

echo "Running $1"

if [ "$1" == "tests" ]; then
    echo 1
    psql -c 'create database byro;' -U postgres
    echo 2
    python -m byro check
    echo 3
    pytest --cov=byro tests
    echo 4
    codecov
fi

if [ "$1" == "style" ]; then
    if [  $(python -c "import sys; print(sys.version_info[1])") -gt 5 ]; then
        pip install ".[dev]"
        echo 5
        isort --check-only --recursive --diff .
        echo 6
        black --check .
    fi
fi

if [ "$1" == "docs" ]; then
    cd ../docs
    echo 7 
    pip install -r requirements.txt
    echo 8
    make html
    echo 9
    make linkcheck
    echo 10
    npm install -g write-good
    echo 11
    write-good **/*.rst --no-passive --no-adverb || true
fi
