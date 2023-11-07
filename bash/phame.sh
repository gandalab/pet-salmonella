#!/bin/bash

# --- MODIFY PATHS ---
OUT=/path/to/output
PHAME=/path/to/phame_env/PhaME/src

cd ${DIR}

#run phame
${PHAME}/phame phame.ctl

echo "phame complete"