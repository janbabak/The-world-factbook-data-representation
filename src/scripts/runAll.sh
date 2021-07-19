#!/bin/bash

echo "RUN ALL"
echo "----------------------------------------------------"

# generate xml
if ! src/scripts/generateXML.sh; then
    exit 1
fi
echo "----------------------------------------------------"

# validate DTD
if ! src/scripts/validateDTD.sh; then
    exit 1
fi
echo "----------------------------------------------------"

# validate Relaxng
if ! src/scripts/validateRelaxNG.sh; then
    exit 1
fi
echo "----------------------------------------------------"

# concatenate xml by DTD
if ! src/scripts/concatenateStates.sh; then
    exit 1
fi
echo "----------------------------------------------------"

# generate web
if ! src/scripts/generateWeb.sh; then
    exit 1
fi
echo "----------------------------------------------------"

# generate pdf
if ! src/scripts/generatePdf.sh; then
    exit 1
fi