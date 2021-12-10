#!/bin/bash

minishell_dir=../42-minishell-lexer/

make minishell -C $minishell_dir > /dev/null
cp $minishell_dir/minishell .

function test()
{
	echo ------------------$@------------------
	#-------------res-------------
	mkdir tmp
	./minishell		< $@ 2> /dev/null > tmp/res
	echo exit status $? 1>> tmp/res

	#-------------ref-------------
	bash			< $@ 2> /dev/null > tmp/ref
	echo exit status $? 1>> tmp/ref

	#-------------cmp-------------
	diff tmp/ref tmp/res

	#-------------del-------------
	rm -rf tmp/

}

test "test_echo"
test "test_cd"
test "test_pipe"
test "test_expand"
test "test_export"
test "test_redirect"
test "test_exit"
test "test_multi"

rm minishell