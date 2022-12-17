# Proszê utworzyæ i rozwi¹zaæ model optymalizacyjny (transportowy), który zaplanuje ile [hl] 
# piwa ma zostaæ wys³ane z poszczególnych browarów do poszczególnych hurtowni, optymalizuj¹c koszty. 
# Proszê u¿yæ zbiorów i pliku z danymi.

# The same to zad3

set BROWARY;
set HURTOWNIE;
param mozliwosci {BROWARY};
param zapotrzebowanie {HURTOWNIE};
param transport {HURTOWNIE, BROWARY};
var Ilosc {h in HURTOWNIE, b in BROWARY} >= 0;

minimize cost: sum {h in HURTOWNIE, b in BROWARY} Ilosc[h, b] * transport[h, b];

subject to ograniczenie_nasycenia {h in HURTOWNIE}: sum {b in BROWARY} Ilosc[h, b] >= zapotrzebowanie[h];

subject to ograniczenie_produkcji {b in BROWARY}: sum {h in HURTOWNIE} Ilosc [h, b] <= mozliwosci[b];