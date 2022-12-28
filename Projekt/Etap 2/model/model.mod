# Richard Staszkiewicz idx. 310918
# 18.12.2022
# GNU Public Licence
# execute with: option solver cplex; followed by reset; model model.mod; data data_cleared.dat; solve;

# TODO:
# Blankiety mog¹ zamawiaæ tylko w przód
# Policzenie rafinowanego oleju z ka¿dej kategorii




################### ZBIORY #####################
#-----Faza I. Zakup surowego oleju.-----
set OLEJ_ROSLINNY;		# nazwy olejów roœlinnych
set OLEJ_NIEROSLINNY;	# nazwy olejów nieroœlinnych
set MIESIACE;			# nazwy miesiêcy

#-----Faza II. Przechowywanie surowego oleju.-----
set LINK_M within (MIESIACE cross MIESIACE);	# Format linku: (miesi¹c, poprzednik)
set MIESIACE_KONCOWE within MIESIACE;

#-----Faza IV. Dystrybucja rafinowanego oleju.-----
set DOSTAWCY;
set KLIENCI;


################### PARAMETRY #####################
#-----Faza I. Zakup surowego oleju.----- 
param ceny_oleju_roslinego{MIESIACE, OLEJ_ROSLINNY} >= 0;
param ceny_oleju_nieroslinego{MIESIACE, OLEJ_NIEROSLINNY} >= 0;

#-----Faza II. Przechowywanie surowego oleju.-----
param cena_magazynowania_surowego_oleju >= 0;
param czy_pierwszy_miesiac {MIESIACE} binary; # WskaŸnik binarny, czy dany miesi¹c jest pierwszy.
param rafinacja_oleju_roslinnego_max >= 0;
param rafinacja_oleju_nieroslinnego_max >= 0;
param wartosc_startowa_magazynu_na_olej_surowy >= 0;
param pojemnosc_magazynu_na_surowy_olej_ka¿dego_rodzaju >= 0;

#-----Faza IV. Dystrybucja rafinowanego oleju.-----
param koszt_transportu_firma_dostawca {DOSTAWCY} >= 0;
param is_conection {KLIENCI, DOSTAWCY} binary; # wskaŸnik binarny po³¹czenia miêdzy klientem a dostawc¹
param cena_transportu_do_klientow {KLIENCI, DOSTAWCY} >= 0;

#-----Faza V. Liczenie zysku.-----
param cena_produktu;

################### ZMIENNE #####################
#-----Faza I. Zakup surowego oleju.-----
##suma ogólna kosztów nabycia oleju u¿ywana w funkcji celu
var koszt_nabycia_oleju >= 0;
# suma kosztów nabycia poszczególnych typów oleju
var koszt_nabycia_roslinnego >= 0;
var koszt_nabycia_nieroslinnego >= 0;
# suma zakupionych olejów w ka¿dym miesi¹cu
var ilosc_zakupionego_roslinnego {OLEJ_ROSLINNY, MIESIACE} >= 0;
var ilosc_zakupionego_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE} >= 0;
# blankiet ma formê blankiet[typ oleju, miesi¹c zamówienia, miesi¹c dostarczenia] = wielkoœæ zamówienia
var blankiet_zamowienia_roslinnego {OLEJ_ROSLINNY, MIESIACE, MIESIACE} >= 0 default 0;
var blankiet_zamowienia_nieroslinnego {OLEJ_NIEROSLINNY, MIESIACE, MIESIACE} >= 0 default 0;

#-----Faza II. Przechowywanie surowego oleju.-----
##suma ogólna kosztów przechowywania u¿ywana w funkcji celu
var koszt_magazynowania_surowego_oleju >= 0;
# suma kosztów przechowywania surowego oleju roœlinnego
var koszt_magazynowania_surowego_roslinnego >= 0;
# suma kosztów przechowywania surowego oleju nieroœlinnego
var koszt_magazynowania_surowego_nieroslinnego >= 0;
# Ile surowego oleju roœlinnego pozostaje na koniec miesi¹ca w magazynie
var zmagazynowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE} default 0;
# Ile surowego oleju nieroœlinnego pozostaje na koniec miesi¹ca w magazynie
var zmagazynowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE} default 0;
# Ile surowego oleju roœlinnego zamówiono w danym miesi¹cu
var zamowiony_olej_roslinny {OLEJ_ROSLINNY, MIESIACE} >= 0;
# Ile surowego oleju nieroœlinnego zamówiono w danym miesi¹cu
var zamowiony_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE} >= 0;
# Ile oleju roœlinnego wyrafinowano w danym miesi¹cu
var rafinowany_olej_roslinny {OLEJ_ROSLINNY, MIESIACE} >= 0;
# Ile oleju nieroœlinnego wyrafinowano w danym miesi¹cu
var rafinowany_olej_nieroslinny {OLEJ_NIEROSLINNY, MIESIACE} >= 0;

#-----Faza III. Rafinacja oleju.----- # constrainty na twardoœæ dorobiæ
var wyprodukowany_olej {MIESIACE} >= 0;

#-----Faza IV. Dystrybucja rafinowanego oleju.-----
var koszt_dystrybucji >= 0;
var koszt_dystrybucji_do_dostawcy {DOSTAWCY, MIESIACE} >= 0;
var koszt_dystrybucji_do_klientow {KLIENCI, MIESIACE} >= 0;
var zapelnienie_dostawcy_magazynow {DOSTAWCY, MIESIACE} >= 0;
var olej_dostarczony_klientom {KLIENCI, DOSTAWCY, MIESIACE} >= 0;

#-----Faza V. Liczenie zysku.-----
var zysk >= 0;


################### FUNKCJA STRATY #####################
#-----Funkcja celu. Maksymalizacja zysku-----
maximize f_celu: zysk - koszt_nabycia_oleju - koszt_magazynowania_surowego_oleju - koszt_dystrybucji;



################### OBLICZANIE ZMIENNYCH #####################
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
	koszt_magazynowania_surowego_oleju = koszt_magazynowania_surowego_roslinnego + koszt_magazynowania_surowego_nieroslinnego;
# wyliczenie kosztów magazynowania surowego oleju roœlinnego
subject to count_koszt_magazynowania_surowego_roslinnego:
	koszt_magazynowania_surowego_roslinnego = sum{o in OLEJ_ROSLINNY, m in MIESIACE} zmagazynowany_olej_roslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczenie kosztów magazynowania surowego oleju nieroœlinnego
subject to count_koszt_magazynowania_surowego_nieroslinnego:
	koszt_magazynowania_surowego_nieroslinnego = sum{o in OLEJ_NIEROSLINNY, m in MIESIACE} zmagazynowany_olej_nieroslinny[o, m] * cena_magazynowania_surowego_oleju;
# wyliczanie zmagazynowanego oleju roslinnego
subject to count_zmagazynowany_olej_roslinny {(m, m_pop) in LINK_M, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] = zmagazynowany_olej_roslinny[o, m_pop] + zamowiony_olej_roslinny[o, m] - rafinowany_olej_roslinny[o, m];
# wyliczanie zmagazynowanego oleju roslinnego w styczniu
subject to count_zmagazynowany_olej_roslinny_edge {m in MIESIACE, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] >= czy_pierwszy_miesiac[m]*wartosc_startowa_magazynu_na_olej_surowy + zamowiony_olej_roslinny[o, m] - rafinowany_olej_roslinny[o, m];
# wyliczanie zmagazynowanego oleju nieroslinnego
subject to count_zmagazynowany_olej_nieroslinny {(m, m_pop) in LINK_M, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] = zmagazynowany_olej_nieroslinny[o, m_pop] + zamowiony_olej_nieroslinny[o, m] - rafinowany_olej_nieroslinny[o, m];
# wyliczanie zmagazynowanego oleju nieroslinnego w styczniu
subject to count_zmagazynowany_olej_nieroslinny_edge {m in MIESIACE, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] >= czy_pierwszy_miesiac[m]*wartosc_startowa_magazynu_na_olej_surowy + zamowiony_olej_nieroslinny[o, m] - rafinowany_olej_nieroslinny[o, m];
# wyliczenie zamówionego oleju roœlinnego - wszystkie zamówienia dostarczane w tym miesi¹cu
subject to count_zamowiony_olej_roslinny {o in OLEJ_ROSLINNY, m in MIESIACE}:
	zamowiony_olej_roslinny[o, m] = sum{m_zam in MIESIACE} blankiet_zamowienia_roslinnego[o, m_zam, m];
# wyliczenie zamówionego oleju nieroœlinnego - wszystkie zamówienia dostarczane w tym miesi¹cu
subject to count_zamowiony_olej_nieroslinny {o in OLEJ_NIEROSLINNY, m in MIESIACE}:
	zamowiony_olej_nieroslinny[o, m] = sum{m_zam in MIESIACE} blankiet_zamowienia_nieroslinnego[o, m_zam, m];

#-----Faza III. Rafinacja oleju.-----
# wyliczenie ca³oœci wyprodukowanego oleju w danym miesi¹cu
subject to count_wyprodukowany_olej {m in MIESIACE}:
	wyprodukowany_olej[m] = (sum{o in OLEJ_ROSLINNY} rafinowany_olej_roslinny[o, m]) + (sum{o in OLEJ_NIEROSLINNY}rafinowany_olej_nieroslinny[o, m]);

#-----Faza IV. Dystrybucja rafinowanego oleju.-----
# wyliczenie ogólnego kosztu dystrybucji do funkcji celu
subject to count_koszt_dystrybucji:
	koszt_dystrybucji = (sum{d in DOSTAWCY, m in MIESIACE} koszt_dystrybucji_do_dostawcy[d, m]) + (sum{k in KLIENCI, m in MIESIACE} koszt_dystrybucji_do_klientow[k, m]);
# wyliczenie kosztu dystrybucji do dostawców
subject to count_koszt_dystrybucji_do_dostawcy {d in DOSTAWCY, m in MIESIACE}:
	koszt_dystrybucji_do_dostawcy[d, m] = zapelnienie_dostawcy_magazynow[d, m] * koszt_transportu_firma_dostawca[d];
# wyliczenie kosztu dystrybucji do klientów
subject to count_koszt_dystrybucji_do_klientow {k in KLIENCI, m in MIESIACE}:
	koszt_dystrybucji_do_klientow[k, m] = sum{d in DOSTAWCY} olej_dostarczony_klientom[k, d, m] * is_conection[k, d] * cena_transportu_do_klientow[k, d];

#-----Faza V. Liczenie zysku.-----
# obliczenie zysku ze sprzeda¿y
subject to count_zysk:
	zysk = sum{k in KLIENCI, d in DOSTAWCY, m in MIESIACE} olej_dostarczony_klientom[k, d, m] * is_conection[k, d] * cena_produktu;

################### OGRANICZENIA FUNKCJONALNE ####################
# [typ oleju, miesi¹c zamówienia, miesi¹c dostarczenia]
# ograniczenie na zamawianie w przesz³oœæ oleju roslinnego
subject to blankiet_roslinny_zamawia_w_przyszlosc {o in OLEJ_ROSLINNY, m_zam in MIESIACE}
	sum{delta in 1..m_zam-1}  blankiet_zamowienia_roslinnego[o, m_zam, delta] = 0;
# ograniczenie na zamawianie w przesz³oœæ oleju nieroslinnego
subject to blankiet_nieroslinny_zamawia_w_przyszlosc {o in OLEJ_NIEROSLINNY, m_zam in MIESIACE}
	sum{delta in 1..m_zam-1}  blankiet_zamowienia_nieroslinnego[o, m_zam, delta] = 0;

################### OGRANICZENIA W£AŒCIWE #####################
# ograniczenia na maksymaln¹ rafinacjê olejów roœlinnych
subject to rafinacja_roslinnego_constraint {m in MIESIACE}:
	sum{o in OLEJ_ROSLINNY} rafinowany_olej_roslinny[o, m] <= rafinacja_oleju_roslinnego_max;
# ograniczenia na maksymaln¹ rafinacjê olejów nieroœlinnych
subject to rafinacja_nieroslinnego_constraint {m in MIESIACE}:
	sum{o in OLEJ_NIEROSLINNY} rafinowany_olej_nieroslinny[o, m] <= rafinacja_oleju_nieroslinnego_max;
# ograniczenie na maksymaln¹ pojemnoœæ magazynów na roœlinny olej surowy
subject to pojemnosc_magazynow_na_olej_roslinny_surowy {m in MIESIACE, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] <= pojemnosc_magazynu_na_surowy_olej_ka¿dego_rodzaju;
# ograniczenie na maksymaln¹ pojemnoœæ magazynów na nieroœlinny olej surowy
subject to pojemnosc_magazynow_na_olej_nieroslinny_surowy {m in MIESIACE, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] <= pojemnosc_magazynu_na_surowy_olej_ka¿dego_rodzaju;
# ograniczenie na surowiec roœlinny pozosta³y w magazynach w czerwcu
subject to odpowiednie_zapasy_surowego_oleju_roslinnego_na_koniec_produkcji {m in MIESIACE_KONCOWE, o in OLEJ_ROSLINNY}:
	zmagazynowany_olej_roslinny[o, m] >= wartosc_startowa_magazynu_na_olej_surowy;
# ograniczenie na surowiec nieroœlinny pozosta³y w magazynach w czerwcu
subject to odpowiednie_zapasy_surowego_oleju_nieroslinnego_na_koniec_produkcji {m in MIESIACE_KONCOWE, o in OLEJ_NIEROSLINNY}:
	zmagazynowany_olej_nieroslinny[o, m] >= wartosc_startowa_magazynu_na_olej_surowy;
	