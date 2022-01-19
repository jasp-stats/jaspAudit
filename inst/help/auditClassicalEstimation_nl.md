Waarde Schatting
===

De schattingsanalyse stelt de gebruiker in staat om de werkelijke waarde van een populatie te schatten op basis van een steekproef.

### Invoer
---

#### Opdrachtbox
- Item-ID: een unieke niet-ontbrekende identifier voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarde: De variabele die de boekwaarden van de items in de populatie bevat.
- Auditwaarde: de variabele die de audit (true) waarden bevat, of de binaire classificatie van correct (0) of incorrect (1).

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de gebruiker bereid is te nemen om een ​​onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een controlerisico van 5% wilt hebben, staat dit gelijk aan 95% betrouwbaarheid.

#### Populatie
- Aantal items: Het totale aantal items (rijen) in de populatie.
- Aantal eenheden: Het totale aantal eenheden in de populatie. Let op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van het controlevraagstuk.

#### Methode
- Directe schatter: Deze methode gebruikt alleen de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Verschilschatter: Deze methode gebruikt het verschil tussen de boekwaarden en de controlewaarden om de afwijking in te schatten (Touw en Hoogduin, 2011).
- Ratio schatter: Deze methode gebruikt de verhouding van correctheid tussen de boekwaarden en de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Regressieschatter: Deze methode gebruikt de lineaire relatie tussen de boekwaarden en de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Tabellen
- Vereiste steekproefomvang: Produceert een tabel die, voor een gegeven onzekerheid, de vereiste steekproefomvang laat zien.

#### Figuren
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.

### Uitgang
---

#### Schattingstabel
- Schatting W: De puntschatting van de totale fout in de populatie.
- Onzekerheid: De onzekerheid die samenhangt met het betrouwbaarheidsinterval.
- x-% betrouwbaarheidsinterval: het betrouwbaarheidsinterval dat bij de schatting hoort.

#### Vereiste steekproefgrootte
- Estimator: De gebruikte methode.
- Onzekerheid: het verschil tussen de meest waarschijnlijke waarde en de grenzen.
- Vereist n: Vereiste steekproefomvang.
- Extra n: Extra steekproefomvang.

### Referenties
---
- AICPA (2017). <i>Auditgids: controlesteekproeven</i>. American Institute of Certified Public Accountants.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- Basis R