# Richard Staszkiewicz idx. 310918
# 07.12.2022
# GNU Public Licence

set MAGAZYNY;
set KLIENCI;
set LINKS_MK within (MAGAZYNY cross KLIENCI);
param cost {LINKS};

# param czas_trwania {PROJEKT} >= 0; # czas trwania ka¿dego z zadañ

# var Tstart {PROJEKT} >= 0;
var TMax >= 0;
minimize cos: TMax;

subject to sth {(k, j) in LINKS}: TMax >= cost[k, j];

# subject to Balance {(k, j) in LINKS}: Tstart[k] >= Tstart[j] + czas_trwania[j];

# subject to Max {p in PROJEKT}: TMax >= Tstart[p] + czas_trwania[p];