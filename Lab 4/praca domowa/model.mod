# Richard Staszkiewicz idx. 310918
# 16.12.2022
# GNU Public Licence
# before starting use: options solver cplex;
# to start please use: reset; model model.mod; data [data.dat]; solve;
# to view results use: display TMax, startT, allocated_resources, optimT;

set TASKS;
set LINKS within (TASKS cross TASKS); # Link format: (operation, predecessor)
param nominalT {TASKS} >= 0;
param shortenC {TASKS} >= 0;
param minimalT {TASKS} >= 0;
param resources >=0;

var optimT {TASKS} integer; # time spend for each task after using resources
var allocated_resources {TASKS} >= 0; # resouces allocated at each task
var startT {TASKS} >= 0; # start moment of each task
var used_resources >= 0; # resources used to decrease task times
var TMax >= 0; # time spend to compleate all tasks

minimize f_celu: TMax;

subject to inbound_under_constraint {t in TASKS}: optimT[t] <= nominalT[t];
subject to inbound_over_constraint {t in TASKS}: optimT[t] >= minimalT[t];
subject to resources_constraint: used_resources <= resources;
subject to balance_constraint {(k, j) in LINKS}: startT[k] >= startT[j] + optimT[j];

subject to count_tmax {t in TASKS}: TMax >= startT[t] + optimT[t];
subject to count_used_resources: used_resources = sum{t in TASKS} allocated_resources[t];
subject to count_allocated_resources {t in TASKS}: allocated_resources[t] = (nominalT[t] - optimT[t])*shortenC[t];