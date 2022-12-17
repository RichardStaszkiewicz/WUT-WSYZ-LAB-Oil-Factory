# Richard Staszkiewicz idx. 310918
# 18.12.2022
# GNU Public Licence



#-----Faza I. Zakup surowego oleju.-----
set OLEJ_ROSLINNY;		# nazwy olej�w ro�linnych
set OLEJ_NIEROSLINNY;	# nazwy olej�w niero�linnych
set MIESIACE;			# nazwy miesi�cy

#-----Faza II. Przechowywanie surowego oleju.-----
set LINK_M within (MIESIACE cross MIESIACE);	# Format linku: (miesi�c, poprzednik)



#-----Faza I. Zakup surowego oleju.----- ### TODO: Blankiety mog� zamawia� tylko w prz�d
param ceny_oleju_roslinego{MIESIACE, OLEJ_ROSLINNY};
param ceny_oleju_nieroslinego{MIESIACE, OLEJ_NIEROSLINNY};

#-----Faza II. Przechowywanie surowego oleju.----- ### TODO: Policzenie rafinowanego oleju z ka�dej kategorii
param wartosc_startowa_magazynu_na_olej_surowy;
param pojemnosc_magazynu_na_surowy_olej_ka�dego_rodzaju;
param cena_magazynowania_surowego_oleju;



#-----Faza I. Zakup surowego oleju.-----
##suma og�lna koszt�w nabycia oleju u�ywana w funkcji celu
var koszt_nabycia_oleju;
# suma koszt�w nabycia poszczeg�lnych typ�w oleju
var koszt_nabycia_roslinnego;
var koszt_nabycia_nieroslinnego;
# suma zakupionych olej�w w ka�dym miesi�cu
var ilosc_zakupionego_roslinnego {OLEJ_ROSLINNY, MIESIACE} >= 0;
var ilosc_zakupionego_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE} >= 0;
# blankiet ma form� blankiet[typ oleju, miesi�c zam�wienia, miesi�c dostarczenia] = wielko�� zam�wienia
var blankiet_zamowienia_roslinnego {OLEJ_ROSLINNY, MIESIACE, MIESIACE} default 0;
var blankiet_zamowienia_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE, MIESIACE} default 0;

#-----Faza II. Przechowywanie surowego oleju.-----
##suma og�lna koszt�w przechowywania u�ywana w funkcji celu
var koszt_magazynowania_surowego_oleju;
# suma koszt�w przechowywania surowego oleju ro�linnego
var koszt_magazynowania_surowego_roslinnego;
# suma koszt�w przechowywania surowego oleju niero�linnego
var koszt_magazynowania_surowego_nieroslinnego;
# Ile surowego oleju ro�linnego pozostaje na koniec miesi�ca w magazynie
var zmagazynowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE} default 0;
# Ile surowego oleju niero�linnego pozostaje na koniec miesi�ca w magazynie
var zmagazynowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE} default 0;
# Ile surowego oleju ro�linnego zam�wiono w danym miesi�cu
var zamowiony_olej_roslinny {OLEJ_ROSLINNY, MIESIACE};
# Ile surowego oleju niero�linnego zam�wiono w danym miesi�cu
var zamowiony_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE};
# Ile oleju ro�linnego wyrafinowano w danym miesi�cu
var rafinowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE};
# Ile oleju niero�linnego wyrafinowano w danym miesi�cu
var rafinowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE};


#-----Funkcja celu. Maksymalizacja zysku-----
minimize koszt_nabycia_oleju + koszt_magazynowania_surowego_oleju;




#-----Faza I. Zakup surowego oleju.-----
# wyliczanie koszt�w og�lnych nabycia oleju
subject to count_koszt_nabycia_oleju:
	koszt_nabycia_oleju = koszt_nabycia_roslinnego + koszt_nabycia_nieroslinnego;
# wyliczenie koszt�w nabycia oleju ro�linnego
subject to count_koszt_nabycia_roslinnego:
	koszt_nabycia_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} ilosc_zakupionego_roslinnego[o, m] * ceny_oleju_roslinego[m, o];
# wyliczenie koszt�w nabycia oleju niero�linnego
subject to count_koszt_nabycia_nieroslinnego:
	koszt_nabycia_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} ilosc_zakupionego_nieroslinnego[o, m] * ceny_oleju_nieroslinego[m, o];
# wyliczenie ilo�ci zakupionego oleju ro�linnego w danym miesi�cu
subject to count_ilosc_zakupionego_roslinnego {o in OLEJ_ROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_roslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_roslinnego[o, m_zam, m_dost];
# wyliczenie ilo�ci zakupionego oleju niero�linnego w danym miesi�cu
subject to count_ilosc_zakupionego_nieroslinnego {o in OLEJ_NIEROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_nieroslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_nieroslinnego[o, m_zam, m_dost];

#-----Faza II. Przechowywanie surowego oleju.-----
# wyliczenie koszt�w og�lnych magazynowania surowego oleju
subject to count_koszt_magazynowania_surowego_oleju:
	koszt_magazynowania_surowego_oleju = koszt_magazynowania_surowego_roslinnego + 
# wyliczenie koszt�w magazynowania surowego oleju ro�linnego
subject to count_koszt_magazynowania_surowego_roslinnego:
	koszt_magazynowania_surowego_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} zmagazynowany_olej_roslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczenie koszt�w magazynowania surowego oleju niero�linnego
subject to count_koszt_magazynowania_surowego_nieroslinnego:
	koszt_magazynowania_surowego_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} zmagazynowany_olej_nieroslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczanie zmagazynowanego oleju roslinnego
subject to count_zmagazynowany_olej_roslinny {(m, m_pop) in LINK_M, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] = zmagazynowany_olej_roslinny[o, m_pop] + zamowiony_olej_roslinny[o, m] - rafinowany_olej_roslinny[o, m];
# wyliczanie zmagazynowanego oleju roslinnego
subject to count_zmagazynowany_olej_nieroslinny {(m, m_pop) in LINK_M, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] = zmagazynowany_olej_nieroslinny[o, m_pop] + zamowiony_olej_nieroslinny[o, m] - rafinowany_olej_nieroslinny[o, m];
# wyliczenie zam�wionego oleju ro�linnego - wszystkie zam�wienia dostarczane w tym miesi�cu
subject to count_zamowiony_olej_roslinny {o in OLEJ_ROSLINNY, m in MIESIAC}:
	zamowiony_olej_roslinny[o, m] = sum{m_zam in MIESIAC} blankiet_zamowienia_roslinnego[o, m_zam, m]
# wyliczenie zam�wionego oleju niero�linnego - wszystkie zam�wienia dostarczane w tym miesi�cu
subject to count_zamowiony_olej_nieroslinny {o in OLEJ_NIEROSLINNY, m in MIESIAC}:
	zamowiony_olej_nieroslinny[o, m] = sum{m_zam in MIESIAC} blankiet_zamowienia_nieroslinnego[o, m_zam, m]





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