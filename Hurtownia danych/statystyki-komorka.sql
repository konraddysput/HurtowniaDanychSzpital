use HD_SZPITAL
go

create view statystkiKomorka as
select distinct
komorka.Id,
komorka.Komorka,
Cast(avg(Wyplata) OVER (PARTITION BY IdKom) as decimal(10,2)) as [Avg],
Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom) as decimal(10,2)) AS Q1,

Cast(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom) as decimal(10,2)) AS Q2,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom) as decimal(10,2)) AS Q3,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom) as decimal(10,2)) -
	Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom) as decimal(10,2)) AS [Q3-Q1],


Cast(StDev(Wyplata) OVER (PARTITION BY IdKom) as decimal(10,2)) AS [Odchylenie Standardowe],

(select Min(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id) as [Min],

(select Max(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id) as [Max],

	
(select ROUND(Max(Wyplata)/Min(Wyplata),2) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id) as [Max/Min],

Cast(Cast(SQRT((count(*) OVER (PARTITION BY IdKom))/12) as decimal(10,2)) as varchar) + '%' as [BladStand],

(Count(kwRok.IdKom) OVER (PARTITION BY IdKom)/12) AS [£¹cznie]

from [dbo].Komorka komorka
left outer join [KW_ROK] kwRok
on komorka.Id = kwRok.IdKom