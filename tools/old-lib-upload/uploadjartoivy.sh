#!/bin/bash

sourceHost=127.0.0.1
isSingleFile=0
baseDir=~/ivyrepository
module=
revision=
organisation=old.robot
resolver=shared
singleFile=

while [ 0 -ne $# ]; do
    case $1 in
        -h) # source host
            if [ 1 -lt $# ]; then
                shift
                sourceHost=$1
            fi;;
        -b) # is publish single file.
            if [ 1 -lt $# ]; then
                shift
                baseDir=$1
            fi;;
        -o) # organisation name
            if [ 1 -lt $# ]; then
                shift
                organisation=$1
            fi;;
        -m) # module name
            isSingleFile=1;
            if [ 1 -lt $# ]; then
                shift
                module=$1
            fi;;
        -f) # module name
            isSingleFile=1;
            if [ 1 -lt $# ]; then
                shift
                singleFile=$1
            fi;;
        -r) # revision
            isSingleFile=1;
            if [ 1 -lt $# ]; then
                shift
                revision=$1
            fi;;
        -e) # resolver
            if [ 1 -lt $# ]; then
                shift
                resolver=$1
            fi;;
        *) ;;
    esac
    shift
done

upload() {
    #organisation=`echo $i | awk '{print $1}'`
    #module=`echo $i | awk '{print $2}'`
    #revision=`echo $i | awk '{print $3}'`

    cp $baseDir/$module-$revision.jar ./
    if [ -f $module-$revision.jar ]; then
        cp ./ivy.xml.template ./ivy.xml
        cp ./build.xml.template ./build.xml
        sed -i "s:#organisation#:$organisation:" ./ivy.xml
        sed -i "s:#module#:$module:g" ./ivy.xml
        sed -i "s:#revision#:$revision:g" ./ivy.xml

        sed -i "s:#organisation#:$organisation:" ./build.xml
        sed -i "s:#revision#:$revision:g" ./build.xml
        sed -i "s:#name#:$module:g" ./build.xml
        sed -i "s:#resolver#:$resolver:g" ./build.xml
        ant resolve install
        echo INFO: $baseDir/$module-$revision.jar is found!
    else
        echo ERROR: $baseDir/$module-$revision.jar is no found!
    fi


    if [ -f build.xml ]; then rm -f build.xml; fi
    if [ -f ivy.xml ]; then rm -f ivy.xml; fi
    if [ -f $module-$revision.jar ]; then rm -f $module-$revision.jar; fi
    if [ -f ivy-$revision.xml ]; then rm -f ivy-$revision.xml; fi
    

}

if [ 0 -eq $isSingleFile ]; then
    while read i; do
	organisation=`echo $i | awk '{print $1}'`
	module=`echo $i | awk '{print $2}'`
	revision=`echo $i | awk '{print $3}'`

	upload $organisation $module $revision
    done < ./upload.txt
else
    upload $organisation $module $revision
fi
