#!/bin/bash

# Define the base directory (projects/10)
BASE_DIR="../10"

# Define the TextComparer path
TEXTCOMPARER="../tools/TextComparer.sh"

# Loop through each directory inside the base directory (projects/10)
for PROJECT_DIR in $(find $BASE_DIR -mindepth 1 -maxdepth 1 -type d)
do
    echo "=============================================================="
    echo "Processing directory: $PROJECT_DIR"

    # Run JackAnalyzer to compile the .jack files and generate XML files
    echo "Running JackAnalyzer to process the .jack files in $PROJECT_DIR..."
    python3 ../10/JackAnalyzer.py "$PROJECT_DIR"
    echo "JackAnalyzer is done for $PROJECT_DIR."
    echo

    # Loop through each .jack file in the directory
    for JACK_FILE in $(find "$PROJECT_DIR" -type f -name "*.jack")
    do
        # Extract the base filename (without the extension)
        BASE_NAME=$(basename "$JACK_FILE" .jack)

        # Check if the corresponding XML files exist
        if [ -f "$PROJECT_DIR/$BASE_NAME.xml" ] && [ -f "$PROJECT_DIR/${BASE_NAME}_Test.xml" ]; then
            # Compare the corresponding _test files with the original files
            echo "Comparing ${BASE_NAME}_Test.xml and ${BASE_NAME}.xml..."
            $TEXTCOMPARER "$PROJECT_DIR/${BASE_NAME}_Test.xml" "$PROJECT_DIR/${BASE_NAME}.xml"
            echo "Comparison done for ${BASE_NAME}."

        else
            echo "Error: Missing ${BASE_NAME}_Test.xml or ${BASE_NAME}.xml in $PROJECT_DIR"
        fi

        echo

        # Check if the corresponding T_XML files exist
        if [ -f "$PROJECT_DIR/${BASE_NAME}T.xml" ] && [ -f "$PROJECT_DIR/${BASE_NAME}T_Test.xml" ]; then
            # Compare the corresponding _test files with the T XML files
            echo "Comparing ${BASE_NAME}T_Test.xml and ${BASE_NAME}T.xml..."
            $TEXTCOMPARER "$PROJECT_DIR/${BASE_NAME}T_Test.xml" "$PROJECT_DIR/${BASE_NAME}T.xml"
            echo "Comparison done for ${BASE_NAME}T."

        else
            echo "Error: Missing ${BASE_NAME}T_Test.xml or ${BASE_NAME}T.xml in $PROJECT_DIR"
        fi
        echo
    done
done
