# ДЗ 3-1

1. Установка Virtualbox

```sudo apt-get install virtualbox-6.1```

2. Установка Vagrant

```
sudo apt-get update && sudo apt-get install vagrant
```

3. [Апаратные ресурсы выделенные ВМ](../img/1.png)

4. Выделение ресурсов ВМ
```
config.vm.provider "virtualbox" do |v|
      v.memory = 2024
      v.cpus = 3
    end
```
5. [vagrant ssh](../img/2.png)
6.```HISTSIZE``` -переменная которой можно задать размер истории
``` 
 541        HISTSIZE
 542               The  number  of commands to remember in the command history (see HISTORY below).  If the value is 0, commands are not saved in the history list.  Numeric values less than zero result in every command being saved on the history list (there is no limit).  The shell sets the default value
 543               to 500 after reading any startup files.
```
7. ignoreboth - не сохранять строки начинающиеся с символа пробел и не сохранять строки, совпадающие с последней выполненной командой
```A value of ignoreboth is shorthand for ignorespace and ignoredups```

8. {} - список, используется в различных условных циклах, условных операторах, или ограничивает тело функции
```
126        ! case  coproc  do done elif else esac fi for function if in select then until while { } time [[ ]]
    181        { list; }
    182               list is simply executed in the current shell environment.  list must be terminated with a newline or semicolon.  This is known as a group command.  The return status is the exit status of list.  Note that unlike the metacharacters ( and ), { and } are  reserved  words  and  must  occur
    267               commands  between  {  and  }, but may be any command listed under Compound Commands above, with one exception: If the function reserved word is used, but the parentheses are not supplied, the braces are required.  compound-command is executed whenever name is specified as the name of a
    403               An  array variable whose members are the line numbers in source files where each corresponding member of FUNCNAME was invoked.  ${BASH_LINENO[$i]} is the line number in the source file (${BASH_SOURCE[$i+1]}) where ${FUNCNAME[$i]} was called (or ${BASH_LINENO[$i-1]} if referenced within
    411               An array variable whose members are the source filenames where the corresponding shell function names in the FUNCNAME array variable are defined.  The shell function ${FUNCNAME[$i]} is defined in the file ${BASH_SOURCE[$i]} and called from ${BASH_SOURCE[$i+1]}.
    425               An index into ${COMP_WORDS} of the word containing the current cursor position.  This variable is available only in shell functions invoked by the programmable completion facilities (see Programmable Completion below).
    431               The  index  of the current cursor position relative to the beginning of the current command.  If the current cursor position is at the end of the current command, the value of this variable is equal to ${#COMP_LINE}.  This variable is available only in shell functions and external com‐
    455               This  variable  can  be used with BASH_LINENO and BASH_SOURCE.  Each element of FUNCNAME has corresponding elements in BASH_LINENO and BASH_SOURCE to describe the call stack.  For instance, ${FUNCNAME[$i]} was called from the file ${BASH_SOURCE[$i+1]} at line number ${BASH_LINENO[$i]}.
```
9. ```touch {000001..100000}.txt``` - создаст в текущей директории соответсвющее число фалов; 300000 - создать не удасться, слишком дилинный список аргументов
10. ```[[ -d /tmp ]]``` - проверяет условие -d /tmp и возвращает ее статус (0 или 1), проверка наличие каталога /tmp
```
    188        [[ expression ]]
    189               Return  a  status of 0 or 1 depending on the evaluation of the conditional expression expression.  Expressions are composed of the primaries described below under CONDITIONAL EXPRESSIONS.  Word splitting and pathname expansion are not performed on the words between the [[ and ]]; tilde
    192               When used with [[, the < and > operators sort lexicographically using the current locale.

```
11. [type -a bash](../img/3.png)
```
vagrant@vagrant:~$ mkdir /tmp/new_path_directory/
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory
vagrant@vagrant:~$ PATH=/tmp/new_path_directory/:$PATH
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```

12. at - команда запускается в указанное время (в параметре)
batch - запускается когда уровень загрузки системы снизится ниже 1.5.
13. 
```
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
nariman@nariman:~/work/devops-netology/03-sysadmin-01-terminal/vagrant$ vagrant suspend
==> default: Saving VM state and suspending execution...
```