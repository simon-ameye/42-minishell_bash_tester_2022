#!/bin/bash

make minishell -C ../ > /dev/null
cp ../minishell .

function test()
{
	echo $@ > input

	./minishell < input > out1 2> out2

#	tail -n +2 out1 > tmp1 # remove first line
#	head -n -1 tmp1 > out1 # remove last line

	echo "----------cmd: $@---------" >> diff1
	echo "----------cmd: $@---------" >> diff2

#	cat out1 >> trace1
#	cat out2 >> trace2

	bash < input > bash1 2> bash2

#	diff out1 bash1 >> trace1
#	diff out2 bash2 >> trace2

#	cat out1 >> bash1
#	cat out2 >> bash2

	diff out1 bash1 >> diff1
	diff out2 bash2 >> diff2

}

#rm trace1 trace2 2> /dev/null
rm diff1 diff2 2> /dev/null


### get prompt string to remove ##
echo > tmp1
prompt_string=$(./minishell < tmp1)
echo $prompt_string

### echo builtin tests ##
#test "echo"
#test "echo bonjour"
#test "echo lalalala lalalalal alalalalal alalalala"
#test "echo lalalala                lalalalal      alalalalal alalalala"
#test "echo "
#test "echo -n"
test "echo -n bonjour"
#test "echo -n lalalala lalalalal alalalalal alalalala"
#test "echo -n lalalala                lalalalal      alalalalal alalalala"
#test "echo -n "
#test "echo bonjour -n"
#test "echo -n bonjour -n"
#test "                        echo                     bonjour             je"
#test "                        echo       -n            bonjour             je"
#test "echo a '' b '' c '' d"
#test 'echo a "" b "" c "" d'
#test "echo -n a '' b '' c '' d"
#test 'echo -n a "" b "" c "" d'
#test "echo '' '' ''"
#test "Echo bonjour"
#test "eCho bonjour"
#test "ecHo bonjour"
#test "echO bonjour"
#test "EchO bonjour"
#test "eCHo bonjour"
#test "EcHo bonjour"
#test "eChO bonjour"
#test "Echo bonjour"
#test "eCho bonjour"
#test "ecHo bonjour"
#test "echO bonjour"
#test "EchO bonjour"
#test "eCHo bonjour"
#test "EcHo bonjour"
#test "eChO bonjour"
#test "eChO -e 'bonjo\\nur'"
#test "echo -n -n -n -n bonjour"
#test "echo -nnnnnnnnnnnnnnnnnnnnn bonjour"
#test "echo -nnnnnnnnnnnnnnnnnnnnn -n -n -n bonjour -n -n"

rm input tmp1 minishell 2> /dev/null
#rm input tmp1 out1 out2 bash1 bash2 minishell 2> /dev/null
