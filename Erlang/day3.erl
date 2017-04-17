% An OTP service that will restart a process if it dies
% http://erlang.org/doc/man/supervisor.html

% Documentation for building a simple OTP server
% http://learnyousomeerlang.com/what-is-otp
% http://learnyousomeerlang.com/building-applications-with-otp
% http://learnyousomeerlang.com/building-otp-applications
% https://medium.com/@kansi/chatbus-build-your-first-multi-user-chat-room-app-with-erlang-otp-b55f72064901

-module(day3).
-export([monitorLoop/0]).

-behaviour(supervisor).
-export([init/1]).

translateLoop() ->
    receive
        "nihao" ->
            io:format("nihao translates to hi~n"),
            translateLoop();
        "zaijian" ->
            io:format("zaijian translates to bye~n"),
            translateLoop();
        kill ->
            io:format("Translator process ~p killing self~n", [self()]),
            exit({ translator, die, at, erlang:time() });
        _ ->
            io:format("unknown word~n"),
            translateLoop()
    end.

% Monitor the translate_service and restart it should it die.
monitorLoop() ->
    process_flag(trap_exit, true),
    receive
        startTranslator ->
            io:format("Creating and monitoring a new translator~n"),
            register(translator, spawn_link(fun translateLoop/0)),
            monitorLoop();

        { 'EXIT', From, Reason } ->
            io:format("a translator process ~p died with reason ~p.~n", [From,Reason]),
            self() ! startTranslator,
            monitorLoop();

        kill ->
            io:format("Monitor process ~p killing self~n", [self()]),
            exit({ monitor })
    end.

start() ->
	io:fwrite("Starting monitor~n"),
 	Pid = spawn_link(fun monitorLoop/0),
    register(monitor, Pid),
    Pid.

init(_Args) ->
    {ok, {{simple_one_for_one, 10,60},
		[{day3, {day3, start, []},
			permanent, brutal_kill, worker, [day3]}]}}.

% c(day3).
% Monitor = spawn(fun day3:monitorLoop/0).
% Monitor ! startTranslator.
% translator ! "nihao".


% Make the Doctor process restart itself if it should die.
% Make a monitor for the Doctor monitor. If either monitor dies, restart it.
