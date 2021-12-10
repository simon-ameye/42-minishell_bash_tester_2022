#!/bin/bash

minishell_dir=../42-minishell-lexer/

RED='\033[0;31m'
GRE='\033[0;32m'
NOCOLOR='\033[0m'

make minishell -C $minishell_dir > /dev/null
cp $minishell_dir/minishell .
rm -rf trace
mkdir trace

function test()
{
	mkdir tmp
	printf "%-20s" $@

	#-------------res-------------
	./minishell		< tests/$@ 2> /dev/null > tmp/res
	echo exit status $? 1>> tmp/res

	#-------------ref-------------
	bash --posix	< tests/$@ 2> /dev/null > tmp/ref
	echo exit status $? 1>> tmp/ref

	#-------------cmp-------------
	diff tmp/ref tmp/res > tmp/diff
	if [ -s tmp/diff ]; then 
		printf "$RED[ KO ]$NOCOLOR"
		mkdir trace/$@
		echo " (please check your trace in /trace/$@/)"
		cat tmp/diff > trace/$@/diff
		cat tmp/res > trace/$@/your_output
		cat tmp/ref > trace/$@/ref_output
	else
		printf "$GRE[ OK ]\n$NOCOLOR"
	fi
	#-------------del-------------
	rm -rf tmp/
}

test "test_echo"
test "test_cd"
test "test_expand"
test "test_export"
test "test_env"
test "test_redirect"
test "test_exit"
test "test_pipe"
test "test_multi"

rm minishell