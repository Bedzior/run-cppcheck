#!/bin/bash
set -x

split_join_lines() {
    output=''
    readarray -t lines <<<"$1"
    printf -v output "$2%s " "${lines[@]}"
    echo "$output"
}

if [[ "$INPUT_GENERATEREPORT" == 'true' ]]; then
    GENERATEREPORT='yep'
    REPORT_FILE=report.xml
fi

if [[ "$INPUT_ENABLEDINCONCLUSIVE" == 'true' ]]; then
    ENABLEINCONCLUSIVE='yep'
fi

cppcheck src \
    --enable="$INPUT_ENABLEDCHECKS" \
    ${ENABLEINCONCLUSIVE:+--inconclusive} \
    ${GENERATEREPORT:+--output-file=$REPORT_FILE} \
    -j "$(nproc)" \
    --xml \
    "$(split_join_lines "$INPUT_INCLUDES" '\055I')" \
    "$(split_join_lines "$INPUT_EXCLUDES" '\055i')"

if [ $GENERATEREPORT ]; then
    cppcheck-htmlreport \
        --file=$REPORT_FILE \
        --title="$INPUT_REPORTNAME" \
        --report-dir=output
fi
