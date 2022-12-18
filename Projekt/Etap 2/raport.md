# **Etap 2**

## **Założenia**
- Mieszanie i twardość oleju roślinnnego - zmieniamy współczynniki, bo obecne są bez sensu (propozycja zmiany ograniczenia w nawiązanu do wymiany mailowej)
- Preferencje - klient zamawia tylko od tego dostawcy, na którym ma zdefiniowną preferencje 
- Zapotrzebowanie na towar - dowolny typ oleju, bez podziału na kategoie roślinny/nieroślinny, w fazie trasportu zostaje zagregowany do ogólnej masy urobku
- Ilość wysyłanego przez fabrykę towaru w danych modelowana empirycznie nie podlega ograniczeniu
---
## **Model programowania matemtycznego**
<br />

### **Zmienne decyzyjne**

$$$$
| Nazwa zmiennej | Opis |
|:--------------:|:-----|
| $x_{DP}$ | Dostarczony produkt zależny od klientów, dostawcy oraz miesiąca, w którym dostarczamy produkt |
| $x_{ZR}$ | Zakupiony olej roślinny zależny od typu oleju roślinnego oraz miesiąca, w którym jest on zakupiony (w tonach) |
| $x_{ZO}$ | Zakupiony olej nieroślinny zależny od typu oleju roślinnego oraz miesiąca, w którym jest on zakupiony (w tonach) |
| $x_{MR}$ | Zmagazynowany olej roślinny zależny od typu oleju roślinnego oraz miesiąca, w którym jest on zakupiony |
| $x_{MO}$ | Zmagazynowany olej nieroślinny zależny od typu oleju roślinnego oraz miesiąca, w którym jest on zakupiony |
| $x_{ZM}$ | Zapełnienie magazynów zależne od dostawcy oraz miesiąca |

<br />

### **Ograniczenia**
<br />

> **Dla każdego miesiąca**
>
>$ x_{ZR} \leq 200 $
>
>$ x_{ZO} \leq 250 $
>
>$ x_{MR},\hspace{1 mm} x_{MO} \leq 1000 $

<br />

> **W czerwcu**
>
>$ x_{MR},\hspace{1 mm} x_{MO} \geq 500 $

<br />

> **Dla każdego magazynu/fabryki**
>
>$ x_{DP} \leq p_M $

<br />

> **Dla każdego klienta**
>
>$ x_{DP} \leq z_K $

<br />

>$ x_{DP},\hspace{1 mm} x_{ZR},\hspace{1 mm} x_{ZO},\hspace{1 mm} x_{MR},\hspace{1 mm} x_{MO},\hspace{1 mm} x_{ZM} \geq 0 $

<br />

Poniżej znajdują się opisy zmiennych użytych w ograniczeniach:
| Nazwa zmiennej | Opis |
|:--------------:|:-----|
| $p_M$ | Pojemność magazynu w danym miesiącu |
| $z_K$ | Zapotrzebowanie klienta |

<br />
<br />

### **Funkcja celu**
$$ 

\LARGE\max_{c_{DP}*\sum{ x_{DP}}}
\hspace{3 mm} 
(
    c_{DP}
    \hspace{3 mm}*\hspace{3 mm}
    \sum_{m}{x_{DP}}
)
\hspace{3 mm} - \hspace{3 mm}  
[
 x_{ZR} * c_{R} \hspace{3 mm} + \hspace{3 mm} x_{ZO} * c_{O}  
 \hspace{3 mm} + \hspace{3 mm}
 (\sum{x_{MR}} + \sum{x_{MO}}) * c_{M}
 \hspace{3 mm} + \hspace{3 mm}
 x_{ZM} * c_{TM}
 \hspace{3 mm} + \hspace{3 mm}
 x_{DP} * c_{TK}
]

$$

Poniżej znajdują się opisy zmiennych użytych w definicji funkcji celu:
| Nazwa zmiennej | Opis |
|:--------------:|:-----|
| $c_{DP}$ | cena dostarczanego produktu |
| $c_{R}$ | cena oleju roślinnego |
| $c_{O}$ | cena oleju nieroślinnego |
| $c_{M}$ | cena magazynowania surowca |
| $c_{TM}$ | cena transportu do magazynów |
| $c_{TK}$ | cena transportu do klientów |
