%%%-------------------------------------------------------------------
%%% File:      date_util.erl
%%% @author    Guy Parrulli <> []
%%% @copyright 2012 Guy Parrulli
%%% @doc
%%%
%%% @end
%%%
%%% @since 2012-07-02 by Guy Parrulli
%%%-------------------------------------------------------------------
-module(date_util).

-export([string_to_datetime/1,datediff/3,dateadd/3]).

%%====================================================================
%% API
%%====================================================================

string_to_datetime(DateString) ->
    TT = [HasTime || HasTime <-  DateString, HasTime =:= ":" ],
    case TT of
    [] -> {ok,[A, B, C],_} =io_lib:fread("~d/~d/~d", DateString),
          {Hours,Minutes,Seconds} = {0,0,0};
    _Else ->
          {ok,[A, B, C,Hours,Minutes,Seconds],_} =io_lib:fread("~d/~d/~d ~d:~d:~d", DateString)
    end,
    {validate_date([A, B, C]),{Hours,Minutes,Seconds}}.

datediff(second,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}}) ->
    calendar:datetime_to_gregorian_seconds({{Tyear,TMonth,Tday},{Th,Tm,Td}}) -
    calendar:datetime_to_gregorian_seconds({{Fyear,FMonth,Fday},{Fh,Fm,Fd}});

datediff(second,{Fyear,FMonth,Fday},{Tyear,TMonth,Tday}) ->
    datediff(second,{{Fyear,FMonth,Fday},{0,0,0}},{{Tyear,TMonth,Tday},{0,0,0}});

datediff(second,From,To) ->
    {{Fyear,FMonth,Fday},{Fh,Fm,Fd}} = string_to_datetime(From),
    {{Tyear,TMonth,Tday},{Th,Tm,Td}} = string_to_datetime(To),
    datediff(second,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}});

datediff(minute,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}}) ->
    trunc(calendar:datetime_to_gregorian_seconds({{Tyear,TMonth,Tday},{Th,Tm,Td}}) / 60) -
    trunc(calendar:datetime_to_gregorian_seconds({{Fyear,FMonth,Fday},{Fh,Fm,Fd}}) / 60);

datediff(minute,From,To) ->
    {{Fyear,FMonth,Fday},{Fh,Fm,Fd}} = string_to_datetime(From),
    {{Tyear,TMonth,Tday},{Th,Tm,Td}} = string_to_datetime(To),
    datediff(minute,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}});

datediff(hour,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}}) ->
    trunc(calendar:datetime_to_gregorian_seconds({{Tyear,TMonth,Tday},{Th,Tm,Td}}) / 60 / 60) -
    trunc(calendar:datetime_to_gregorian_seconds({{Fyear,FMonth,Fday},{Fh,Fm,Fd}}) / 60 / 60);

datediff(hour,From,To) ->
    {{Fyear,FMonth,Fday},{Fh,Fm,Fd}} = string_to_datetime(From),
    {{Tyear,TMonth,Tday},{Th,Tm,Td}} = string_to_datetime(To),
    datediff(hour,{{Fyear,FMonth,Fday},{Fh,Fm,Fd}},{{Tyear,TMonth,Tday},{Th,Tm,Td}});

datediff(day,{{Fyear,FMonth,Fday},_F},{{Tyear,TMonth,Tday},_T}) ->
    calendar:date_to_gregorian_days(Tyear, TMonth, Tday) -  calendar:date_to_gregorian_days(Fyear, FMonth, Fday);

datediff(day,{Fyear,FMonth,Fday},{Tyear,TMonth,Tday}) ->
    datediff(day,{{Fyear,FMonth,Fday},{0,0,0}},{{Tyear,TMonth,Tday},{0,0,0}});

datediff(day,From,To) ->
    {{Fyear,FMonth,Fday},{_Fh,_Fm,_Fd}} = string_to_datetime(From),
    {{Tyear,TMonth,Tday},{_Th,_Tm,_Td}} = string_to_datetime(To),
    datediff(day,{{Fyear,FMonth,Fday},{0,0,0}},{{Tyear,TMonth,Tday},{0,0,0}});

datediff(month,{{Fyear,FMonth,_Fday},_} ,{{Tyear,TMonth,_Tday},_} ) ->
    Yeardiff = (Tyear - Fyear) * 12,
    MonthDiff = (TMonth - FMonth),
    Yeardiff + MonthDiff;

datediff(month,From ,To ) ->
    {{Fyear,FMonth,_Fday},_F} = string_to_datetime(From),
    {{Tyear,TMonth,_Tday},_T} = string_to_datetime(To),
    datediff(month,{{Fyear,FMonth,_Fday},_F} ,{{Tyear,TMonth,_Tday},_T});

datediff(quarter,{{Fyear,FMonth,_Fday},_} ,{{Tyear,TMonth,_Tday},_} ) ->
    Yeardiff = (Tyear - Fyear) * 4,
    QuarterDiff = (trunc(((TMonth)-1)/3)+1) - (trunc(((FMonth)-1)/3)+1),
    Yeardiff + QuarterDiff;

datediff(quarter,From ,To ) ->
    {{Fyear,FMonth,_Fday},_F} = string_to_datetime(From),
    {{Tyear,TMonth,_Tday},_T} = string_to_datetime(To),
    datediff(quarter,{{Fyear,FMonth,_Fday},_F} ,{{Tyear,TMonth,_Tday},_T});

datediff(year,{Fyear,_FMonth,_Fday} ,{Tyear,_TMonth,_Tday} ) ->
    Tyear - Fyear;

datediff(year,{{Fyear,_FMonth,_Fday},_} ,{{Tyear,_TMonth,_Tday},_} ) ->
    Tyear - Fyear;

datediff(year,From,To) ->
    {{Fyear,_FMonth,_Fday},_} = string_to_datetime(From),
    {{Tyear,_TMonth,_Tday},_} = string_to_datetime(To),
    Tyear - Fyear.

dateadd(second,Duration,{{Y,Mm,D}, {H, M, S}})->
    NewTimeSecs = calendar:datetime_to_gregorian_seconds({{Y,Mm,D}, {H, M, S}}) + Duration,
    calendar:gregorian_seconds_to_datetime(NewTimeSecs);

dateadd(second,Duration,Stringdate)->
		{{Y,Mm,D}, {H, M, S}} = string_to_datetime(Stringdate),
    dateadd(second,Duration,{{Y,Mm,D}, {H, M, S}});

dateadd(minute,Duration,{{Y,Mm,D}, {H, M, S}})->
    NowSecs = calendar:datetime_to_gregorian_seconds({{Y,Mm,D}, {H, M, S}}),
    Total_Seconds_Now =  Duration * 60 ,
    NewTimeSecs = NowSecs + Total_Seconds_Now,
    calendar:gregorian_seconds_to_datetime(NewTimeSecs);

dateadd(minute,Duration,Stringdate)->
		{{Y,Mm,D}, {H, M, S}} = string_to_datetime(Stringdate),
    dateadd(minute,Duration,{{Y,Mm,D}, {H, M, S}});

dateadd(hour,Duration,{{Y,Mm,D}, {H, M, S}})->
    NowSecs = calendar:datetime_to_gregorian_seconds({{Y,Mm,D}, {H, M, S}}),
    Total_Hours_From_Now =  Duration * 60 * 60,
    NewTimeSecs = NowSecs + Total_Hours_From_Now,
    calendar:gregorian_seconds_to_datetime(NewTimeSecs);

dateadd(hour,Duration,Stringdate)->
		{{Y,Mm,D}, {H, M, S}} = string_to_datetime(Stringdate),
    dateadd(hour,Duration,{{Y,Mm,D}, {H, M, S}});

dateadd(day,Duration,{{Y,Mm,D}, {H, M, S}})->
    NowSecs = calendar:datetime_to_gregorian_seconds({{Y,Mm,D}, {H, M, S}}),
    Twenty_Four_Hours_From_Now = 24 * Duration * 60 * 60,
    NewTimeSecs = NowSecs + Twenty_Four_Hours_From_Now,
    calendar:gregorian_seconds_to_datetime(NewTimeSecs);

dateadd(day,Duration,Stringdate)->
		{{Y,Mm,D}, {H, M, S}} = string_to_datetime(Stringdate),
    dateadd(day,Duration,{{Y,Mm,D}, {H, M, S}});

dateadd(month,0,Next)->
    Next;

dateadd(month,Duration,{{Y,Mm,D}, {H, M, S}})  ->
    case Duration < 0 of
        true ->
            Next = case Mm - 1 > 0 of
                      true ->
                          calendar:datetime_to_gregorian_seconds({fix_day({Y,Mm-1,D}),{H,M,S}});
                      false ->
                          calendar:datetime_to_gregorian_seconds({fix_day({Y-1,12,D}),{H,M,S}})
                   end,
            dateadd(month,Duration+1,calendar:gregorian_seconds_to_datetime(Next));
        false ->
            Next = case Mm + 1 < 13 of
                      true ->
                          calendar:datetime_to_gregorian_seconds({fix_day({Y,Mm+1,D}),{H,M,S}});
                      false ->
                          calendar:datetime_to_gregorian_seconds({fix_day({Y+1,1,D}),{H,M,S}})
                   end,
            dateadd(month,Duration-1,calendar:gregorian_seconds_to_datetime(Next))
    end;

dateadd(month,Duration,Stringdate)  ->
    {{Y,Mm,D}, {H, M, S}} = string_to_datetime(Stringdate),
    dateadd(month,Duration,{{Y,Mm,D}, {H, M, S}});

dateadd(year,Duration,{{Y,Mm,D}, {H, M, S}}) ->
    {{Y+Duration,Mm,D}, {H, M, S}};

dateadd(year,Duration,StringDate) ->
    {{Y,Mm,D}, {H, M, S}} = string_to_datetime(StringDate),
    dateadd(year,Duration,{{Y,Mm,D}, {H, M, S}}).


%%====================================================================
%% Internal functions
%%====================================================================

string_to_date(DateString) ->
    {ok,[A, B, C],_} =io_lib:fread("~d/~d/~d", DateString),
    {validate_date([A, B, C]),{0,0,0}}.

validate_date([A, B, C]) when A > 12, B < 13 ->
    {A,B,C};

validate_date([A, B, C]) when A =< 12 ->
    {C,A,B}.

fix_day({Y,M,D}) ->
    Last = calendar:last_day_of_the_month(Y,M),
    case D > Last of
        true ->
            {Y,M,Last};
        false ->
            {Y,M,D}
    end.

