use HD_SZPITAL
go
create view IED_PerPracownik as 
select distinct
kwRok.Id,
stanowisko.Stanowisko as Stanowisko,
pracownik.Plec,
pracownik.GrupaUp,
komorka.Komorka as Komorka,
	(select ROUND(Avg(nKwRok.Wyplata),2) from [dbo].KW_ROK as nKwRok
		where nKwRok.IdPracownika = kwRok.IdPracownika) as [Œrednia],

	(select Min(nKwRok.Wyplata) from [dbo].KW_ROK as nKwRok
		where nKwRok.IdPracownika = kwRok.IdPracownika) as [Min],

	(select Max(nKwRok.Wyplata) from [dbo].KW_ROK as nKwRok
		where nKwRok.IdPracownika = kwRok.IdPracownika) as [Max],

	(select ROUND(Max(nKwRok.Wyplata)/Min(nKwRok.Wyplata),2) from [dbo].KW_ROK as nKwRok
		where nKwRok.IdPracownika = kwRok.IdPracownika) as [Max/Min]


from [dbo].KW_ROK kwRok 
left outer join [dbo].Stanowisko stanowisko
on stanowisko.Id = kwRok.IdStanowiska
left outer join [dbo].Komorka as komorka
on kwRok.IdKom= komorka.Id
left outer join [dbo].Pracownik pracownik
on kwRok.IdPracownika = pracownik.Id