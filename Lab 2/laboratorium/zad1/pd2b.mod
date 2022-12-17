# Richard Staszkiewicz idx. 310918
# 17.11.2022
# GNU Public Licence
# Zak�ad produkcyjny posiada maszyn�, za pomoc� kt�rej mo�e produkowa� trzy rodzaje towar�w: 
# pr�ty, k�towniki, ceowniki. Maszyna mo�e w ci�gu 1 godziny wyprodukowa� 200 ton pr�t�w, 
# lub 140 ton k�townik�w, lub 120 ton ceownik�w. Zak�ad sprzedaje wyprodukowane towary za:
# � pr�ty: 31 z�/ton�
# � k�towniki: 9 z�/ton�
# � ceowniki: 18 z�/ton�
# Jednak tygodniowo zak�ad nie mo�e wyprodukowa� wi�cej ni�:
# � 4000 ton pr�t�w,
# � 3000 ton k�townik�w,
# � 2500 ton ceownik�w.
# Tydzie� pracy zak�adu to 40 godzin. Kierownik zak�adu musi zdecydowa�, ile ton pr�t�w, 
# ile ton k�townik�w i ile ton ceownik�w powinien produkowa� w danym tygodniu, aby uzyska� 
# najwi�kszy mo�liwy zysk.
# Tym razem zak�ad posiada 3 r�ne maszyny � jedn� produkuj�c� tylko k�towniki, drug� produkuj�c� tylko ceowniki 
# a trzeci� tyko pr�ty. Prosz� wyznaczy� godzinowy plan pracy ka�dej z maszyn. Istotne jest, by solver zwr�ci� 
# wynik, kt�ra maszyna powinna produkowa� jak� ilo�� towaru, w konkretnej godzinie. Prosz� dok�adnie zamodelowa� warunek,
# �e w danej godzinie mog� pracowa� maksymalnie 2 maszyny (z uwagi na ograniczenia uk�adu zasilania).

# data:
# set PROD := prety, katowniki, ceowniki;
# param:		produkcja 	cena	limit :=
# prety			200			31		4000
# katowniki		140			9		3000
# ceowniki		120			18		2500;
# param godz := 40;

set PROD;
param M = 50000;
param produkcja {PROD};
param cena {PROD};
param limit {PROD};
param godz;
param limit_maszyn;
# var Ilosc {p in PROD} >= 0, <=limit[p];
var obciazenie {p in PROD, 1 .. godz} >= 0;
var uruchomienie {p in PROD, 1 .. godz} binary;

maximize profit: sum {p in PROD, g in 1 .. godz}  obciazenie[p,g] * cena[p];

# ograniczenie na limit produkcji miesi�cznej
subject to ograniczenie_lmies {p in PROD}: sum {g in 1 .. godz} obciazenie[p,g] <= limit[p];

# ograniczenie na limit produkcji godzinnej
subject to ograniczenie_lgodz {g in 1 .. godz, p in PROD}: obciazenie[p,g] <= produkcja[p];

# ograniczenie na ustawienie uruchomienia dla obci��enia > 0
subject to ograniczenie_uobc {g in 1 .. godz, p in PROD}: obciazenie[p,g] <= uruchomienie[p,g] * M;

# ograniczenie na dwie maszyny
subject to ograniczenie_masz {g in 1 .. godz}: sum {p in PROD} uruchomienie[p,	g] <= limit_maszyn;