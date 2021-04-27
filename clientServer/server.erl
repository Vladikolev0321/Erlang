-module(server).
-export([start/1, loop/1, rpc/2]).

start(N) ->
    spawn(server, loop, [N]).

rpc(Server, Request) ->
    Server ! {self(), Request},
    receive
        {Server, X} -> io:format("X:~p~n", [X]);
        _Any -> unknown_message
    end.

loop(State) ->
    receive 
        {Client, X} -> %io:format("X:~p~n", [X]),
            Client ! {self(), f1(X)},
            NewState = State + X;
        _Any ->
            io:format("NewState:~p~n", [State]),
            NewState = State
    end,
    loop(NewState).

f1(X) -> 
    X*X.
g1(_X) ->
    nok.