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
elif [ "$INPUT_PATH" = 'true' ]; then
    TARGET="$INPUT_PATH"
elif [ "$INPUT_PROJECT" = 'true' ]; then
    TARGET="--project=$INPUT_PROJECT"
fi

if [ ! "$INPUT_ROOT" ]; then
    INPUT_ROOT=$(pwd)
fi

if [ ! "$INPUT_VERBOSE" = 'true' ]; then
    unset INPUT_VERBOSE
fi

if [ "$INPUT_GENERATE_REPORT" = 'true' ]; then
    REPORT_FILE=report.xml
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
    cppcheck-htmlreport \
        --file="$REPORT_FILE" \
        --title="$INPUT_REPORT_NAME" \
        --report-dir=output
fi
