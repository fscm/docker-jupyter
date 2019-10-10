#!/bin/sh
#
# Shell script to test the Jupyter Docker image.
#
# Copyright 2016-2019, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

# Variables

echo "=== Docker Build Test ==="

echo -n "[TEST] Check if Python is installed... "
python --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 1
fi

echo -n "[TEST] Check if PIP is installed... "
pip --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 2
fi

echo -n "[TEST] Check if PIP can install modules... "
pip install --upgrade test-pip-install &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 3
fi

echo -n "[TEST] Check if PIP installed binaries into 'PATH'... "
test-pip-install &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 4
fi

echo -n "[TEST] Check if Python can find installed modules... "
python -m test_pip_install &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 5
fi

echo -n "[TEST] Check if Jupyter is installed... "
jupyter --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 6
fi

echo -n "[TEST] Check if JupyterLab is installed... "
jupyter-lab --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  echo 'OK'
else
  echo 'Failed'
  exit 7
fi

exit 0
