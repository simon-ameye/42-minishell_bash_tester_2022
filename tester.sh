#!/bin/bash

###USER SETINGS###
minishell_dir=../42-minishell-lexer/
FORCE_TRACE_OUTPUT=1
VALGRIND_LEAKS_CKECK=0

###ADVANCED SETTINGS###
RED='\033[0;31m'
GRE='\033[0;32m'
NOCOLOR='\033[0m'
VALGRIND="valgrind --undef-value-errors=no --log-file=tmp/valgrind --leak-check=full --show-leak-kinds=all"

###FILES MANAGEMENT###
make minishell -C $minishell_dir > /dev/null
cp $minishell_dir/minishell .
rm -rf trace
rm -rf tmp
mkdir -p trace
mkdir -p tmp

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

function save_outputs()
{
	mkdir -p trace/$@
	cat tmp/diff > trace/$@/diff
	cat tmp/res > trace/$@/your_output
	cat tmp/ref > trace/$@/ref_output
}

function save_valgrind()
{
	mkdir -p trace/$@
	cat tmp/valgrind > trace/$@/valgrind
}

function compare_and_print()
{
	#-------------cmp-------------
	diff tmp/ref tmp/res > tmp/diff
	if [ -s tmp/diff ]; then							#error spotted
		printf "$RED[ KO ]$NOCOLOR"
		save_outputs "$@"
	elif [ $FORCE_TRACE_OUTPUT -eq 1 ]; then			#no error but force_output setting
		printf "$GRE[ OK ]$NOCOLOR"
		save_outputs "$@"
	else												#no error
		printf "$GRE[ OK ]$NOCOLOR"
	fi

	if [ $VALGRIND_LEAKS_CKECK -eq 1 ]; then
		if [ -s tmp/valgrind ]; then
			printf "$RED[ LEAK KO ]$NOCOLOR"
			save_valgrind $@
		else
			printf "$GRE[ LEAK OK ]$NOCOLOR"
		fi
	fi

	if [ -d "trace/$@" ]; then
		echo -n " (please check /trace/$@/)"
	fi
	echo
	#-------------del-------------
	rm -rf tmp/
}

function test_file()
{
	mkdir -p tmp
	printf "%-20s" $@
	execute_file "$@"
	compare_and_print "$@"
}

function test_file_line_by_line()
{
	mkdir -p tmp
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
test_file				"test_echo"
test_file				"test_cd"
test_file				"test_expand"
test_file				"test_export"
test_file				"test_env"
test_file				"test_redirect"
test_file				"test_pipe"
test_file				"test_multi"
test_file				"test_heredoc"
#test_file_line_by_line	"test_signals"
test_file_line_by_line	"test_exit"						#as exit retuns, exit file can not be run all in once. Line by line is required

#rm minishell