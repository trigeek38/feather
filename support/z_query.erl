-module(z_query).
-export([get_query_string/1]).

get_query_string(Props) ->
    get_query_string(Props, "", [], 1).

get_query_string([], WhereString, Arguments, _Num) ->
    {WhereString, Arguments};

get_query_string([H|T], WhereString, Arguments, Num) ->
    W = WhereString ++ z_convert:to_list(element(1, H)) ++ " =$" ++ z_convert:to_list(Num),
    case T of
        [] ->
            WhereString1 = W;
        _ ->
            WhereString1 = W ++ " and "
        end,
    get_query_string(T, WhereString1, Arguments ++ [z_convert:to_integer(element(2, H))], Num + 1).

