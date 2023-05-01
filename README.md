# The world factbook data representation

[![XML](https://img.shields.io/badge/XML-XML?color=red)](https://www.w3.org/standards/xml/core)
[![XSLT](https://img.shields.io/badge/XSLT-XSLT?color=orange)](https://developer.mozilla.org/en-US/docs/Web/XSLT)
[![XSLFO](https://img.shields.io/badge/XSLFO-XSLFO?color=purple)](https://www.w3.org/wiki/Xsl-fo)
[![DTD](https://img.shields.io/badge/DTD-schema-green)](https://www.ibm.com/docs/en/data-studio/4.1.1?topic=dtds-document-type-definitions-overview)
[![RelaxNG](https://img.shields.io/badge/RelaxNG-schema-green)](https://relaxng.org)
[![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=flat&logo=javascript&logoColor=white&color=efd81e)](https://262.ecma-international.org/5.1/)
[![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=flat&logo=html5&logoColor=white)](https://html.spec.whatwg.org/multipage/)
[![CSS3](https://img.shields.io/badge/css3-%231572B6.svg?style=flat&logo=css3&logoColor=white&color=264bdc)](https://www.w3.org/Style/CSS/Overview.en.html)

## Task

-   Choose 4 states from [The world factbook](https://www.cia.gov/the-world-factbook/) and represent them in XML format.
-   Develop a DTD and RelaxNG schema to validate the structure of the XML documents.
-   Utilize XSLT to generate HTML outputs, including one page for each state and an index that features links to all pages.
-   Create a navigation menu for every subpage with CSS.
-   Use XSL-FO to generate a PDF output, featuring a single PDF for each state and an additional PDF containing all states. Include headers, footers, and page numbers.
-   Add pictures of maps and flags to both the HTML and PDF output.

## Project structure

```
src
├── author
├── DTDConcatenation
├── fop
├── generatedPdf
├── generatedWeb
│ ├── css
│ ├── html
│ └── javaScript
├── generatedXML
├── htmlParser
├── htmlSourceData
├── images
│ ├── flags
│ └── maps
├── saxon
├── scripts
├── validators
├── xslfo
└── xslt
```

The following folders are included in this project:

-   The **author** folder holds information about the author in XML format.
-   The **DTDConcatenation** folder contains a DTD file which combines all generated XML files into one.
-   The **fop** folder contains [Fop 2.6 software](https://xmlgraphics.apache.org/fop/) which can be used to convert fo files into pdf.
-   The **generatedPdf** folder consists of generated pdf files that can be created using scripts.
-   The **generatedWeb** folder, which can also be generated by scripts, includes an **HTML** folder with all generated HTML files for the web.
-   The **generatedXML** folder contains XML files representing states that can be generated by scripts.
-   The **htmlParser** folder has a Nodejs program that parses htmlData and creates an XML representation of them.
-   The **htmlSourceData** folder stores HTML pages downloaded from [The World Factbook](https://www.cia.gov/the-world-factbook/). These are source files for the HTML parser.
-   The **images** folder contains images used for both the web and PDF.
-   The **saxon** folder contains jar files for [Saxon home edition 10.3 software](https://www.saxonica.com/documentation/documentation.xml).
-   The **scripts** folder includes bash scripts for generating and validating files.
-   The **validators** folder has DTD and RelaxNG validation schemas.
-   The **xslfo** folder contains fo files for generating PDF, which can be generated by scripts.
-   The **xslt** folder contains XSLT stylesheets for transforming XML files into HTML and fo files.

## Software Requirements

The following are the software requirements for running the scripts:

-   [Linux](https://ubuntu.com/): All scripts run on bash.
-   [Nodejs](https://nodejs.org/en/): A runtime for JavaScript used by HTML parser.
-   [Npm](https://www.npmjs.com/): A package manager that should be part of Nodejs.
-   [xmllint](http://xmlsoft.org/xmllint.html): Used for DTD validation, and is the default tool in many Linux distributions.
-   [trang](https://relaxng.org/jclark/trang.html): Used for generating an rng file from rnc.
-   [Java](https://www.java.com/en/): Used by Saxon (XSLT processor).

To run all the steps at once, follow these instructions:

-   Use a bash script to generate and validate files.
-   Run all commands from the project root directory.
-   Make all scripts executable by running
    ```bash
    chmod +x src/scripts/*
    ```
-   Run the "run all" script.
    ```bash
    src/scripts/runAll.sh
    ```
-   If any XML file is invalid, rerun the script. It will recreate the files and delete the old invalid files.

## Running steps separately

Please follow these steps in the given order as they rely on each other.

### Generating XML Files

The HTML files downloaded from the internet can be converted to XML files using the htmlParser program. This program is written in JavaScript and run by Nodejs. If the src/generatedXML folder does not exist, the program will create it. However, if it already exists, the folder will be deleted and recreated. The program HTML sources are located in src/htmlSourceData. To perform this step, you need to have Nodejs and npm package manager. Run all commands from the project root directory.

You can generate the XML files automatically using the bash script or manually. To generate XML files **automatically**:

-   Make script executable by running
    ```bash
    chmod +x src/scripts/generateXML.sh
    ```
-   Run script by running
    ```bash
    src/scripts/generateXML.sh
    ```

To generate XML files **manually**:

-   Go to folder by running
    ```bash
    cd src/htmlParser
    ```
-   Download dependencies by running the following command. This will download the dependencies defined in package.json.
    ```bash
    npm install
    ```
-   Start the program by running
    ```bash
    node main.js
    ```

### Validating XML files

#### DTD Validation

To validate your XML files using DTD schema, follow the steps below:

-   The DTD schema can be found in src/validators/stateType.dtd.
-   Before proceeding, make sure to generate the XML files that you want to validate from the previous step.
-   To perform the validation process, you will need to have the software [xmllint](http://xmlsoft.org/xmllint.html) installed.
-   All commands should be run from the project root directory.
-   For **automatic validation** of all states using a bash script, follow these steps:
    -   Make the script executable by running
        ```bash
        chmod +x src/scripts/validateDTD.sh
        ```
    -   Run the script using
        ```bash
        src/scripts/validateDTD.sh
        ```
-   For **manual validation** of individual states, use the following command and replace `<xml file>` with the file that you wish to evaluate:
    ```bash
    xmllint --noout --dtdvalid src/validators/stateType.dtd src/generatedXML/<xml file>
    ```

#### RelaxNG Validation

To perform RelaxNG validation, follow these steps:

-   The RelaxNG grammar can be found in `src/validators/stateType.rnc`.
-   Before validating, you must generate the XML file.
-   This step requires the software [trang](https://relaxng.org/jclark/trang.html) and [xmllint](http://xmlsoft.org/xmllint.html).
-   Make sure to run all commands from the project root directory.
-   To **automatically validate** all states using a bash script, make the script executable by running
    ```bash
    chmod +x src/scripts/validateRelaxNG.sh
    ```
    and then run the script using
    ```bash
    src/scripts/validateRelaxNG.sh
    ```
-   To **manually validate** individual states, generate the rng file by running
    ```bash
    trang src/validators/stateType.rnc src/validators/stateType.rng
    ```
    Then validate the state by replacing `<xml file>` with the file you want to evaluate, and running
    ```bash
    xmllint --noout --relaxng src/validators/stateType.rng src/generatedXML/<xml file>
    ```

### Concatenating Generated Files into One

To concatenate generated files into one, follow these steps:

-   The DTD definition of the concatenated file can be found in `src/DTDConcatenation/concatenatedXML.xml`.
-   The resulting file will be saved in `src/generatedXML/concatenated.xml`.
-   Before starting, ensure that you have installed [xmllint](http://xmlsoft.org/xmllint.html) software.
-   All commands should be run from the project root directory.
-   **Automatic concatenation** using a bash script
    -   First, make the script executable by running
        ```bash
        chmod +x src/scripts/concatenateStates.sh
        ```
    -   Then, run the script using
        ```bash
        src/scripts/concatenateStates.sh
        ```
-   **Manual concatenation**
    -   Run the following command:
        ```bash
        xmllint --noent src/DTDConcatenation/concatenateXML.xml > src/generatedXML/concatenated.xml
        ```

### Generating HTML Files

-   To generate HTML files, you must use XSLT style sheets src/xslt/htmlHomePage.xsl and src/xslt/htmlSateStyle.xsl with XML files in src/generatedXML.
-   Once generated, the files will be available in src/generatedWeb/html.
-   This process requires [Java](https://www.java.com/en/), and all commands must be run from the project root directory.

**Automatic generation** using bash script

-   Make the script executable by running
    ```bash
    chmod +x src/scripts/generateWeb.sh
    ```
-   Run the script by running
    ```bash
    src/scripts/generateWeb.sh
    ```

**Manual generation**

-   Create a directory for output by running
    ```bash
    mkdir -p src/generatedWeb/html > /dev/null 2>&1
    ```
-   Generate the index by running
    ```bash
    java -jar src/saxon/saxon-he-10.3.jar src/generatedXML/concatenated.xml src/xslt/htmlHomePageStyle.xsl > src/generatedWeb/html/index.html
    ```
-   Generate the states by running the following command. Remember to replace `<state>` with the name of the state (for example, France or Germany).

    ```bash
    java -jar src/saxon/saxon-he-10.3.jar src/generatedXML/<state>.xml src/xslt/htmlStateStyle.xsl > src/generatedWeb/html/<state>.html
    ```

### Generating PDF files

-   PDFs are generated from src/xslfo/\*.fo files
-   src/xslfo/\*.fo files are generated from XML files located in src/generatedXML using src/xslt/pdf\*.xsl stylesheets
-   Generated pdf files will be in the src/generatedPdf folder.
-   This step requires the fop software, which I included in the src/fop directory.
-   All commands should be run from the project root directory.
-   **Automatic generation** using a bash script
    -   Make the script executable by running
        ```bash
        chmod +x src/scripts/generatePdf.sh
        ```
    -   Run the script by running
        ```bash
        src/scripts/generatePdf.sh'
        ```
-   **Manual generation**
-   Create the output directory by running the following command
    ```bash
    mkdir -p src/generatedPdf > /dev/null 2>&1` `mkdir -p src/xslfo > /dev/null 2>&1
    ```
-   Generate fo file from all the states (Germany, UK, Switzerland, France)
    ```bash
    java -jar src/saxon/saxon-he-10.3.jar src/generatedXML/concatenated.xml src/xslt/pdfAllStatesStyle.xsl > src/xslfo/allStates.fo
    ```
-   Generate fo file for single state and don't forget to replace `<state>` by the actual name of the state.
    ```bash
    java -jar src/saxon/saxon-he-10.3.jar src/generatedXML/<state>.xml src/xslt/pdfStateStyle.xsl > src/xslfo/<state>.fo
    ```
-   Generate pdf file of all the states
    ```bash
    src/fop/fop/fop src/xslfo/allStates.fo src/generatedPdf/allStates.pdf
    ```
-   Generate pdf file of single state. The `<state>` should be replaced by the actual name of the state.
    ```bash
    src/fop/fop/fop src/xslfo/<state>.fo src/generatedPdf/<state>.pdf
    ```

### Sources

http://saxon.sourceforge.net/ <br/>
https://relaxng.org/jclark/trang.html <br/>
https://relaxng.org/compact-tutorial-20030326.html <br/>
https://www.w3schools.com/xml/default.asp <br/>
https://www.w3schools.com/xml/xpath_intro.asp <br/>
https://www.w3schools.com/xml/xsl_intro.asp <br/>
https://www.w3schools.com/xml/xml_dtd_intro.asp <br/>
http://zvon.org/comp/r/tut-XSLT_1.html <br/>
https://www.youtube.com/watch?v=W--Yhp0m35A <br/>
https://www.youtube.com/watch?v=D2YzF4hm9NM <br/>
https://undraw.co/illustrations <br/>
https://fonts.google.com/ <br/>
https://fontawesome.com/account <br/>
https://w3schools.sinsixx.com/xslfo/xslfo_lists.asp.htm <br/>
https://xmlgraphics.apache.org/fop/<br/>
https://www.kosek.cz/xml/schema/rng.html
