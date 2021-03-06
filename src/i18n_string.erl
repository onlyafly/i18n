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

-module(i18n_string).
-include("i18n.hrl").

-type i18n_locale_id() :: atom(). 

%% UTF-8 string
-type unicode_binary() :: binary(). 

%% UTF-16 string
-type i18n_string() :: binary().   

-type resource() :: <<>>.   
-type i18n_iterator() :: resource().   


% NIFs
-export([from/1]).
-export([from_utf8/1, to_utf8/1]).
-export([to_nfc/1, to_nfd/1, to_nfkc/1, to_nfkd/1]).
-export([concat/2]).
-export([compare/2, case_compare/2, case_compare/3]).


-export([to_lower/2, to_upper/2, to_title/2]).
-export([to_lower/1, to_upper/1, to_title/1]).
-export([len/1, len/2, split/2, split_index/2]).


%% @doc Convert a term to a UTF-16 string.
-spec from(binary() | list() | atom()) -> i18n_string().
from(B) 
    when is_binary(B) ->
    from_utf8(B);
from(L) 
    when is_list(L) ->
    B = unicode:characters_to_binary(L),
    from_utf8(B);
from(A) 
    when is_atom(A) ->
    L = erlang:atom_to_list(A),
    B = erlang:list_to_binary(L),
    from_utf8(B).


%% @doc Convert a UTF-8 string to a UTF-16 string.
-spec from_utf8(unicode_binary()) -> i18n_string().
from_utf8(B) ->
    ?TRY_STR(?IM:from_utf8(B)).

%% @doc Convert a UTF-16 string to a UTF-8 string.
-spec to_utf8(i18n_string()) -> unicode_binary().
to_utf8(B) ->
    ?TRY_BIN(?IM:to_utf8(B)).

%%
%% Normalization
%%

%% @doc Convert a string to Unicode Normalization Form NFC.
-spec to_nfc(i18n_string()) -> unicode_binary().
to_nfc(B) ->
    ?TRY_BIN(?IM:to_nfc(B)).

%% @doc Convert a string to Unicode Normalization Form NFD.
-spec to_nfd(i18n_string()) -> unicode_binary().
to_nfd(B) ->
    ?TRY_BIN(?IM:to_nfd(B)).

%% @doc Convert a string to Unicode Normalization Form NFKD.
-spec to_nfkc(i18n_string()) -> unicode_binary().
to_nfkc(B) ->
    ?TRY_BIN(?IM:to_nfkc(B)).

%% @doc Convert a string to Unicode Normalization Form NFKD.
-spec to_nfkd(i18n_string()) -> unicode_binary().
to_nfkd(B) ->
    ?TRY_BIN(?IM:to_nfkd(B)).


%% @doc Concatinate two strings.
-spec concat(i18n_string(), i18n_string()) -> i18n_string().
concat(B1, B2) -> 
    <<B1/binary, B2/binary>>.


%% @doc Count of code elements. Code elements are neither code points nor
%%      graphemes. 
-spec len(i18n_string()) -> non_neg_integer().
len(S) when is_binary(S) -> 
    byte_size(S) div 2.

%% @doc Count the length og the string with help of an iterator.
%%
%% ```
%% i18n_string:len(i18n_iterator:open('grapheme'), ?ISTR("Example"));
%% '''
-spec len(i18n_iterator(), i18n_string()) -> non_neg_integer().
len(I, S) -> 
    ?TRY_INT(?IM:len(I, S)).

%% @doc This functions breaks a string on parts.
-spec split(i18n_iterator(), i18n_string()) -> [i18n_string()].
split(I, S) ->
    ?TRY_LIST(?IM:split(I, S)).

%% @doc Return the list of indexes of beginnings of parts of a string.
-spec split_index(i18n_iterator(), i18n_string()) -> [non_neg_integer()].
split_index(I, S) ->
    ?TRY_LIST(?IM:split_index(I, S)).


%%
%% Case
%%

%% @doc Convert a string to lower case.
-spec to_lower(i18n_string()) -> i18n_string().
to_lower(S) ->
    L = i18n_locale:get_locale(),
    to_lower(L, S).

%% @doc Convert a string to lower case.
-spec to_lower(i18n_locale_id(), i18n_string()) -> i18n_string().
to_lower(L, S) when is_atom(L) ->
    ?TRY_STR(?IM:to_lower(L, S)).

%% @doc Convert a string to upper case.
-spec to_upper(i18n_string()) -> i18n_string().
to_upper(S) ->
    L = i18n_locale:get_locale(),
    to_upper(L, S).

%% @doc Convert a string to upper case.
-spec to_upper(i18n_locale_id(), i18n_string()) -> i18n_string().
to_upper(L, S) when is_atom(L) ->
    ?TRY_STR(?IM:to_upper(L, S)).

-spec to_title(i18n_string()) -> i18n_string().
to_title(S) ->
    L = i18n_locale:get_locale(),
    to_title(L, S).

-spec to_title(i18n_locale_id() | i18n_iterator(), i18n_string()) -> i18n_string().
to_title(L, S) ->
    ?TRY_STR(?IM:to_title(L, S)).


%%
%% Comparation
%%

%equal(S1, S2) ->
%.
%
%compare(S1, S2) ->
%.
%

-spec compare(i18n_string(), i18n_string()) -> 
        'less' | 'greater' | 'equal'.

compare(S1, S2) ->
    ?TRY_ATOM(?IM:non_case_compare(S1, S2)).

-spec case_compare(i18n_string(), i18n_string()) -> 
        'less' | 'greater' | 'equal'.

case_compare(S1, S2) ->
    L = i18n_locale:get_locale(),
    case_compare(L, S1, S2).


-spec case_compare(i18n_locale_id(), i18n_string(), i18n_string()) -> 
        'less' | 'greater' | 'equal'.

case_compare(L, S1, S2) ->
    ?TRY_ATOM(?IM:case_compare(L, S1, S2)).



