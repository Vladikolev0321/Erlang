-module(ring).
-export([loop2/2]).

% 2 processes Parent -> Child1(Parent) ! message
% more processes Child1(Parent) -> Child2(Child1) .. 

loop2(0, _Parent) -> io:format("Child0: ~p~n", [self()]),
                    ok;

loop2(N, Parent) ->
    Child = spawn(ring, loop2, [N-1, self()]),
    io:format("Child Pid: ~p ~p~n", [N-1, Child]),

    receive
        get_child -> Child;
        X ->
            io:format("Child, Message :~p ~p~n", [N, X]),
            Parent ! X
    end,
    loop2(N-1, Parent).