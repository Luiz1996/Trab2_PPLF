% +--------------------------------+
% | LUIZ FLAVIO PEREIRA -> RA91706 |
% +--------------------------------+

:- use_module(library(clpfd)).
:- use_module(library(plunit)).

% +-------------------------------------------------------------------------+
%%| festa(?Pessoa1, ?Pessoa2, ?Pessoa3, ?Pessoa4) is nondet                 |
% |                                                                         | 
% | Verdadeiro se a Pessoa1, Pessoa2, Pessoa3 e Pessoa4 sao                 |
% | estruturas do tipo pessoa(N, I, F, R), onde:                            |
% | N -> Nome                                                               |    
% | I -> Idade                                                              |
% | F -> Fantasia                                                           |
% | R -> Responsavel                                                        |
% +-------------------------------------------------------------------------+
% | ************************** Festa a Fantasia *************************** |          
% +-------------------------------------------------------------------------+
% | Quatro meninas estao em uma animadissima festa a fantasia, cada menina  |
% | esta com uma fantasia, acompanhada de um responsavel e possui uma idade.|
% |                                                                         |
% | Restricoes:                                                             |
% | 1) O Tio nao eh responsavel pela menina vestida de Bruxa;               | 
% | 2) Roberta eh um ano mais velha que Helen;                              |
% | 3) A menina vestida de Princesa tem 9 anos ou eh a Roberta;             |
% | 4) A Priscila eh mais nova do que a menina vestida de Heroina;          |
% | 5) A menina de 7 anos esta vestida de Fada ou esta com o Pai;           |
% | 6) Helen nao esta vestida de Bruxa;                                     |
% | 7) Entre a menina de 8 anos e a que esta com a mae, uma esta            |
% |    vestida de Heroina e a outra eh a Priscila, nao                      |
% |    necessariamente nessa ordem.                                         |
% | 8) A menina de 9 anos esta com a Mae;                                   |
% |                                                                         |
% | Voce pode verificar a solucao consultando:                              |
% | festa(Pessoa1, Pessoa2, Pessoa3, Pessoa4).                              |
% +-------------------------------------------------------------------------+

festa(Pessoa1, Pessoa2, Pessoa3, Pessoa4) :-
    % na festa ha 4 pessoas(meninas)
    Festa = [Pessoa1, 
             Pessoa2, 
             Pessoa3, 
             Pessoa4],
    
    % Nome, Idade, Fantasia e Responsavel
    Pessoa1 = pessoa(debora,_,_,_), 
    Pessoa2 = pessoa(helen,_,_,_),
    Pessoa3 = pessoa(priscila,_,_,_),
    Pessoa4 = pessoa(roberta,_,_,_),

    % cada idade das meninas
    member(pessoa(_,6,_,_), Festa),
    member(pessoa(_,7,_,_), Festa),
    member(pessoa(_,8,_,_), Festa),
    member(pessoa(_,9,_,_), Festa),

    % cada fantasia das meninas
    member(pessoa(_,_,bruxa,_), Festa),
    member(pessoa(_,_,fada,_), Festa),
    member(pessoa(_,_,heroina,_), Festa),
    member(pessoa(_,_,princesa,_), Festa),

    % cada responsavel das meninas
    member(pessoa(_,_,_,avo), Festa),
    member(pessoa(_,_,_,mae), Festa),
    member(pessoa(_,_,_,pai), Festa),
    member(pessoa(_,_,_,tio), Festa),

    % restricao n.1 (Tio nao acompanha a menina vestida de Bruxa)
    member(pessoa(_,_,NaoEhBruxa,tio), Festa),

    % restricao n.2 (Roberta eh 1 ano mais velha que Helen)
    eh_mais_nova(Festa, pessoa(helen,_,_,_), 
                        pessoa(roberta,_,_,_), DiferencaIdadeEhUmAno),

    % restricao n.3 (A menina vestida de Princesa tem 9 anos ou eh a Roberta)
    (
     member(pessoa(_,9,princesa,_), Festa); 
     member(pessoa(roberta,_,princesa,_), Festa)
    ),

    % restricao n.4 (Priscila eh mais nova que a menina vestida de Heroina)
    eh_mais_nova(Festa, pessoa(priscila,_,_,_), 
                        pessoa(_,_,heroina,_), DiferencaIdadeMaiorQueZero),                       

    % restricao n.5 (A menina de 7 anos esta vestida de Fada ou esta com o Pai)
    (
     member(pessoa(_,7,fada,_), Festa); 
     member(pessoa(_,7,_,pai), Festa)
    ),

    % restricao n.6 (Helen nao esta vestida de Bruxa)
    member(pessoa(helen,_,NaoEhBruxa,_), Festa),

    % restricao n.7 (Se menina de 8 anos eh Heroina, entao Priscila esta com a mae... Ou, vice-versa)
    (
        (
         member(pessoa(_,8,heroina,_), Festa), 
         member(pessoa(priscila,_,_,mae), Festa)
        )
        ;
        (
         member(pessoa(_,_,heroina,mae), Festa),   
         member(pessoa(priscila,8,_,_), Festa)
        )
    ),

    % restricao n.8 (A menina de 9 anos esta com a Mae)
    member(pessoa(_,9,_,mae), Festa),
    
    % restricoes auxiliares
    NaoEhBruxa \= bruxa,
    DiferencaIdadeEhUmAno #= 1,
    DiferencaIdadeMaiorQueZero #> 0.

%% eh_mais_nova(?Festa, ?P1, ?P2, ?Dif) is nondet
%
%  Verdadeiro se a a diferença de idade entre P1 e P2 é igual a Dif anos, 
%  além disso, P1 e P2 devem participar da Festa.

:- begin_tests(eh_mais_nova).

test(t01, nondet) :-
    A = pessoa(priscila,6,_,_),
    B = pessoa(debora,9,_,_),
    eh_mais_nova([A, B], A, B, 3).

test(t02, fail) :-
    A = pessoa(priscila,6,_,_),
    B = pessoa(debora,9,_,_),
    eh_mais_nova([A, B], B, A, 3).

test(t03, nondet) :-
    A = pessoa(_,_,_,_),
    B = pessoa(_,_,_,_),
    eh_mais_nova([A, B], A, B, _).

test(t04, fail) :-
    eh_mais_nova([], _, _, _).

test(t05, nondet) :-
    A = pessoa(priscila,I,_,_),
    B = pessoa(debora,9,_,_),
    I is 6,
    eh_mais_nova([A, B], A, B, 3). 

test(t06, fail) :-
    A = pessoa(priscila,I,_,_),
    B = pessoa(debora,I,_,_),
    I #= 6,
    eh_mais_nova([A, B], A, B, 3).       

test(t07, nondet) :-
    A = pessoa(priscila,I,_,_),
    B = pessoa(debora,I,_,_),
    I #= 5,
    eh_mais_nova([A, B], A, B, 0).

test(t08, fail) :-
    A = pessoa(priscila,I1,_,_),
    B = pessoa(debora,I2,_,_),
    I1 #= 9,
    I2 #= 9,
    eh_mais_nova([A, B], A, B, DiferencaIdadeMaiorQueZero),
    DiferencaIdadeMaiorQueZero #> 0.

test(t09, nondet) :-
    A = pessoa(priscila,I1,_,_),
    B = pessoa(debora,I2,_,_),
    I1 #= 8,
    I2 #= 9,
    eh_mais_nova([A, B], A, B, 1).

test(t10, fail) :-
    A = pessoa(priscila,I,_,_),
    B = pessoa(debora,9,_,_),
    I is 6,
    eh_mais_nova([A, B], B, A, 3).

:- end_tests(eh_mais_nova).

eh_mais_nova(Festa, P1, P2, Dif) :-
    P1 = pessoa(_, I1, _, _),
    P2 = pessoa(_, I2, _, _),
    I2 - I1 #= Dif,
    member(P1, Festa),
    member(P2, Festa).