#!/bin/bash
Path="./sample_test_cases"

Build_and_Execute () {
    ProblemNumber="`find ./ -maxdepth 1 -name '*.cpp' -type f -print -quit | grep -Po '\d+'`"
    if g++ -fdiagnostics-color=always -pedantic-errors -std=c++11 -g ${ProblemNumber}.cpp -o ${ProblemNumber}
    then
        for file in `ls ${Path} | grep input`
        do
            if [ -f ${Path}/${file} ]
            then
                Number="`ls ${Path}/${file} | grep -Po '\d+_\d+'`"
                ./$ProblemNumber < ${Path}/input${Number}.txt > myoutput${Number}.txt
                if diff myoutput${Number}.txt ${Path}/output${Number}.txt 1>/dev/null 2>&1
                then
                    echo Testcase ${Number} Passed
                    rm myoutput${Number}.txt
                else
                    echo Testcase ${Number} Failed
                    diff --color myoutput${Number}.txt ${Path}/output${Number}.txt 
                fi
            fi
        done
    else
        echo "g++ Compile failed!"
    fi
}

if [ -e ./*.cpp ] && [ -e ${Path} ]
then
    Build_and_Execute
else
    for dir in `ls`
    do
        if test -d $dir
        then
            cd ./$dir
            if [ -e ./*.cpp ] && [ -e ${Path} ]
            then
                echo Problem `echo ${dir} | grep -Po '\d+'`:
                Build_and_Execute
                echo
            fi
            cd ../
        fi
    done
fi