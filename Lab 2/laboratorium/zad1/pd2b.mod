# Richard Staszkiewicz idx. 310918
# 17.11.2022
# GNU Public Licence
# Zak³ad produkcyjny posiada maszynê, za pomoc¹ której mo¿e produkowaæ trzy rodzaje towarów: 
# prêty, k¹towniki, ceowniki. Maszyna mo¿e w ci¹gu 1 godziny wyprodukowaæ 200 ton prêtów, 
# lub 140 ton k¹towników, lub 120 ton ceowników. Zak³ad sprzedaje wyprodukowane towary za:
# • prêty: 31 z³/tonê
# • k¹towniki: 9 z³/tonê
# • ceowniki: 18 z³/tonê
# Jednak tygodniowo zak³ad nie mo¿e wyprodukowaæ wiêcej ni¿:
# • 4000 ton prêtów,
# • 3000 ton k¹towników,
# • 2500 ton ceowników.
# Tydzieñ pracy zak³adu to 40 godzin. Kierownik zak³adu musi zdecydowaæ, ile ton prêtów, 
# ile ton k¹towników i ile ton ceowników powinien produkowaæ w danym tygodniu, aby uzyskaæ 
# najwiêkszy mo¿liwy zysk.
# Tym razem zak³ad posiada 3 ró¿ne maszyny – jedn¹ produkuj¹c¹ tylko k¹towniki, drug¹ produkuj¹c¹ tylko ceowniki 
# a trzeci¹ tyko prêty. Proszê wyznaczyæ godzinowy plan pracy ka¿dej z maszyn. Istotne jest, by solver zwróci³ 
# wynik, która maszyna powinna produkowaæ jak¹ iloœæ towaru, w konkretnej godzinie. Proszê dok³adnie zamodelowaæ warunek,
# ¿e w danej godzinie mog¹ pracowaæ maksymalnie 2 maszyny (z uwagi na ograniczenia uk³adu zasilania).

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

# ograniczenie na limit produkcji miesiêcznej
subject to ograniczenie_lmies {p in PROD}: sum {g in 1 .. godz} obciazenie[p,g] <= limit[p];

# ograniczenie na limit produkcji godzinnej
subject to ograniczenie_lgodz {g in 1 .. godz, p in PROD}: obciazenie[p,g] <= produkcja[p];

# ograniczenie na ustawienie uruchomienia dla obci¹¿enia > 0
subject to ograniczenie_uobc {g in 1 .. godz, p in PROD}: obciazenie[p,g] <= uruchomienie[p,g] * M;

# ograniczenie na dwie maszyny
subject to ograniczenie_masz {g in 1 .. godz}: sum {p in PROD} uruchomienie[p,	g] <= limit_maszyn;