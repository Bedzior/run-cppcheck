#!/bin/sh

REPORT_FILE=report.xml

cppcheck src \
    --enable=$INPUT_ENABLEDCHECKS \
    ${INPUT_ENABLEDINCONCLUSIVE:+--inconclusive} \
    --output-file=$REPORT_FILE \
    -j `nproc` \
    --xml $INPUT_EXCLUDES $INPUT_INCLUDES

cppcheck-htmlreport \
    --file=$REPORT_FILE \
    --title=$INPUT_REPORTNAME \
    --report-dir=output
