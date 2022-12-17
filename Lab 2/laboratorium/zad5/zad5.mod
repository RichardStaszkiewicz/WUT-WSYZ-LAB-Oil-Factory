# Uk�adamy diet� w taki spos�b, by spe�ni� wymagania na po�ywno�� jad�ospisu i zminimalizowa� 
# tygodniowy koszt diety. Za��my, �e koszty da� gotowych, z kt�rych budujemy jad�ospis s� takie 
# jak ni�ej i daj� poni�sze warto�ci od�ywcze dla witamin A, C, B1, B2 (w % dziennego zapotrzebowania). 
# W tygodniu wymagane jest przynajmniej 700% ka�dej z witamin.

set POTRAWY;
set WITAMINY;
param dni >= 0, integer;
param koszt {POTRAWY} >= 0;
param pozywnosc {POTRAWY, WITAMINY};
var Ilosc {POTRAWY} >= 0, integer;

minimize cost: sum {p in POTRAWY} Ilosc[p]*koszt[p];

subject to ograniczenie_witamin {w in WITAMINY}: sum {p in POTRAWY} Ilosc[p]*pozywnosc[p,w] >= 100*dni;