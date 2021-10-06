Wet van Benford
===

De wet van Benford stelt dat de verdeling van de eerste cijfers in een populatie van nature een bepaalde verdeling volgt. Bij audits kan het beoordelen of een verdeling van cijfers in de populatie in overeenstemming is met de wet van Benford aanvullend bewijs leveren dat de transacties in de populatie mogelijk nader onderzoek behoeven.

*Opmerking:* Niet-conformiteit met de wet van Benford duidt niet noodzakelijk op fraude. Een analyse van de wet van Benford mag daarom alleen worden gebruikt om inzicht te krijgen of een populatie nader onderzoek nodig heeft.

### Invoer
---

#### Opdrachtbox
- Variabele: In dit vak wordt de variabele geselecteerd waarvan de cijfers moeten worden getoetst aan de referentieverdeling. De waarde nul (0) wordt weggelaten uit de gegevens.

#### Verwijzing
- Wet van Benford: toets de cijfers aan de wet van Benford.
- Uniforme verdeling: toets de cijfers aan de uniforme verdeling.

#### Cijfers
- Eerste: controleert alleen het eerste cijfer van de items ten opzichte van de opgegeven verdeling.
- Eerste en tweede: Controleert het eerste en tweede cijfer van de items tegen de opgegeven verdeling.
- Laatste: controleert alleen het laatste cijfer van de items ten opzichte van de opgegeven distributie.

#### Bayes-factor
- BF10 : Bayes-factor om bewijs te kwantificeren voor de alternatieve hypothese ten opzichte van de nulhypothese.
- BF01 : Bayes-factor om bewijs voor de nulhypothese te kwantificeren ten opzichte van de alternatieve hypothese.
- Log (BF10) : Natuurlijke logaritme van BF10.

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.
  - Betrouwbaarheid: Het betrouwbaarheidsniveau dat in de verklarende tekst wordt gebruikt.

### Uitgang
---

#### Goodness-of-fit tafel
- n: Het totaal aantal waarnemingen in de dataset.
- X<sup>2</sup>: de waarde van de chi-kwadraat-teststatistiek.
- df: vrijheidsgraden geassocieerd met de Chi-kwadraattoets.
- p: de *p*-waarde die is gekoppeld aan de Chi-kwadraattoets.
- BF: De Bayes-factor als gevolg van een niet-informatieve prior.

#### Frequentietabel
- Voorloop / Laatste cijfer: Het cijfer waarvoor de informatie in de rij geldt.
- Telling: De waargenomen tellingen van de cijfers.
- Percentage: Het waargenomen percentage van het totaal aantal waarnemingen.
- Wet van Benford / Uniforme verdeling: Het verwachte percentage van het totale aantal waarnemingen.

#### Figuren
- Waargenomen vs. verwacht: Produceert een grafiek die de waargenomen verdeling van cijfers in de populatie laat zien in vergelijking met de verwachte verdeling volgens de wet van Benford of de uniforme verdeling.

### Referenties
---
- Derks, K (2021). digitTests: Tests voor het detecteren van onregelmatige cijferpatronen. R-pakket versie 0.1.0.

### R-pakketten
---
- cijfertoetsen