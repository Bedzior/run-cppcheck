#!/bin/sh

if [ "$INPUT_DEBUG" = 'true' ]; then
    set -x
    CHECK_CONFIG='yep'
fi

if [ "$INPUT_VERBOSE" = 'true' ]; then
    VERBOSE='yep'
fi

if [ "$INPUT_GENERATEREPORT" = 'true' ]; then
    GENERATEREPORT='yep'
    REPORT_FILE=report.xml
fi

if [ "$INPUT_ENABLEDINCONCLUSIVE" = 'true' ]; then
    ENABLEINCONCLUSIVE='yep'
fi

cppcheck src \
    --enable="$INPUT_ENABLEDCHECKS" \
    ${ENABLEINCONCLUSIVE:+--inconclusive} \
    ${GENERATEREPORT:+--output-file=$REPORT_FILE} \
    ${VERBOSE:+--verbose} \
    ${CHECK_CONFIG:+--check-config}
    -j "$(nproc)" \
    --xml \
    "$INPUT_INCLUDES" \
    "$INPUT_EXCLUDES \


if [ $GENERATEREPORT ]; then
    cppcheck-htmlreport \
        --file=$REPORT_FILE \
        --title="$INPUT_REPORTNAME" \
        --report-dir=output
fi
