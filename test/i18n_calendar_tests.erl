% vim: set filetype=erlang shiftwidth=4 tabstop=4 expandtab tw=80:

%%% =====================================================================
%%%   Copyright 2011 Uvarov Michael 
%%%
%%%   Licensed under the Apache License, Version 2.0 (the "License");
%%%   you may not use this file except in compliance with the License.
%%%   You may obtain a copy of the License at
%%%
%%%       http://www.apache.org/licenses/LICENSE-2.0
%%%
%%%   Unless required by applicable law or agreed to in writing, software
%%%   distributed under the License is distributed on an "AS IS" BASIS,
%%%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%%   See the License for the specific language governing permissions and
%%%   limitations under the License.
%%%
%%% $Id$
%%%
%%% @copyright 2010-2011 Michael Uvarov
%%% @author Michael Uvarov <freeakk@gmail.com>
%%% =====================================================================

%%% @private
-module(i18n_calendar_tests).
-include_lib("i18n/include/i18n.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-include_lib("triq/include/triq.hrl").
-define(M, i18n_calendar).
    

    
for_all_locales_open_test_() ->
    ?_assert(
        lists:all(fun erlang:is_binary/1, 
            lists:map(fun ?M:open/1, 
                ?M:available_locales()))).

for_all_locales_and_timezones_open_test_() ->
    % Limit the count of cases
    TimeZones = lists:sublist(?M:available_timezones(), 5),
    Locales   = lists:sublist(?M:available_locales(), 5),
    GetListOfResourcesFn = 
        fun() ->
            lists:map(fun(L) ->
                lists:map(fun(TZ) ->
                    ?M:open(L, TZ)
                    end, TimeZones)
                end, Locales)
        end,

	{timeout, 60,
        ?_assert(
            lists:all(fun erlang:is_binary/1, 
                    lists:flatten(GetListOfResourcesFn())))}.


timezones_test() ->
    i18n_calendar:available_timezones().

-endif.
