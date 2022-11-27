# Etap 1

## Zaopatrzenie
### Opis
Firma zaopatrzeniowa zajmująca się zarządzaniem zamówień rodzajów oleju na rynku terminowym z dostawą w późniejszym miesiącu lub z dostawą natychmmiastową.

### Założenia
- proces zamówienia rozpoczyna się w momencie złożenia zamiaru nabycia przez fabrykę
- pierwszym krokiem procesu jest otrzymanie zapłaty za zamówienie - nie wykonujemy dalszych kroków w ramach niepowodzenia
- rodzaje dostawy (natychmiastową i późniejszą) traktujemy jako wykluczające się sytuacje - możemy na raz złożyć zamówienie tylko na jeden rodzaj dostawy
- przed wysłaniem zamówienia należy je skompletować i stwierdzić czy jest gotowe do wysyłki
- zadanie: *wysłanie zamówienia* komunikuje się z fabryką w celu powiadomienia o końcowej fazie procesu
### Interakcja ze środowiskiem
1. Firma zaopatrzeniowa komunikuje się z fabryką i wysyła do neiej towary.

## Fabryka
Fabryka jest basenem o 4 torach - Biuro (zajmujące się administracyjną działalnością firmy), Magazyn Fabryczny (przechowujący nieobrobione składniki) oraz dwom reprezentującym linie produkcyjne odpowiednio oleju roślinnego oraz nieroślinnego.

### Zamówienie do fabryki (produkcja)
Zamówienie składa klient bądź dystrybutor chcący uzupełnić braki w magazynach. Po otrzymaniu zamówienia przez Biuro fabryki następuje punkt decyzyjny związany z możliwością jego realizacji. W wypadku braku dostępnych surowców klient jest informowany, transakcja anulowana a zarząd podejmuje decyzję czy należy uzupełnić braki. W wypadku dostępności surowców są one półautomatycznie przekazywane z magazynu na odpowiednią linię produkcyjną, tam automatycznie obrabiane i testowane oraz przesyłane do klienta, który następnie rozlicza się z biurem.

### Przyjęcie zaopatrzenia przez magazyn fabryki
Gdy do fabrycznego magazynu zostanie dostarczony towar, zostanie on  zmagazynowany tj. ułożony w magazynie i wpisany do systemu fabrycznego.

### Sytuacje wyjątkowe
W wypadku awarii na liniach produkcyjnych, np. zepsucie maszyn bądź braku pozytywnego wyniku testu jakości, informowany jest sztab techniczny do obsługi zaistniałej sytuacji.

### Interakcja ze środowiskiem
1. Fabryka składa zamówienia u Firmy Zaopatrzeniowej
2. Fabryka informuje swoich klientów o niedostępności towaru

## Dystrybutor
Dystrybutor jest basenem o jednym torze, który reprezentuje magazyny.

### Otrzymanie zamówienia
Zamówienie składa jeden z klientów. Pierwszą czynnością jest sprawdzenie maksymalnej obsługi dla towaru, ponieważ magazyny nie mogą przekroczyć pewnej ilości obsługiwanego towaru w ciągu miesiąca. W zależności od tego czy przekroczono, albo odsyłamy klientowi wiadomość z odmową albo zaczynamy realizację zamówienia. Realizacja zamówienia polega na wysłaniu towaru i otrzymaniu od klienta zapłaty. Wtedy zamówienie możemy uznać za obsłużone.

### Braki w magazynie
W przypadku braków w magazynie zamawiamy więcej towaru z fabryki. Po otrzymaniu towaru zostanie on ulokowany w magazynie, co kończy proces uzupełnienia braków.

### Interakacja ze środowiskiem
1. Dystrybutor składa zamówienie na więcej towaru od Fabryki
1. Dystrybutor w przypadku odmowy przyjęcia zamówienia wysyła wiadomość z odmową do klienta
1. Dystrybutor w przypadku przyjęcia zamówienia wysyła towar do klienta

## Klienci

### Potrzeba towaru

Klient najpierw wybiera towar jaki chciałby zamówić oraz dostawcę według jego osobistych preferencji. Dostawcą może być fabryka lub dystrybutor. Następnie klient składa zamówienie i czeka na odpowiedź. Jeśli odpowiedź jest pozytywna - klient otrzymuje zakupiony towar i płaci za zamówienie. Jeśli jednak jest negatywna, klient może albo zakończyć proces zamawiania albo zamówić towar z innego źródła.

### Interakcja ze środowiskiem
1. Klient może złożyć zamówienie do Fabryki
1. Klient może złożyć zamówienie do Dystrybutora
1. Klient płaci za zamówienia Dystrybutorowi lub Fabryce