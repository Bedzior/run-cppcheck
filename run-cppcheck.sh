#!/bin/sh

split_join_lines() {
    prefix=$2
    output=''
    echo "$1" | while read line
    do
        output="$output $prefix$line"
    done
    echo output
}

if [ "$INPUT_GENERATEREPORT" = 'true' ]; then
    GENERATEREPORT='yep'
    REPORT_FILE=report.xml
fi

cppcheck src \
    --enable="$INPUT_ENABLEDCHECKS" \
    ${INPUT_ENABLEDINCONCLUSIVE:+--inconclusive} \
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
