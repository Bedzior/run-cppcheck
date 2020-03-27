#!/bin/sh

if [ "$INPUT_DEBUG" = 'true' ]; then
    set -x
    CHECK_CONFIG='yep'
fi

if [ "$INPUT_VERBOSE" = 'true' ]; then
    VERBOSE='yep'
fi

if [ "$INPUT_GENERATE_REPORT" = 'true' ]; then
    GENERATE_REPORT='yep'
    REPORT_FILE=report.xml
fi

if [ "$INPUT_ENABLED_INCONCLUSIVE" = 'true' ]; then
    ENABLE_INCONCLUSIVE='yep'
fi

cppcheck "$INPUT_PATH" \
    --enable="$INPUT_ENABLED_CHECKS" \
    ${ENABLE_INCONCLUSIVE:+--inconclusive} \
    ${GENERATE_REPORT:+--output-file=$REPORT_FILE} \
    ${VERBOSE:+--verbose} \
    ${CHECK_CONFIG:+--check-config} \
    -j "$(nproc)" \
    --xml \
    "$INPUT_INCLUDES" \
    "$INPUT_EXCLUDES"

if [ "$GENERATE_REPORT" ]; then
    cppcheck-htmlreport \
        --file="$REPORT_FILE" \
        --title="$INPUT_REPORT_NAME" \
        --report-dir=output
fi
