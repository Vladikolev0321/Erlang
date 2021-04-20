-module(man).
-export([loop/1]).

% State = {{activity, high},{emotion, happy},{concentration, high}}

loop(State) ->

    receive
        idiot -> %process_idiot(State),
                ignore(State)

    end,
    loop(State).

process_idiot(State) ->
    {{activity, Activity}, {emotion, Emotion}, {concentration, Concentration}} = State,
    NewEmotion =
    case Emotion of
        happy -> sad;
        sad -> angry
    end,
    NewState = {{activity, Activity},{emotion, NewEmotion},{concentration, Concentration}},
    NewState.

ignore(State) ->
    State.