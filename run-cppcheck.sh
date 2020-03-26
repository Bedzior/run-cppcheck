#!/bin/sh


function split_join_lines {
    local IFS=$'\n'
    local lines=($1)
    local i
    local prefix=$2
    local output=''
    for (( i=0; i<${#lines[@]}; i++ )) ; do
        output="$output $prefix${lines[$i]}"
    done
    echo output
}

if [[ $INPUT_GENERATEREPORT == 'true']]; then
    GENERATEREPORT='yep'
    REPORT_FILE=report.xml
fi

cppcheck src \
    --enable=$INPUT_ENABLEDCHECKS \
    ${INPUT_ENABLEDINCONCLUSIVE:+--inconclusive} \
    ${GENERATEREPORT:+--output-file=$REPORT_FILE} \
    -j `nproc` \
    --xml \
    `split_join_lines $INPUT_INCLUDES '-I' \
    `split_join_lines $INPUT_EXCLUDES '-i'

if [[ $GENERATEREPORT ]]; then
    cppcheck-htmlreport \
        --file=$REPORT_FILE \
        --title=$INPUT_REPORTNAME \
        --report-dir=output
fi
