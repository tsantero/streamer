-module(streamer_server).

-behaviour(gen_server).

-export([start_link/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-define(TBL, graphs).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).                   
                                                                                
stop() ->                                                                       
    gen_server:call(?MODULE, stop).                                             

init([]) ->
    _ = try ets:new(?TBL, [named_table, public, set, {keypos, 1}]) of           
        _Res ->                                                             
            ok                                                              
        catch                                                                   
            error:badarg ->                                                     
                lager:warning("Table ~p already exists", [?TBL])                
        end,                                                                    
    ok.

handle_call(stop, _From, State) ->                                              
    {stop, normal, State}.

handle_cast(_From, State) ->
    {noreply, State}.
                                                                                
handle_info(_Info, State) ->                                                    
    lager:info("Unexpected: ~p,~p.~n", [_Info, State]),                         
    {noreply, State}.                                                           
                                                                                
terminate(_Reason, _State) ->                                                   
    lager:info("terminate ~p, ~p.~n", [_Reason, _State]),                       
    {ok, _State}.                                                               
                                                                                
code_change(_OldVsn, State, _Extra) ->                                          
    {ok, State}.
