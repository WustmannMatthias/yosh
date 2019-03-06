#!/bin/bash

# main file

#set -x

# use autoloader
source /usr/share/yosh/autoloader.sh

_exit() {
    # Send header

    ! [[ -z "$access_control_allow_origin" ]] && Http::send::header Access-Control-Allow-Origin "${access_control_allow_origin:-*}"
    Http::send::out

    # send data from route
    [[ -s "$tmpStdout" ]] && cat $tmpStdout
    if [[ -s "$tmpStderr" ]]; then
#        Log::stack::trace
        @error "$(<$tmpStderr)"
    fi

    Log::print::error::array
    Mktemp::remove::public::all
}


set -o errtrace
#set -e
trap 'Log::stack::trace' ERR

# Clean TMP file on exit
trap '_exit' EXIT

# redirect stdout and stderr of function to file, to print after
tmpStdout="$(Mktemp::create)"
tmpStderr="$(Mktemp::create)"

# get GET and POST and COOKIE variable
Http::read::get
Http::read::post
Http::read::cookie

# check if application.sh exist
[[ -f "${DOCUMENT_ROOT%/}/../application.sh" ]] && source ${DOCUMENT_ROOT%/}/../application.sh

# Save stdout and stderr to a file, to print out the both
# route::check 1>$tmpStdout 2>$tmpStderr
Route::check 1>$tmpStdout 2>$tmpStderr

# exit like a pro
# TRAP will now do the job
exit

