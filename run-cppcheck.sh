#!/bin/sh

if [ ! "$INPUT_DEBUG" = 'true' ]; then
    unset INPUT_DEBUG
else
    set -x
    CHECK_CONFIG=true
fi

if [ ! "$INPUT_PATH" ] && [ ! "$INPUT_PROJECT" ]; then
    echo Parameter 'path' or 'project' required
    exit 1
elif [ "$INPUT_PROJECT" ]; then
    TARGET="--project=$INPUT_PROJECT"
elif [ "$INPUT_PATH" ]; then
    TARGET="$INPUT_PATH"
fi

if [ ! "$INPUT_ROOT" ]; then
    INPUT_ROOT="$(pwd)"
fi

if [ ! "$INPUT_VERBOSE" = 'true' ]; then
    unset INPUT_VERBOSE
fi

if [ "$INPUT_GENERATE_REPORT" = 'true' ]; then
    REPORT_FILE="report.xml"
    echo "::set-output name=reportPath::${REPORT_FILE}"
else
    unset INPUT_GENERATE_REPORT
fi

if [ ! "$INPUT_ENABLE_INCONCLUSIVE" = 'true' ]; then
    unset INPUT_ENABLE_INCONCLUSIVE
fi

cppcheck "$TARGET" \
    ${CHECK_CONFIG:+--check-config} \
    --enable="$INPUT_ENABLED_CHECKS" \
    ${INPUT_ENABLE_INCONCLUSIVE:+--inconclusive} \
    ${INPUT_GENERATE_REPORT:+--output-file=$REPORT_FILE} \
    ${INPUT_VERBOSE:+--verbose} \
    -rp="$INPUT_ROOT" \
    -j "$(nproc)" \
    --xml \
    "$INPUT_INCLUDE_DIRECTORIES" \
    "$INPUT_EXCLUDE_FROM_CHECK"

if [ "$INPUT_GENERATE_REPORT" ]; then
    REPORT_DIR="output"
    cppcheck-htmlreport \
        --file="$REPORT_FILE" \
        --title="$INPUT_REPORT_NAME" \
        --report-dir="$REPORT_DIR"
    echo "::set-output name=htmlReportPath::$REPORT_DIR"
fi
