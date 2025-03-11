Planning
===

Met de planningsanalyse kan de gebruiker een minimale steekproefgrootte berekenen op basis van een reeks steekproefdoelstellingen en samenvattende statistieken van de populatie. Als u toegang hebt tot de ruwe populatiegegevens, kunt u de auditworkflow gebruiken, een analyse die u door het steekproefproces leidt.

<img src="%HELP_FOLDER%/img/workflowPlanning.png" />

Raadpleeg de handleiding van de auditmodule (lees [hier](https://koenderks.github.io/jaum/)) voor meer gedetailleerde informatie over deze analyse.

### Input
---

#### Steekproefdoelstellingen
- Uitvoeringsmaterialiteit: Ook wel de maximale fout, het aanvaardbare foutpercentage of de toelaatbare fout genoemd, is de uitvoeringsmaterialiteit de bovengrens van de fout in de te toetsen populatie. Door te toetsen aan een uitvoeringsmaterialiteit kunt u een steekproef plannen om bewijs te verzamelen voor of tegen de conclusie dat de populatie als geheel geen fouten bevat die als materieel worden beschouwd (d.w.z. groter zijn dan de bovengrens van de toelaatbare fout). U moet deze doelstelling inschakelen wanneer u aan de hand van een steekproef van de populatie wilt nagaan of de populatie fouten bevat boven of onder een bepaalde grens (de uitvoeringsmaterialiteit). Een lagere uitvoeringsmaterialiteit leidt tot een grotere vereiste steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een kleinere vereiste steekproefomvang.
- Minimale nauwkeurigheid: De nauwkeurigheid is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef zo plannen dat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout tot een minimumpercentage wordt beperkt. U moet deze doelstelling inschakelen als u een schatting van de fout van de populatie met een bepaalde nauwkeurigheid wilt maken. Een lagere minimaal vereiste nauwkeurigheid leidt tot een hogere vereiste steekproefomvang. Omgekeerd zal een hogere minimaal vereiste nauwkeurigheid resulteren in een lagere vereiste steekproefomvang.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de auditor bereid is te nemen om een onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een auditrisico van 5% wilt hebben, komt dit overeen met een betrouwbaarheidsniveau van 95%.

#### Verwachte Fouten
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden aangetroffen terwijl toch de gespecificeerde steekproefdoelstellingen worden gehaald. Een steekproefomvang wordt zodanig berekend zodat, wanneer het aantal verwachte fouten in de steekproef wordt aangetroffen, de gewenste betrouwbaarheid behouden blijft.

*Noot:* Geadviseerd wordt deze waarde conservatief vast te stellen om de kans dat de waargenomen fouten groter zijn dan de verwachte fouten, hetgeen zou betekenen dat er onvoldoende werk is verricht, zo klein mogelijk te houden.

- Relatief: Voer uw verwachte fouten in als percentage ten opzichte van de totale omvang van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van de (proportionele) fouten.

#### Populatie
- Aantal eenheden: Het totale aantal eenheden in de populatie. Merk op dat de eenheden posten (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van de controlevraag.

#### Audit Risico Model
- Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico op een materiele fout in de populatie door een andere factor dan het falen van de interne controle.
- Intern beheersingsrisico: Een categorie of waarschijnlijkheid voor het interne beheersingsrisico. Intern beheersingsrisico wordt gedefinieerd als het risico op een materiele fout in de populatie als gevolg van het ontbreken of falen van de werking van relevante interne controles van de gecontroleerde.
- Cijferanalyserisico: Een categorie of waarschijnlijkheid voor het cijferanalyserisico. Cijferanalysierisico wordt gedefinieerd als het risico dat een materiele fout niet met cijferanalyse wordt ontdekt door de auditor.

Wanneer de accountant over informatie beschikt die wijst op een laag risicoprofiel van de populatie, kan hij deze informatie gebruiken om zijn vereiste steekproefomvang te beperken via het Audit Risico Model (ARM), mits er geen fouten in de populatie voorkomen. Volgens het ARM is het auditrisico (AR) een functie van het inherente risico (IR), het interne beheersingsrisico (IBR), het cijferanalyserisico (CAR) en het detectierisico (DR).

*AR = IR x IBR x CAR x DR*

De accountant beoordeelt het inherente risico, het interne beheersingsrisico en het cijferanalyserisico doorgaans op een driepuntsschaal bestaande uit hoog, gemiddeld en laag om het passende detectierisico te bepalen. Om het ARM te kunnen gebruiken, moeten deze categorische risicobeoordelingen worden omgezet in percentages. Standaard gebruikt de Auditmodule de percentages in onderstaande tabel, die zijn geïnspireerd door het <i>Handboek Auditing Rijksoverheid</i>. U kunt de percentages voor één of alle risico's handmatig aanpassen door in de keuzelijst onder de betreffende risicobeoordeling de optie Aangepast te selecteren.

| | Inherent risico (IR) | Intern beheersingsrisico (IBR) | Cijferanalyserisico (CAR) |
| ---: | :---: | :---: | :---: |
| High | 100% | 100% | 100% |
| Medium | 63% | 52% | 50% |
| Low | 40% | 34% | 25% |

#### Weergave
- Toelichtende tekst: Indien aangevinkt, wordt in de analyse verklarende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.

#### Rapport
- Figuren
  - Vergelijk steekproefgrootten: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen en 2) over het aantal verwachte fouten in de steekproef.
  - Veronderstelde gegevensverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefgrootte.

- Weergave Getallen
  - Numeriek: Getallen weergeven als numerieke waarden.
  - Percentages: Getallen weergeven als percentages.

#### Geavanceerd
- Kansverdeling
  - Hypergeometrisch: De hypergeometrische verdeling gaat uit van een eindige populatie en wordt daarom meestal gebruikt als de populatieomvang klein is. Het is een kansverdeling die het aantal fouten (*K*) in de populatie modelleert als functie van de populatiegrootte (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal steekproefeenheden (*n*).
  - Binomiaal: De binomiale verdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt als de populatiegrootte groot is. Het is een kansverdeling die het percentage fouten (*\u03B8*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte eenheden (*n - k*). Omdat de binomiale verdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u geen steekproef voor monetaire eenheden plant.
  - Poisson: De Poisson-verdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt als de populatieomvang groot is. Het is een kansverdeling die het percentage fouten (*\u03B8*) modelleert als functie van het steekproefeenheden (*n*) en de som van de proportionele fouten (*t*). Omdat de Poisson-verdeling rekening houdt met gedeeltelijke fouten, wordt zij doorgaans gebruikt wanneer u een steekproef voor monetaire eenheden plant.

- Iteraties
  - Verhoging: Met de verhoging kunt u de mogelijke steekproefomvang beperken tot een veelvoud van de waarde ervan. Bijvoorbeeld, een verhoging van 5 staat alleen steekproefgroottes toe van 5, 10, 15, 20, 25, enz.
  - Maximum: Met het maximum kunt u de steekproefgrootte beperken met een maximum.

### Uitvoer
---

#### Planning Samenvatting
- Uitvoeringsmaterialiteit: Indien verstrekt, de uitvoeringsmaterialiteit.
- Min. nauwkeurigheid: Indien verstrekt, de minimale precisie.
- Verwachte fouten: Het aantal (som van proportionele tinten) verwachte / aanvaardbare fouten in de steekproef.
- Minimale steekproefomvang: De minimale steekproefgrootte.

#### Plots
- Vergelijk steekproefgroottes: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde gegevensverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefgrootte.

### Referenties
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R-pakket versie 0.7.0.
- Stewart, T. (2012). <i>Technische aantekeningen bij de AICPA-auditgids Audit Sampling</i>. American Institute of Certified Public Accountants, New York.

### R-pakketten
---
- jfa