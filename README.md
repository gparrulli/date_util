date_util
=========

Erlang -  date functions for dateadd, datediff, string_to_date

Example
1> c(date_util).
{ok,date_util}

2> date_util:dateadd(hour,5,"7/6/2012").
{{2012,7,6},{5,0,0}}

3> date_util:dateadd(hour,5,"7/6/2012 08:00:00").
{{2012,7,6},{13,0,0}}

4> date_util:dateadd(hour,-5,"7/6/2012 08:00:00").
{{2012,7,6},{3,0,0}}

5> date_util:dateadd(minute,5,"7/6/2012 08:00:00").
{{2012,7,6},{8,5,0}}

6> date_util:dateadd(second,5,"7/6/2012 08:00:00").
{{2012,7,6},{8,0,5}}

7> date_util:dateadd(day,5,"7/6/2012 08:00:00").
{{2012,7,11},{8,0,0}}

8> date_util:dateadd(month,5,"7/6/2012 08:00:00").
{{2012,12,6},{8,0,0}}

9> date_util:dateadd(year,5,"7/6/2012 08:00:00").
{{2017,7,6},{8,0,0}}

10> date_util:datediff(second,"7/6/2012 08:00:00","7/6/2012 09:00:00").
3600

11> date_util:datediff(minute,"7/6/2012 08:00:00","7/6/2012 09:00:00").
60

12> date_util:datediff(hour,"7/6/2012 08:00:00","7/6/2012 09:00:00").
1

13> date_util:datediff(day,"7/6/2012 08:00:00","7/10/2012 09:00:00").
4

14> date_util:datediff(month,"7/6/2012 08:00:00","10/10/2012 09:00:00").
3

15> date_util:datediff(quarter,"7/6/2012 08:00:00","10/10/2012 09:00:00").
1

16> date_util:datediff(year,"7/6/2012 08:00:00","10/10/2014 09:00:00").
2

