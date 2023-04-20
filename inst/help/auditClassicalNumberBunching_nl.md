Herhaalde waarde analyse
===

Deze analyse analyseert de frequentie waarmee waarden binnen een dataset worden herhaald (het zogenaamde "number-bunching") om statistisch vast te stellen of er waarschijnlijk met de gegevens is geknoeid. In tegenstelling tot de wet van Benford onderzoekt deze aanpak het hele getal in één keer, niet alleen het eerste of laatste cijfer (Simonsohn, 2019).

Om te bepalen of de gegevens een buitensporige hoeveelheid herhaling vertonen, wordt de nulhypothese getest dat de gegevens geen onverwachte hoeveelheid herhaalde waarden bevatten. Om te kwantificeren wat wordt verwacht, vereist deze test de aanname dat de gehele delen van de getallen niet geassocieerd zijn met hun decimale delen.

### Input
---

#### Toewijzingsvak
- Variabele: In dit vak wordt de variabele geselecteerd waarvan de cijfers moeten worden geanalyseerd op herhaalde waarden.

#### Tests
- Gemiddelde frequentie: Bereken de gemiddelde frequentie van de gegevens.
- Entropie: Bereken de entropie van de gegevens.

#### Schud decimale cijfers
- Laatste: Laatste decimaal cijfer wordt geschud.
- Laatste twee: Laatste twee decimale cijfers worden geschud.
- Alle: Alle decimale cijfers worden geschud.

#### Weergave
- Toelichtende tekst: Indien aangevinkt, wordt in de analyse verklarende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.
  - Betrouwbaarheid: Het betrouwbaarheidsniveau dat in de verklarende tekst wordt gebruikt.

#### Rapport
- Tabellen
  - Verificatie van aannames: Deze tabel toont de correlatie tussen de gehele getallen en hun decimale tegenhangers. Om aan de vereiste aannames voor deze procedure te voldoen, mag deze correlatie niet bestaan. Deze tabel toont ook de correlatie tussen de steekproeven van de twee simulatieruns (gemiddelde frequentie en entropie).
  - Frequentietabel: Produceert een tabel met de telling en het percentage voor elke unieke waarde in de gegevensverzameling.

- Figuren
  - Geobserveerd vs. verwacht: Produceert een histogram van de verwachte gemiddelde frequenties en/of entropie versus de waargenomen gemiddelde frequentie en/of entropie.
  - Histogram: Produceert een histogram met een enkele bin voor elke waargenomen waarde.

#### Geavanceerd
- Aantal iteraties: Het aantal iteraties dat moet worden gebruikt voor het simuleren van de p-waarde.
- Toevalsgenerator beginwaarde: Selecteert de beginwaarde voor de willekeurige getallengenerator om de resultaten te reproduceren.

### Uitvoer
---

#### Test met herhaalde waarden
- n: Het aantal waarnemingen in de gegevens.
- Frequentie: De gemiddelde frequentie waarmee getallen in de gegevens worden herhaald. De formule voor de gemiddelde frequentie is *AF = &#8721; f&#7522;&#178; / &#8721; f&#7522;* waarbij f&#7522; de frequentie is van elke unieke waarde *i* in de dataset.
- Entropie: De entropie is het gemiddelde informatieniveau dat inherent is aan de uitkomsten van de variabele. De entropie wordt berekend als *S = - &#8721; (p&#7522; &#215; log(p&#7522;))* waarbij p&#7522; het aandeel van de waarnemingen met elke waarde is (dus *p&#7522; = f&#7522; / N*).

#### Aannamecontroles
- n: Steekproefgrootte.
- r: Pearson correlatiecoëfficiënt.
- t: t-waarde.
- df: Vrijheidsgraden.
- p: p-waarde.

#### Frequentietabel
- Waarde: De waarde in de rij.
- Telling: Het aantal keren dat de waarde is waargenomen.
- Percentage: Het percentage van de keren dat de waarde is waargenomen.

#### Plots
- Geobserveerd vs. verwacht: Toont de waargenomen versus de gesimuleerde waarde(n).
- Histogram: Toont een histogram met een enkele bin voor elke waargenomen waarde.

### Referenties
---
- Derks, K. (2023). jfa: Statistical methods for auditing. R-pakket versie 0.6.6.
- Simohnsohn, U. (2019, 25 mei). Number-Bunching: een nieuw hulpmiddel voor forensische gegevensanalyse. Opgehaald uit [http://datacolada.org/77](http://datacolada.org/77).

### R-pakketten
---
- jfa