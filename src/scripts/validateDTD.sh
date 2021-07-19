#!/bin/bash

# this script validate all states in generated files by DTD scheme using xmllit

echo "VALIDATE DTD SCHEMA"
echo ""

for state in france germany switzerland united-kingdom; do
  # --noout = don't output the result tree
  # usage: xmllitn --dtdvalid <schema.dtd> <file.xml>
  if xmllint --noout --dtdvalid src/validators/stateType.dtd src/generatedXML/$state.xml; then
    echo "$state.xml is valid"
  else
    echo "$state.xml is NOT valid!!!"
  fi
done
