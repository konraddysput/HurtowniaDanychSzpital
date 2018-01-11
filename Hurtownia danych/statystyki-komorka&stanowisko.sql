use HD_SZPITAL
go

create view statystkiKomorkaStanowisko as
select distinct
stanowisko.Stanowisko,
komorka.Komorka,
Cast(AVG(Wyplata) OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS Avg,

Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS Q1,

Cast(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS Q2,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS Q3,

Cast(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) -
	Cast(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS [Q3-Q1],

Cast(AVG(Wyplata) OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) -
	Cast(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Wyplata) 
		OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS [Avg-Me],


Cast(StDev(Wyplata) OVER (PARTITION BY IdKom, IdStanowiska) as decimal(10,2)) AS [Odchylenie Standardowe],

(select Min(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id AND nkwRok.IdStanowiska = stanowisko.Id) as [Min],

(select Max(Wyplata) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id AND nkwRok.IdStanowiska = stanowisko.Id) as [Max],

	
(select ROUND(Max(Wyplata)/Min(Wyplata),2) from [KW_ROK] nkwRok 
	where nkwRok.IdKom = komorka.Id AND nkwRok.IdStanowiska = stanowisko.Id) as [Max/Min],

Cast(Cast(SQRT((count(*) OVER (PARTITION BY IdKom, IdStanowiska))/12) as decimal(10,2)) as varchar) + '%' as [BladStand],

(Count(kwRok.IdKom) OVER (PARTITION BY IdKom, IdStanowiska)/12) AS [£¹cznie]

from [dbo].Komorka komorka
left outer join [KW_ROK] kwRok
on komorka.Id = kwRok.IdKom
left outer join [dbo].Stanowisko stanowisko
on stanowisko.Id = kwRok.IdStanowiska
where stanowisko.Id is not null
order by [Q3-Q1] desc