# Uk³adamy dietê w taki sposób, by spe³niæ wymagania na po¿ywnoœæ jad³ospisu i zminimalizowaæ 
# tygodniowy koszt diety. Za³ó¿my, ¿e koszty dañ gotowych, z których budujemy jad³ospis s¹ takie 
# jak ni¿ej i daj¹ poni¿sze wartoœci od¿ywcze dla witamin A, C, B1, B2 (w % dziennego zapotrzebowania). 
# W tygodniu wymagane jest przynajmniej 700% ka¿dej z witamin.

set POTRAWY;
set WITAMINY;
param dni >= 0, integer;
param koszt {POTRAWY} >= 0;
param pozywnosc {POTRAWY, WITAMINY};
var Ilosc {POTRAWY} >= 0, integer;

minimize cost: sum {p in POTRAWY} Ilosc[p]*koszt[p];

subject to ograniczenie_witamin {w in WITAMINY}: sum {p in POTRAWY} Ilosc[p]*pozywnosc[p,w] >= 100*dni;