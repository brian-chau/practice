#!/bin/bash

echo Cleaning directory
make clean 1>/dev/null 2>&1

echo Preparing to test...
make test 1>/dev/null 2>&1

echo Running the test!
{ err=$(./exe_test 2>&1 >&3 3>&-); } 3>&1
status=Pass
if [[ $err == *"TEST FAILED"* ]]; then
    echo Test failed!
    status=Fail
else
    echo Test passed!
fi

echo Generating code coverage...
lcov --capture --directory ./sources --output-file ./TestResults/main_coverage.info 1>/dev/null 2>&1
lcov --remove ./TestResults/main_coverage.info -o ./TestResults/main_filtered.info '/usr/include/*' '/usr/include/x86_64-linux-gnu/*' '/usr/lib/*' '/usr/local/*' '/11/*' 1>/dev/null 2>&1
genhtml ./TestResults/main_filtered.info --output-directory ./TestResults/CodeCoverage > ./TestResults/lcov_results.txt
cat ./TestResults/lcov_results.txt | grep -A 3 "Overall coverage rate:"

echo Generating badges...
string_line_code_coverage=$(grep -oP "(?<=lines\.\.\.\.\.\.: )\S+(?=\% \(\d+ of \d+ lines\))" ./TestResults/lcov_results.txt)
string_fxn_code_coverage=$(grep -oP "(?<=functions\.\.: )\S+(?=\% \(\d+ of \d+ functions\))" ./TestResults/lcov_results.txt)
int_line_code_coverage=$(printf '%.0f\n' $string_line_code_coverage)
int_fxn_code_coverage=$(printf '%.0f\n' $string_fxn_code_coverage)
./BadgeGenerator/generate_badges -result $status -linecov $int_line_code_coverage -fxncov $int_fxn_code_coverage

while true; do
    read -p "Display detailed code coverage? (y\N): " yn
    case $yn in
        [Yy]* ) cd TestResults/CodeCoverage && env BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe" sensible-browser "index.html" && cd - 1>/dev/null 2>&1; break;;
        [Nn]* ) break;;
        * ) echo "Invalid selection.";;
    esac
done

make clean 1>/dev/null 2>&1