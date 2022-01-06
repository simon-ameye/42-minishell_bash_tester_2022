# 42-minishell_bash_tester_2022
Simple tester for 42 minishell project

[![latest version][npm-img]][npm-url] [![downloads][downloads-img]][npm-url]

[npm-img]: https://img.shields.io/npm/v/beautiful-markdown.svg?style=flat-square
[npm-url]: https://www.npmjs.com/package/beautiful-markdown
[downloads-img]: https://img.shields.io/npm/dm/beautiful-markdown.svg?style=flat-square
## Tested :
- everything
- even exit
- and of course leaks using valgrind (readline leaks ignored)
- heredoc, exit status, pipes, redirect, special files opening
- ...

## Install :
1) Clone the repo
2) Set minishell path "minishell_dir=" in tester.sh
4) run "bash tester.sh"
For leak test : set "VALGRIND_LEAKS_CKECK=1" (about 3mn on 42 PCs)

## Our version of minishell that passes the test :
https://github.com/simon-ameye/42-minishell

![Alt text](preview.png?raw=true "Preview")
