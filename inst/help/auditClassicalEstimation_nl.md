Schatting van de werkelijke waarde
===

Met de schattingsanalyse kan de gebruiker de werkelijke waarde van een populatie schatten op basis van een steekproef.

### Input
---

#### Toewijzingsvak
- Boekwaarde: De variabele die de boekwaarden van de posten in de populatie bevat.
- Controlewaarde: De variabele die de controle (ware) waarden bevat, of de binaire classificatie van juist (0) of onjuist (1).

#### Populatie
- Aantal posten: Het totale aantal posten (rijen) in de populatie.
- Aantal eenheden: Het totale aantal eenheden in de populatie. Merk op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van de controlevraag.

#### Methode
- Directe schatter: Deze methode gebruikt alleen de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Verschilschatter: Deze methode gebruikt het verschil tussen de boekwaarden en de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Ratioschatter: Deze methode gebruikt de correctieratio tussen de boekwaarden en de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).
- Regressieschatter: Deze methode gebruikt de lineaire relatie tussen de boekwaarden en de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).

#### Weergave
- Verklarende tekst: Indien aangevinkt, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.
  Betrouwbaarheid: Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de auditor bereid is te nemen om een onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een auditrisico van 5% wilt hebben, komt dit overeen met een betrouwbaarheidsniveau van 95%.

#### Rapport
- Tabellen
  - Vereiste steekproefgrootte: Produceert een tabel die voor een bepaalde onzekerheid de vereiste steekproefgrootte weergeeft.

- Plots
  - Scatter plot: Produceert een scatter plot waarin de boekwaarden van de selectie worden vergeleken met hun controlewaarden. Waarnemingen met fouten zijn rood gekleurd.

### Output
---

#### Schattingstabel
- Schatting W: De puntschatting van de totale fout in de populatie.
- Onzekerheid: De onzekerheid in verband met het betrouwbaarheidsinterval.
- x-% betrouwbaarheidsinterval: Het aan de schatting gekoppelde betrouwbaarheidsinterval.

#### Vereiste steekproefgrootte
- Schatter: De gebruikte methode.
- Onzekerheid: Het verschil tussen de meest waarschijnlijke waarde en de grenzen.
- Vereiste n: Vereiste steekproefgrootte.
- Extra n: Extra steekproefgrootte.

### Referenties
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- Basis R