# Richard Staszkiewicz idx. 310918
# 07.12.2022
# GNU Public Licence

set PROJEKT;
set LINKS within (PROJEKT cross PROJEKT);
param czas_trwania {PROJEKT} >= 0; # czas trwania ka¿dego z zadañ

var Tstart {PROJEKT} >= 0;
var TMax;
minimize Tmax;

subject to Balance {(k, j) in LINKS}: Tstart[k] >= Tstart[j] + czas_trwania[j];

subject to Max {p in PROJEKT}: TMax >= Tstart[p] + czas_trwania[p];