#!/bin/bash

###USER SETINGS###
minishell_dir=../42-minishell-lexer/
FORCE_TRACE_OUTPUT=1
VALGRIND_LEAKS_CKECK=0

###ADVANCED SETTINGS###
RED='\033[0;31m'
GRE='\033[0;32m'
NOCOLOR='\033[0m'
VALGRIND = 'valgrind --undef-value-errors=no'

###FILES MANAGEMENT###
make minishell -C $minishell_dir > /dev/null
cp $minishell_dir/minishell .
rm -rf trace
mkdir trace

###TEST FUNCTION###
function execute_file()
{
	#-------------res-------------
	if [ $VALGRIND_LEAKS_CKECK -eq 1 ]; then
		$VALGRIND ./minishell	< tests/$@ 2> /dev/null >> tmp/res
	else
		./minishell				< tests/$@ 2> /dev/null >> tmp/res
	fi
	echo program exit status $? 1>> tmp/res

	#-------------ref-------------
	bash --posix				< tests/$@ 2> /dev/null >> tmp/ref
	echo program exit status $? 1>> tmp/ref
}

function compare_and_print()
{
	#-------------cmp-------------
	diff tmp/ref tmp/res > tmp/diff
	if [ -s tmp/diff ]; then							#error spotted
		printf "$RED[ KO ]$NOCOLOR"
		mkdir trace/$@
		echo " (please check /trace/$@/)"
		cat tmp/diff > trace/$@/diff
		cat tmp/res > trace/$@/your_output
		cat tmp/ref > trace/$@/ref_output
	elif [ $FORCE_TRACE_OUTPUT -eq 1 ]; then			#no error but force_output setting
		printf "$GRE[ OK ]$NOCOLOR"
		mkdir trace/$@
		echo " (please check /trace/$@/)"
		cat tmp/diff > trace/$@/diff
		cat tmp/res > trace/$@/your_output
		cat tmp/ref > trace/$@/ref_output
	else												#no error
		printf "$GRE[ OK ]\n$NOCOLOR"
	fi
	#-------------del-------------
	rm -rf tmp/
}

function test_file()
{
	mkdir tmp
	printf "%-20s" $@
	execute_file "$@"
	compare_and_print "$@"
}

function test_file_line_by_line()
{
	mkdir tmp
	printf "%-20s" $@

	file_len=$(cat tests/$@ | wc -l)
	for i in $(seq 1 $file_len);
	do
		sed -n "$i"p tests/$@ > tests/$@_tmp
		execute_file "$@"_tmp
	done
	compare_and_print "$@"
}

###TEST FILES###
test_file "test_echo"
test_file "test_cd"
test_file "test_expand"
test_file "test_export"
test_file "test_env"
test_file "test_redirect"
test_file "test_pipe"
test_file "test_multi"
test_file_line_by_line "test_exit"						#as exit retuns, exit file can not be run all in once. Line by line is required

rm minishell