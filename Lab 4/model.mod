# Richard Staszkiewicz idx. 310918
# 07.12.2022
# GNU Public Licence

set PROJEKT;
set LINKS within (PROJEKT cross PROJEKT);
param czas_trwania_n {PROJEKT} >= 0; # czas trwania ka¿dego z zadañ
param l_pracownikow {PROJEKT} >= 0; # iloœæ pracowników dla danego projektu
param minimalny_t {PROJEKT} >= 0; # minimalny czas trwania zadania
param resources >= 0;
param overdue_costs >= 0;

var Tstart {PROJEKT} >= 0;
var TMax;
var optim_time {PROJEKT} >= 0;
var used_resources >= 0;

minimize Tmax: TMax;

subject to Balance {(k, j) in LINKS}: Tstart[k] >= Tstart[j] + optim_time[j];
subject to Max {p in PROJEKT}: TMax >= Tstart[p] + optim_time[p];

subject to availible_resources: used_resources <= resources;

subject to optim_time_constraint_upper {p in PROJEKT}: optim_time[p] <= czas_trwania_n[p];
subject to optim_time_constraint_lower {p in PROJEKT}: optim_time[p] >= minimalny_t[p];

subject to count_used_resources:
	used_resources = sum {p in PROJEKT} (czas_trwania_n[p]-optim_time[p]) * l_pracownikow[p] * overdue_costs;