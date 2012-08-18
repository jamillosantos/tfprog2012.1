
Trabalho final
==============
Este é o projeto do final do primeiro semestre da matéria [Programação de Computadores](http://dietinf.ifrn.edu.br/doku.php?id=corpodocente:jorgiano:20121:tads:programacao_de_computadores) do curso de TADS do IFRN, turma 2012.1, [Professor Jorgiano](http://dietinf.ifrn.edu.br/doku.php?id=corpodocente:jorgiano).

Autores
-------
* [Jamillo Santos](https://github.com/jamillosantos)
* [Renno Garcia](https://github.com/rennogarcia)


Dependências
------------
1.	[Gosu](http://www.libgosu.org/);

	Veja como instalar no Linux [aqui](https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux).


2.	[Chipmunk](http://chipmunk-physics.net/);

	Ver documentação do *Wrapper* em Ruby [aqui](http://beoran.github.com/chipmunk/)


3.	JSON


4.	[Chingu](https://github.com/ippa/chingu)

	[Ver documentação](http://rdoc.info/github/ippa/chingu/)

* * *

Para instalá-las utilize o comando abaixo:

	$ gem install gosu chipmunk json chingu

Clone e comece a rodar
----------------------

Após clonar o repositório, pela via normal. Faz-se necessário inicializar os submódulos utilizados.

	$ git submodule update --init

Iniciando o jogo
----------------

	$ ruby main.rb
