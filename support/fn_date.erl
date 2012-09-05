-module(fn_date).
-export([get_date_tuple/1, get_date_time_tuple/1, get_date_time_tuple/2]).

get_date_tuple(Date) ->
    [Y, M, D] = string:tokens(Date, " -"),
    {z_convert:to_integer(Y), z_convert:to_integer(M), z_convert:to_integer(D)}.

get_date_time_tuple(Date) ->
    case string:tokens(Date, "-/: ") of
        [] -> undefined;
        [Y,M,D] -> {{z_convert:to_integer(Y), z_convert:to_integer(M), z_convert:to_integer(D)},{23,59,59}}
    end.

get_date_time_tuple(Date,Time) ->
    case string:tokens(Date, "-/: ") of
        [] -> undefined;
        [Y,M,D] ->
            case string:tokens(Time, ": ") of
                [] -> {{z_convert:to_integer(Y), z_convert:to_integer(M), z_convert:to_integer(D)},{23,59,0}};
	        [H,Min] -> 
		          {{z_convert:to_integer(Y), z_convert:to_integer(M), z_convert:to_integer(D)},{z_convert:to_integer(H), z_convert:to_integer(Min), 0}}
	    end
    end.
