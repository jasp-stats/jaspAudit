Herhaalde Waardeanalyse
===

Deze analyse analyseert de frequentie waarmee waarden binnen een dataset worden herhaald ('nummerbundeling' genoemd) om statistisch vast te stellen of er waarschijnlijk met de gegevens is geknoeid. In tegenstelling tot de wet van Benford onderzoekt deze benadering het hele getal in één keer, niet alleen het eerste of laatste cijfer (Simonsohn, 2019).

Om te bepalen of de gegevens een overmatige hoeveelheid opeenhoping vertonen, wordt de nulhypothese getest dat de gegevens geen onverwachte hoeveelheid herhaalde waarden bevatten. Om te kwantificeren wat er wordt verwacht, vereist deze test de aanname dat de gehele delen van de getallen niet zijn gekoppeld aan hun decimale delen.

### Invoer
---

#### Opdrachtbox
- Variabele: in dit vak wordt de variabele geselecteerd waarvan de cijfers moeten worden geanalyseerd op herhaalde waarden.

#### Testen
- Gemiddelde frequentie: bereken de gemiddelde frequentie van de gegevens.
- Entropie: bereken de entropie van de gegevens.

#### Shuffle decimale cijfers
- Laatste: het laatste decimaalcijfer wordt geschud.
- Laatste twee: de laatste twee decimale cijfers worden geschud.
- Alles: alle decimale cijfers worden geschud.

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.
  - Betrouwbaarheid: Het betrouwbaarheidsniveau dat in de verklarende tekst wordt gebruikt.

#### Tabellen
- Aannamecontroles: deze tabel toont de correlatie tussen de gehele delen van de getallen en hun decimale tegenhangers. Om aan de vereiste aannames voor deze procedure te voldoen, mag deze correlatie niet bestaan. Deze tabel geeft ook de correlatie weer tussen de steekproeven van de twee simulatieruns (gemiddelde frequentie en entropie).
- Frequentietabel: Produceert een tabel met het aantal en het percentage voor elke unieke waarde in de dataset.

#### Figuren
- Waargenomen vs. verwacht: Produceert een histogram van de verwachte gemiddelde frequenties en/of entropie vs. de waargenomen gemiddelde frequentie en/of entropie.
- Histogram: Produceert een histogram met een enkele bak voor elke waargenomen waarde.

#### Geavanceerde mogelijkheden
- Aantal monsters: Het aantal monsters dat moet worden gebruikt voor het simuleren van de p-waarde.
- Seed: Selecteert de seed voor de generator van willekeurige getallen om resultaten te reproduceren.

### Uitgang
---

#### Herhaalde Waarden Test
- n: Het aantal waarnemingen in de gegevens.
- Frequentie: De gemiddelde frequentie waarmee getallen in de gegevens worden herhaald. De formule voor de gemiddelde frequentie is *AF = &#8721; f&#7522;&#178; / &#8721; f&#7522;* waar f&#7522; is de frequentie van elke unieke waarde *i* in de dataset.
- Entropie: De entropie is het gemiddelde informatieniveau dat inherent is aan de uitkomsten van de variabele. De entropie wordt berekend als *S = - &#8721; (p&#7522; &#215; log(p&#7522;))* waarbij p&#7522; is het aandeel waarnemingen met elke waarde (dus *p&#7522; = f&#7522; / N*).

#### Aannamecontroles
- n: steekproefomvang.
- r: Pearson-correlatiecoëfficiënt.
- t: t-waarde.
- df: vrijheidsgraden.
- p: p-waarde.

#### Frequentietabel
- Waarde: de waarde in de rij.
- Telling: het aantal keren dat de waarde wordt waargenomen.
- Percentage: Het percentage keren dat de waarde wordt waargenomen.

#### Figuren
- Waargenomen vs. verwacht: geeft de waargenomen vs. de gesimuleerde waarde(n) weer.
- Histogram: geeft een histogram weer met een enkele bak voor elke waargenomen waarde.

### Referenties
---
- Derks, K (2021). digitTests: Tests voor het detecteren van onregelmatige cijferpatronen. R-pakket versie 0.1.0.
- Simohnsohn, Verenigde Staten (2019, 25 mei). Nummerbundeling: een nieuw hulpmiddel voor forensische gegevensanalyse. Opgehaald van [http://datacolada.org/77](http://datacolada.org/77).

### R-pakketten
---
- cijfertoetsen