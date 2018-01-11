use HD_SZPITAL
go

create view statystkiStanowiska as
select distinct
stanowisko.Stanowisko,
Cast(avg(Wyplata) OVER (PARTITION BY IdStanowiska) as decimal(10,2)) as [Avg],
Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdStanowiska) as decimal(10,2)) AS Q1,

Cast(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdStanowiska) as decimal(10,2)) AS Q2,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdStanowiska) as decimal(10,2)) AS Q3,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdStanowiska) as decimal(10,2)) -
	Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdStanowiska) as decimal(10,2)) AS [Q3-Q1],


Cast(StDev(Wyplata) OVER (PARTITION BY IdStanowiska) as decimal(10,2)) AS [Odchylenie Standardowe],

(select Min(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdStanowiska = stanowisko.Id) as [Min],

(select Max(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdStanowiska = stanowisko.Id) as [Max],

	
(select ROUND(Max(Wyplata)/Min(Wyplata),2) from [KW_ROK] nkwRok 
	where nkwRok.IdStanowiska = stanowisko.Id) as [Max/Min],

Cast(Cast(SQRT((count(*) OVER (PARTITION BY IdStanowiska))/12) as decimal(10,2)) as varchar) + '%' as [BladStand],

(Count(kwRok.IdStanowiska) OVER (PARTITION BY IdStanowiska)/12) AS [£¹cznie]

from [dbo].Stanowisko stanowisko
left outer join [KW_ROK] kwRok
on stanowisko.Id = kwRok.IdStanowiska