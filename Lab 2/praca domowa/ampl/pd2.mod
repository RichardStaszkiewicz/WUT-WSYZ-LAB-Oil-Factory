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

# data:
# set PROD := prety, katowniki, ceowniki;
# param:		produkcja 	cena	limit :=
# prety			200			31		4000
# katowniki		140			9		3000
# ceowniki		120			18		2500;
# param godz := 40;

set PROD;
param produkcja {PROD};
param cena {PROD};
param limit {PROD};
param godz;
var Ilosc {p in PROD} >= 0, <=limit[p];

maximize profit: sum {p in PROD} Ilosc[p]*cena[p];

subject to ograniczenie_godz: sum {p in PROD} Ilosc[p]/produkcja[p]<=godz; 