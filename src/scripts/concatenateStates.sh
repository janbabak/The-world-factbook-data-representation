#!/bin/bash

# this script create one xml file from all xml files using dtd

INPUT_DIR=src/DTDConcatenation
OUTPUT_DIR=src/generatedXML

echo "CONCATENATE FILES"
echo ""

# --noent : substitute entity references by their value
if xmllint --noent $INPUT_DIR/concatenateXML.xml > $OUTPUT_DIR/concatenated.xml; then
    echo "success"
else
    echo "failed"
    exit 1
fi
