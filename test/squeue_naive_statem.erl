-module(squeue_naive_statem).

-include_lib("proper/include/proper.hrl").

-export([quickcheck/0]).
-export([quickcheck/1]).
-export([check/1]).
-export([check/2]).

-export([module/0]).
-export([args/0]).
-export([init/1]).
-export([handle_time/3]).

-export([initial_state/0]).
-export([command/1]).
-export([precondition/2]).
-export([next_state/3]).
-export([postcondition/3]).

quickcheck() ->
    quickcheck([]).

quickcheck(Opts) ->
    proper:quickcheck(prop_squeue(), Opts).

check(CounterExample) ->
    check(CounterExample, []).

check(CounterExample, Opts) ->
    proper:check(prop_squeue(), CounterExample, Opts).

prop_squeue() ->
    ?FORALL(Cmds, commands(?MODULE),
            ?TRAPEXIT(begin
                          {History, State, Result} = run_commands(?MODULE, Cmds),
                          ok,
                          ?WHENFAIL(begin
                                        io:format("History~n~p", [History]),
                                        io:format("State~n~p", [State]),
                                        io:format("Result~n~p", [Result])
                                    end,
                                    aggregate(command_names(Cmds), Result =:= ok))
                      end)).

module() ->
    squeue_naive.

args() ->
    undefined.

init(State) ->
    State.

handle_time(_Time, _L, State) ->
    {0, State}.

initial_state() ->
    squeue_statem:initial_state(?MODULE).

command(State) ->
    squeue_statem:command(State).

precondition(State, Call) ->
    squeue_statem:precondition(State, Call).

next_state(State, Value, Call) ->
    squeue_statem:next_state(State, Value, Call).

postcondition(State, Call, Result) ->
    squeue_statem:postcondition(State, Call, Result).