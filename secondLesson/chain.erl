-module(chain).
-export([send/2, start/1]).


start(Max) ->
    send(1, Max).

send(Counter, Max) ->
    
    if
        Counter < Max ->
            io:fwrite("~p~n", [Counter]),
            Counter1 = Counter + 1,
            %send(Counter1);
            Pid = spawn(chain, send, [Counter1, Max]),
            io:fwrite("Pid:~p~n", [Pid]);
    true ->
        io:fwrite("The end~n")
    end.