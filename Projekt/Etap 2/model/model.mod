# Richard Staszkiewicz idx. 310918
# 18.12.2022
# GNU Public Licence

# Faza I. Zakup oleju.
set OLEJ_ROSLINNY;		# nazwy olej�w ro�linnych
set OLEJ_NIEROSLINNY;	# nazwy olej�w niero�linnych
set MIESIACE;			# nazwy miesi�cy

param ceny_oleju_roslinego{MIESIACE, OLEJ_ROSLINNY};
param ceny_oleju_nieroslinego{MIESIACE, OLEJ_NIEROSLINNY};

# blankiet ma form� blankiet[typ oleju, miesi�c zam�wienia, miesi�c dostarczenia] = wielko�� zam�wienia
var blankiet_zamowienia_roslinnego {OLEJ_ROSLINNY, MIESIACE, MIESIACE} default 0;
var blankiet_zamowienia_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE, MIESIACE} default 0;

# suma koszt�w nabycia poszczeg�lnych typ�w oleju
var koszt_nabycia_roslinnego;
var koszt_nabycia_nieroslinnego;

# suma zakupionych olej�w w ka�dym miesi�cu
var ilosc_zakupionego_roslinnego {OLEJ_ROSLINNY, MIESIACE} >= 0;
var ilosc_zakupionego_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE} >= 0;

minimize koszt_nabycia_oleju: koszt_nabycia_roslinnego + koszt_nabycia_nieroslinnego;

subject to count_koszt_nabycia_roslinnego:
	koszt_nabycia_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} ilosc_zakupionego_roslinnego[o, m] * ceny_oleju_roslinego[m, o];

subject to count_koszt_nabycia_nieroslinnego:
	koszt_nabycia_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} ilosc_zakupionego_nieroslinnego[o, m] * ceny_oleju_nieroslinego[m, o];

subject to count_ilosc_zakupionego_roslinnego {o in OLEJ_ROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_roslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_roslinnego[o, m_zam, m_dost];
	
subject to count_ilosc_zakupionego_nieroslinnego {o in OLEJ_NIEROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_nieroslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_nieroslinnego[o, m_zam, m_dost];


# Working with links
# set MAGAZYNY;
# set KLIENCI;
# set LINKS_MK within (MAGAZYNY cross KLIENCI);
# param cost {LINKS};

# param czas_trwania {PROJEKT} >= 0; # czas trwania ka�dego z zada�

# var Tstart {PROJEKT} >= 0;
# var TMax >= 0;
# minimize cos: TMax;

# subject to sth {(k, j) in LINKS}: TMax >= cost[k, j];

# subject to Balance {(k, j) in LINKS}: Tstart[k] >= Tstart[j] + czas_trwania[j];

# subject to Max {p in PROJEKT}: TMax >= Tstart[p] + czas_trwania[p];