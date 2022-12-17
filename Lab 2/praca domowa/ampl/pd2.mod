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