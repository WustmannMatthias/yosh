#!/bin/bash

nom=sofo
var=nom
foo='$'$var

echo "sans eval $foo"

eval foo='$'$var

echo "après eval $foo"
