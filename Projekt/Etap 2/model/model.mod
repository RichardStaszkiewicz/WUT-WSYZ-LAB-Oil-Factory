# Richard Staszkiewicz idx. 310918
# 18.12.2022
# GNU Public Licence



#-----Faza I. Zakup surowego oleju.-----
set OLEJ_ROSLINNY;		# nazwy olejów roœlinnych
set OLEJ_NIEROSLINNY;	# nazwy olejów nieroœlinnych
set MIESIACE;			# nazwy miesiêcy

#-----Faza II. Przechowywanie surowego oleju.-----
set LINK_M within (MIESIACE cross MIESIACE);	# Format linku: (miesi¹c, poprzednik)



#-----Faza I. Zakup surowego oleju.----- ### TODO: Blankiety mog¹ zamawiaæ tylko w przód
param ceny_oleju_roslinego{MIESIACE, OLEJ_ROSLINNY};
param ceny_oleju_nieroslinego{MIESIACE, OLEJ_NIEROSLINNY};

#-----Faza II. Przechowywanie surowego oleju.----- ### TODO: Policzenie rafinowanego oleju z ka¿dej kategorii
param wartosc_startowa_magazynu_na_olej_surowy;
param pojemnosc_magazynu_na_surowy_olej_ka¿dego_rodzaju;
param cena_magazynowania_surowego_oleju;



#-----Faza I. Zakup surowego oleju.-----
##suma ogólna kosztów nabycia oleju u¿ywana w funkcji celu
var koszt_nabycia_oleju;
# suma kosztów nabycia poszczególnych typów oleju
var koszt_nabycia_roslinnego;
var koszt_nabycia_nieroslinnego;
# suma zakupionych olejów w ka¿dym miesi¹cu
var ilosc_zakupionego_roslinnego {OLEJ_ROSLINNY, MIESIACE} >= 0;
var ilosc_zakupionego_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE} >= 0;
# blankiet ma formê blankiet[typ oleju, miesi¹c zamówienia, miesi¹c dostarczenia] = wielkoœæ zamówienia
var blankiet_zamowienia_roslinnego {OLEJ_ROSLINNY, MIESIACE, MIESIACE} default 0;
var blankiet_zamowienia_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE, MIESIACE} default 0;

#-----Faza II. Przechowywanie surowego oleju.-----
##suma ogólna kosztów przechowywania u¿ywana w funkcji celu
var koszt_magazynowania_surowego_oleju;
# suma kosztów przechowywania surowego oleju roœlinnego
var koszt_magazynowania_surowego_roslinnego;
# suma kosztów przechowywania surowego oleju nieroœlinnego
var koszt_magazynowania_surowego_nieroslinnego;
# Ile surowego oleju roœlinnego pozostaje na koniec miesi¹ca w magazynie
var zmagazynowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE} default 0;
# Ile surowego oleju nieroœlinnego pozostaje na koniec miesi¹ca w magazynie
var zmagazynowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE} default 0;
# Ile surowego oleju roœlinnego zamówiono w danym miesi¹cu
var zamowiony_olej_roslinny {OLEJ_ROSLINNY, MIESIACE};
# Ile surowego oleju nieroœlinnego zamówiono w danym miesi¹cu
var zamowiony_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE};
# Ile oleju roœlinnego wyrafinowano w danym miesi¹cu
var rafinowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE};
# Ile oleju nieroœlinnego wyrafinowano w danym miesi¹cu
var rafinowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE};


#-----Funkcja celu. Maksymalizacja zysku-----
minimize koszt_nabycia_oleju + koszt_magazynowania_surowego_oleju;




#-----Faza I. Zakup surowego oleju.-----
# wyliczanie kosztów ogólnych nabycia oleju
subject to count_koszt_nabycia_oleju:
	koszt_nabycia_oleju = koszt_nabycia_roslinnego + koszt_nabycia_nieroslinnego;
# wyliczenie kosztów nabycia oleju roœlinnego
subject to count_koszt_nabycia_roslinnego:
	koszt_nabycia_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} ilosc_zakupionego_roslinnego[o, m] * ceny_oleju_roslinego[m, o];
# wyliczenie kosztów nabycia oleju nieroœlinnego
subject to count_koszt_nabycia_nieroslinnego:
	koszt_nabycia_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} ilosc_zakupionego_nieroslinnego[o, m] * ceny_oleju_nieroslinego[m, o];
# wyliczenie iloœci zakupionego oleju roœlinnego w danym miesi¹cu
subject to count_ilosc_zakupionego_roslinnego {o in OLEJ_ROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_roslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_roslinnego[o, m_zam, m_dost];
# wyliczenie iloœci zakupionego oleju nieroœlinnego w danym miesi¹cu
subject to count_ilosc_zakupionego_nieroslinnego {o in OLEJ_NIEROSLINNY, m_zam in MIESIACE}:
	ilosc_zakupionego_nieroslinnego[o, m_zam] = sum{m_dost in MIESIACE} blankiet_zamowienia_nieroslinnego[o, m_zam, m_dost];

#-----Faza II. Przechowywanie surowego oleju.-----
# wyliczenie kosztów ogólnych magazynowania surowego oleju
subject to count_koszt_magazynowania_surowego_oleju:
	koszt_magazynowania_surowego_oleju = koszt_magazynowania_surowego_roslinnego + 
# wyliczenie kosztów magazynowania surowego oleju roœlinnego
subject to count_koszt_magazynowania_surowego_roslinnego:
	koszt_magazynowania_surowego_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} zmagazynowany_olej_roslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczenie kosztów magazynowania surowego oleju nieroœlinnego
subject to count_koszt_magazynowania_surowego_nieroslinnego:
	koszt_magazynowania_surowego_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} zmagazynowany_olej_nieroslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczanie zmagazynowanego oleju roslinnego
subject to count_zmagazynowany_olej_roslinny {(m, m_pop) in LINK_M, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] = zmagazynowany_olej_roslinny[o, m_pop] + zamowiony_olej_roslinny[o, m] - rafinowany_olej_roslinny[o, m];
# wyliczanie zmagazynowanego oleju roslinnego
subject to count_zmagazynowany_olej_nieroslinny {(m, m_pop) in LINK_M, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] = zmagazynowany_olej_nieroslinny[o, m_pop] + zamowiony_olej_nieroslinny[o, m] - rafinowany_olej_nieroslinny[o, m];
# wyliczenie zamówionego oleju roœlinnego - wszystkie zamówienia dostarczane w tym miesi¹cu
subject to count_zamowiony_olej_roslinny {o in OLEJ_ROSLINNY, m in MIESIAC}:
	zamowiony_olej_roslinny[o, m] = sum{m_zam in MIESIAC} blankiet_zamowienia_roslinnego[o, m_zam, m]
# wyliczenie zamówionego oleju nieroœlinnego - wszystkie zamówienia dostarczane w tym miesi¹cu
subject to count_zamowiony_olej_nieroslinny {o in OLEJ_NIEROSLINNY, m in MIESIAC}:
	zamowiony_olej_nieroslinny[o, m] = sum{m_zam in MIESIAC} blankiet_zamowienia_nieroslinnego[o, m_zam, m]





# Working with links
# set MAGAZYNY;
# set KLIENCI;
# set LINKS_MK within (MAGAZYNY cross KLIENCI);
# param cost {LINKS};

# param czas_trwania {PROJEKT} >= 0; # czas trwania ka¿dego z zadañ

# var Tstart {PROJEKT} >= 0;
# var TMax >= 0;
# minimize cos: TMax;

# subject to sth {(k, j) in LINKS}: TMax >= cost[k, j];

# subject to Balance {(k, j) in LINKS}: Tstart[k] >= Tstart[j] + czas_trwania[j];

# subject to Max {p in PROJEKT}: TMax >= Tstart[p] + czas_trwania[p];