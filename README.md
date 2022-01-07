# 42-minishell_bash_tester_2022
Simple tester for 42 minishell project

## Tested :
- everything
- even exit
- and of course leaks using valgrind (readline leaks ignored)
- heredoc, exit status, pipes, redirect, special files opening
- ...

## Install :
1) Clone the repo
2) Set your minishell path ```minishell_dir=``` in tester.sh
4) Run ```bash tester.sh````
For leak test : set ```VALGRIND_LEAKS_CKECK=1``` (about 3mn on 42 PCs)

## Our version of minishell that passes all tests :
[simon-ameye/42-minishell](https://github.com/simon-ameye/42-minishell)

![Alt text](preview.png?raw=true "Preview")
