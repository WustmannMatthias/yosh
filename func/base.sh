#!/bin/bash

# convert array to json
function array-to-json ()
{
    local array="$1"

    [[ -z "$array" ]] && return

    # redefine array name
    typeset -n array="$array"

    # this function generate an json from an array
    # jq using from FAQ mentioned by CharlesDuffy

    for key in "${!array[@]}"
    do
            printf '%s\0%s\0' "$key" "${array[$key]}"
    done | jq -c -Rs -S '
                split("\u0000")
                | . as $a
                | reduce range(0; length/2) as $i 
                ({}; . + {($a[2*$i]): ($a[2*$i + 1]|fromjson? // .)})'

}

# Json to array
function json-to-array ()
{
    local arrayname="$1" json="${@:2}"

    while read -r key
    do
        declare -gA ${arrayname}[$key]="$(echo "$json" | jq -r .$key)"
    done < <(echo "$json" | jq -r 'keys[]')
}

# trim a variable
function trim ()
{
    local variable="$1" new_variable

    [[ -z "$variable" ]] && return
    
    typeset -n new_variable="$variable"
    new_variable="${new_variable% }"
    new_variable="${new_variable# }"

    declare -g ${variable}="$new_variable"
}

# decode url
function url_decode ()
{
    local value="$1"
    value="${value//+/ }"
    value="${value//%/\\x}"
    
    echo -e "$value"
}