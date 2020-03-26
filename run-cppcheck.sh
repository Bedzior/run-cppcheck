#!/bin/sh
set -x

split_join_lines() {
    prefix=$2
    output=''
    IFS=', ' read -r -a array <<< "$1"
    for line in array; do
        output="${output:+ }$prefix$line"
    done
    echo "$output"
}

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
    -j "$(nproc)" \
    --xml \
    "$(split_join_lines "$INPUT_INCLUDES" '-I')" \
    "$(split_join_lines "$INPUT_EXCLUDES" '-i')"

if [ $GENERATEREPORT ]; then
    cppcheck-htmlreport \
        --file=$REPORT_FILE \
        --title="$INPUT_REPORTNAME" \
        --report-dir=output
fi
