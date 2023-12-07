#!/bin/bash

# --- MODIFY PATHS ---
DIR=/path/to/phame.ctl #will also be path to where output is written
PHAME=/path/to/phame_env/PhaME/src

cd ${DIR}

#run phame
${PHAME}/phame phame.ctl

echo "phame complete"