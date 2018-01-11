IF DB_ID (N'HD_SZPITAL') IS NOT NULL  
DROP DATABASE HD_SZPITAL;  
GO  
--tworzenie kostki danych
create database HD_SZPITAL
COLLATE Polish_CI_AS

GO
use HD_SZPITAL
go

create table Komorka(
	Id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Komorka varchar(255)
);
go

create table Czas(
	Id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Rok int NOT NULL,
	Kwartal int NOT NULL,
	Miesiac int NOT NULL
)
go

create table Stanowisko(
	Id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Stanowisko varchar(14)
)
go

create table Pracownik(
	Id int not null PRIMARY KEY,
	RokUrodzenia int NOT NULL,
	Plec char(1),
	GrupaUp varchar(255)
)

create table KW_ROK(
	Id  int not null IDENTITY(1,1) PRIMARY KEY,
	IdPracownika int FOREIGN KEY REFERENCES Pracownik(Id),
	IdCzas int FOREIGN KEY REFERENCES Czas(Id),
	IdKom int FOREIGN KEY REFERENCES Komorka(Id),
	IdStanowiska int FOREIGN KEY REFERENCES Stanowisko(Id),
	PlacaEtat float,
	PlacaMiesieczna float,
	EtatUlam decimal(4,2),
	Wyplata float,
	DniChorobowe float,
	WyplataChorobowe float,
	DniZus float,
	WyplataZus float,
	UzupWyplata float,
	UzupWyplataChor float,
	UzupWyplataZus float	
)

--  uzupelnienie danych w kostce

use [HD_SZPITAL]
go

INSERT INTO [HD_SZPITAL].[dbo].Komorka
select k.KOMORKA from [IED_2017].[dbo].[KOMORKA] as k

INSERT INTO [HD_SZPITAL].[dbo].Stanowisko
select distinct p.STANOWISKO from [IED_2017].[dbo].[PRACOWNIK] as p

INSERT INTO [HD_SZPITAL].[dbo].Pracownik
SELECT ROW_NUMBER() OVER(ORDER BY NREWID ASC) AS Id, p.ROK_UR, p.PLEC, p.GRUPAUP 
FROM [IED_2017].[dbo].[PRACOWNIK] p

INSERT INTO [HD_SZPITAL].[dbo].Czas
select distinct
	CAST(SUBSTRING(kr.RRMM,0,3) AS INT)+2000 as Rok, /*rok*/ 
	ROUND((CAST(SUBSTRING(kr.RRMM,3,2) AS INT) -1)/3,0) +1  as Kwartal, /*kwartal*/
	CAST(SUBSTRING(kr.RRMM,3,2) AS INT) as Miesiac /*miesiac*/
	from [IED_2017].[dbo].[KW_ROK] as kr


	
INSERT INTO [HD_SZPITAL].[dbo].KW_ROK(
IdPracownika,
IdCzas,
IdKom,
IdStanowiska,
PlacaEtat,
PlacaMiesieczna,
EtatUlam,
Wyplata,
DniChorobowe,
WyplataChorobowe,
DniZus,
WyplataZus,
UzupWyplata,
UzupWyplataChor,
UzupWyplataZus 
)
	select
		distinct
		(select top 1  sp.Id from [HD_SZPITAL].[dbo].Pracownik sp
			where sp.GrupaUp = p.GRUPAUP AND sp.Plec = p.PLEC AND sp.RokUrodzenia = p.ROK_UR
		) as IdPracownika,
	
		(select top 1 sp.Id from [HD_SZPITAL].[dbo].Czas sp
			where SP.Miesiac = Cast(SUBSTRING(kr.RRMM,3,2) AS INT)) AS IdCzas,
		
		(select top 1 komorka.Id from [HD_SZPITAL].[dbo].Komorka komorka
			where komorka.Komorka = k.KOMORKA) as IdKom,
	
		(select top 1 stanowisko.Id from [HD_SZPITAL].[dbo].Stanowisko stanowisko
			where stanowisko.Stanowisko = p.STANOWISKO) as IdStanowiska,

		p.PLACA_ETAT,
		p.PLACA_MIES,
		p.ETAT_ULAM,
		kr.WYPLATA + kr.WYP_ZUS + kr.WYP_CHOR as Wyplata,
		kr.DNI_CHOR,
		kr.WYP_CHOR,
		kr.DNI_ZUS,
		kr.WYP_ZUS,
		(select
			case 
				when (WYPLATA/ETAT_ULAM)>p.PLACA_ETAT
					then (kr.WYP_CHOR + kr.WYP_ZUS + kr.WYP_CHOR)/p.ETAT_ULAM
				else
					p.PLACA_ETAT
				end
			)
			as	UzupWyplata,
		kr.WYP_CHOR,
		kr.WYP_ZUS
	from [IED_2017].[dbo].[PRACOWNIK] p
	LEFT OUTER JOIN [IED_2017].[dbo].[KW_ROK] kr
	on p.NREWID = kr.NREWID
	LEFT OUTER JOIN [IED_2017].[dbo].KOMORKA k
	ON k.ID_KOM = p.ID_KOM
	where (kr.WYPLATA + kr.WYP_ZUS + kr.WYP_CHOR)/ETAT_ULAM > 1000 /* warunek wyfiltrujacy wszystkie uzupelnienia wyplaty ponizej 1000 */

	