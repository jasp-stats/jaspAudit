Bayesiaanse planning
===

Met de Bayesiaanse planningsanalyse kan de gebruiker een minimale steekproefomvang berekenen, gegeven een reeks steekproefdoelstellingen en samenvattende statistieken van de populatie. Als u toegang hebt tot de ruwe populatiegegevens, kunt u de auditworkflow gebruiken, een analyse die u door het steekproefproces leidt.

<img src="%HELP_FOLDER%/img/workflowPlanning.png" />

Raadpleeg de handleiding van de auditmodule (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Input
---

#### Steekproefdoelstellingen
- Uitvoeringsmaterialiteit: Ook wel de maximale fout, het aanvaardbare foutpercentage of de toelaatbare fout genoemd, is de uitvoeringsmaterialiteit de bovengrens van de fout in de te toetsen populatie. Door te toetsen aan een uitvoeringsmaterialiteit kunt u een steekproef plannen om bewijs te verzamelen voor of tegen de conclusie dat de populatie als geheel geen fouten bevat die als materieel worden beschouwd (d.w.z. groter zijn dan de bovengrens van de toelaatbare fout). U moet deze doelstelling inschakelen wanneer u aan de hand van een steekproef van de populatie wilt nagaan of de populatie fouten bevat boven of onder een bepaalde grens (de uitvoeringsmaterialiteit). Een lagere uitvoeringsmaterialiteit leidt tot een grotere vereiste steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een kleinere vereiste steekproefomvang.
- Minimale precisie: De precisie is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef zo plannen dat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout tot een minimumpercentage wordt beperkt. U moet deze doelstelling inschakelen als u een schatting van de fout van de populatie met een bepaalde nauwkeurigheid wilt maken. Een lagere minimaal vereiste nauwkeurigheid leidt tot een hogere vereiste steekproefomvang. Omgekeerd zal een hogere minimaal vereiste nauwkeurigheid resulteren in een lagere vereiste steekproefomvang.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de auditor bereid is te nemen om een onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een auditrisico van 5% wilt hebben, komt dit overeen met een betrouwbaarheidsniveau van 95%.

#### Verwachte Fouten
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden aangetroffen terwijl toch de gespecificeerde steekproefdoelstellingen worden gehaald. Een steekproefomvang wordt zodanig berekend dat, wanneer het aantal verwachte fouten in de steekproef wordt aangetroffen, de gewenste betrouwbaarheid behouden blijft.

*Noot:* Geadviseerd wordt deze waarde conservatief vast te stellen om de kans dat de waargenomen fouten groter zijn dan de verwachte fouten, hetgeen zou betekenen dat er onvoldoende werk is verricht, zo klein mogelijk te houden.

- Relatief: Voer uw verwachte fouten in als percentage ten opzichte van de totale omvang van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van de (proportionele) fouten.

#### Populatie
- Aantal eenheden: Het totale aantal eenheden in de populatie. Merk op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van de controlevraag.

#### Weergave
- Verklarende tekst: Indien aangevinkt, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Voorafgaande
- Verdeling: Specificeer de familie van de prior-verdeling.
  - Beta-binomiaal: De beta-binomiale verdeling hoort bij de hypergeometrische waarschijnlijkheid (Dyer & Pierce, 1993). De hypergeometrische waarschijnlijkheid gaat uit van een eindige populatieomvang en wordt daarom meestal gebruikt als de populatieomvang klein is. Het is een waarschijnlijkheid die het aantal fouten (*K*) in de populatie modelleert als functie van de populatiegrootte (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal correcte verrichtingen (*n*).
  - Bèta: De bètaverdeling hoort bij de binomiale waarschijnlijkheid. De binomiale waarschijnlijkheid gaat uit van een oneindige populatieomvang en wordt daarom meestal gebruikt wanneer de populatieomvang groot is. Het is een waarschijnlijkheid die het percentage onjuiste opgaven (*k*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte transacties (*n - k*). Omdat de binomiale verdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u geen steekproef voor monetaire eenheden plant. De bèta-verdeling herbergt echter wel partiële fouten, en kan ook worden gebruikt voor monetaire eenheidssteekproeven (de Swart, Wille & Majoor, 2013).
  - Gamma: De gammaverdeling hoort bij de Poisson likelihood. De Poisson likelihood gaat uit van een oneindige populatieomvang en wordt daarom meestal gebruikt als de populatieomvang groot is. Het is een waarschijnlijkheid die het percentage onjuistheden (*u03B8*) modelleert als functie van de waargenomen steekproefomvang (*n*) en de som van de gevonden proportionele fouten (*t*). Omdat de gamma-verdeling rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u een steekproef voor monetaire eenheden plant (Stewart, 2013).

- Eliciatie: Specificeer hoe de prior-verdeling moet worden geconstrueerd, of met andere woorden, welk type controle-informatie in de prior-verdeling moet worden opgenomen.
  - Standaard: Deze optie neemt geen informatie op in de statistische analyse en gaat daarom uit van een verwaarloosbare en conservatieve prior-verdeling.
  - Parameters: Geef de parameters van de prior-verdeling.
  - Eerder monster: Creëer een prior-verdeling op basis van een eerdere steekproef.
    - Grootte: Grootte van de eerdere steekproef.
    - Fouten: Eerder gevonden fouten.
  - Onpartijdig: Maak een prior-verdeling die onpartijdig is ten opzichte van de geteste hypothesen.
  - Risicobeoordelingen: Vertaal informatie uit het audit risicomodel in een prior verdeling.
    - Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico van een afwijking van materieel belang als gevolg van een fout of weglating in een financieel overzicht door een andere factor dan het falen van de interne controle.
    - Controlerisico: Een categorie of waarschijnlijkheid voor het interne controlerisico. Controlerisico wordt gedefinieerd als het risico van een afwijking van materieel belang in de financiële overzichten als gevolg van het ontbreken of falen van de werking van relevante controles van de gecontroleerde.

#### Verslag
- Tabellen
  - Voorafgaand en achteraf: Produceert een tabel waarin de prior en verwachte posterior verdeling worden samengevat aan de hand van verschillende statistieken, zoals hun functionele vorm, hun prior en verwachte posterior kansen en waarschijnlijkheden, en de verschuiving daartussen.

- Plots
  - Vergelijk steekproefgrootten: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
  - Prior en posterior: Produceert een plot die de prior verdeling en de posterior verdeling toont na observatie van de beoogde steekproef.
    - Extra informatie: Annoteert de figuur met de modus en het geloofwaardigheidsinterval. Indien een materialiteit is gespecificeerd, wordt de figuur geannoteerd met de materialiteit en bevat een visualisatie van de Bayes-factor via een proportiewiel.
  - Prior predictief: Produceert een plot van de voorspellingen van de prior-verdeling.

- Formaat uitvoer
  - Getallen: Toont de tabeluitvoer als getallen.
  - Percentages: Toont de tabeluitvoer als percentages.

#### Geavanceerd
- Iteraties
  - Verhoging: Met de verhoging kunt u de mogelijke steekproefgrootten beperken tot een veelvoud van de waarde ervan. Bijvoorbeeld, een verhoging van 5 staat alleen steekproefgroottes toe van 5, 10, 15, 20, 25, enz.
  - Maximum: Met het maximum kunt u de steekproefgrootte beperken met een maximum.

### Uitvoer
---

#### Planning Samenvatting
- Prestatiematerialiteit: Indien verstrekt, de prestatiematerialiteit.
- Min. nauwkeurigheid: Indien verstrekt, de minimale precisie.
- Verwachte fouten: Het aantal (som van proportionele tinten) verwachte / aanvaardbare fouten in de steekproef.
- Minimale steekproefomvang: De minimale steekproefomvang.

#### Equivalente voorafgaande steekproef
- Equivalente steekproefomvang: De steekproefgrootte die gelijkwaardig is aan de voorafgaande informatie.
- Equivalente fouten: Het aantal fouten dat equivalent is aan de prior informatie.

#### Prior en posterior
- Functionele vorm: De functionele vorm van de verdeling.
- Steun H-: Totale kans in het bereik van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Ondersteuning H+: Totale kans in het bereik van H+ onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Verhouding H- / H+: Kans in het voordeel van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Gemiddelde: Gemiddelde van de verdeling.
- Mediaan: Mediaan van de verdeling.
- Modus: Modus van de verdeling.
- Bovengrens: x-percentiel van de verdeling.
- Nauwkeurigheid: Verschil tussen de bovengrens en de modus van de verdeling.

#### Plots
- Prior-verdeling: Produceert een plot met de prior-verdeling.
  - Posterior verdeling: Voegt de posterieure verdeling na waarneming van het bedoelde monster toe aan de figuur.
- Voorspellende verdeling: Produceert een plot van de voorspellingen van de prior-verdeling.
- Vergelijk steekproefgrootten: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.

### Referenties
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R-pakket versie 0.6.6.
- Dyer, D., & Pierce, R. L. (1993). On the choice of the prior distribution in hypergeometric sampling. <i>Communications in Statistics-Theory and Methods</i>, 22(8), 2125-2146.
- Stewart, T. R. (2013). A Bayesian audit assurance model with application to the component materiality problem in group audits (Doctoral dissertation).
- de Swart, J., Wille, J., & Majoor, B. (2013). Het 'Push Left'-Principe als Motor van Data Analytics in de Accountantscontrole. <i>Maandblad voor Accountancy en Bedrijfseconomie</i>, 87, 425-432.

### R-pakketten
---
- jfa