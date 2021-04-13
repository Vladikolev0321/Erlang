-module(ring).
-export([fac/1, loop/2, start/3, loop2/2]).

fac(0) -> 1;
fac(N) ->
    N*fac(N-1).
% 1. Shell -> p5 -> p4 -> p3 -> p2 -> p1 -> p0
% 2. Propagation of P1 into to Shell
% 3. spawn(ring, loop, [])
% 2 processes Parent -> Child1(Parent) ! message
% more processes Child1(Parent) -> Child2(Child1) .. 


% P5 = spawn(ring, loop, [5, self()].//arguments called state).
% P5 ! create_child.
% P5 ! Any.
loop(0, Parent) ->  Parent ! {last_child, Parent};
loop(N, Parent) ->
    receive
        create_child -> 
            Child = spawn(ring, loop, [N-1, self()]),
            io:format("N:~p My parent: ~p, My Pid: ~p , My Child: ~p~n", [N, Parent, self(), Child]),
            Child ! create_child;
        
    {last_child, LastChildPid} ->
        io:format("I am: ~p Last Child Pid: ~p sent to Parent~p~n", [self(), LastChildPid, Parent]),
        Parent ! {last_child, LastChildPid};
    {calculate, G} ->
        M = G * 5,
        io:format("I am:~p, M:~p ~n", [self(), M]),
        Parent ! {calculate, M};
    Any -> Any
    end,
    loop(N, Parent).

start(NumberOfChilds, Parent, G) ->
    FirstChild = spawn(ring, loop, [NumberOfChilds, Parent]),
    FirstChild ! create_child,
    receive
        {last_child, LastChildPid} ->
            LastChildPid ! {calculate, G}
    end.





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