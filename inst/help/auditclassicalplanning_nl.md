Planning
===

Met de planningsanalyse kan de gebruiker een minimale steekproefomvang berekenen op basis van een reeks steekproefdoelstellingen en samenvattende statistieken van de populatie. Houd er rekening mee dat wanneer u toegang heeft tot de onbewerkte populatiegegevens, u misschien de auditworkflow wilt gebruiken, een analyse die u door het steekproefproces leidt.

<img src="%HELP_FOLDER%/img/workflowPlanning.png" />

Zie de handleiding van de Audit module (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Invoer
---

#### Steekproef Doelstellingen
- Uitvoeringsmaterialiteit: ook wel de bovengrens voor de fout, het maximaal toelaatbare afwijkingspercentage of de maximaal toelaatbare afwijking genoemd, de uitvoeringsmaterialiteit is de bovengrens van de toelaatbare afwijking in de te testen populatie. Door te toetsen aan een uitvoeringsmaterialiteit bent u in staat een steekproef te plannen om bewijs te verzamelen voor of tegen de stelling dat de populatie als geheel geen afwijkingen bevat die als materieel worden beschouwd (d.w.z groter zijn dan de uitvoeringsmaterialiteit). U moet deze doelstelling inschakelen als u met een steekproef uit de populatie wilt weten of de populatie een afwijking boven of onder een bepaalde limiet (de prestatiematerialiteit) bevat. Een lagere uitvoeringsmaterialiteit zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een lagere steekproefomvang.
- Minimale precisie: de precisie is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef plannen zodat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de afwijking tot een minimumpercentage wordt teruggebracht. U moet deze doelstelling inschakelen als u geïnteresseerd bent in het maken van een schatting van de populatieafwijking met een bepaalde nauwkeurigheid. Een lagere minimaal vereiste precisie zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere minimale precisie resulteren in een vereiste steekproefomvang.

#### Populatie
- Aantal eenheden: Het totale aantal eenheden in de populatie. Let op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van het controlevraagstuk.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de gebruiker bereid is te nemen om een ​​onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een controlerisico van 5% wilt hebben, staat dit gelijk aan 95% betrouwbaarheid.

#### Auditrisicomodel
- Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico op een afwijking van materieel belang als gevolg van een fout of weglating in een financieel overzicht als gevolg van een andere factor dan een falen van de interne beheersing.
- Beheersingsrisico: Een categorie of waarschijnlijkheid voor het internecontrolerisico. Het interne beheersingsrisico wordt gedefinieerd als het risico van een afwijking van materieel belang in de financiële overzichten die voortvloeit uit het ontbreken of falen van de relevante interne beheersingsmaatregelen van de gecontroleerde.

Wanneer de auditor informatie heeft die wijst op een laag risicoprofiel van de populatie, kan hij deze informatie gebruiken om zijn vereiste steekproefomvang te verkleinen via het Audit Risk Model (ARM), op voorwaarde dat er geen fouten in de populatie zitten. Volgens de ARM is het auditrisico (AR) een functie van het inherente risico (IR), het internecontrolerisico (CR) en het detectierisico (DR).

*AR = IR x CR x DR*

De auditor beoordeelt het inherente risico en het internecontrolerisico in het algemeen op een 3-puntsschaal om het juiste ontdekkingsrisico te bepalen. Met behulp van de ARM en nul fouten hangt de steekproefomvang af van de risicofactor *R* en de uitvoeringsmaterialiteit. De risicofactor *R* is een functie van het detectierisico (Stewart 2012).

*R = -ln(DR)*

De volgende tabel geeft de waarden van *R* weer als functie van het detectierisico, op voorwaarde dat er geen fouten zijn (Touw en Hoogduin 2012).

| Detectierisico (%) | 1 | 4 | 5 | 10 | 14 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| R | 4.6 | 3.2 | 3 | 2.3 | 2 |

De risicofactor *R* kan worden aangepast met behulp van de beoordelingen van het inherente risico en het internecontrolerisico. Standaard is de standaardmethode voor het instellen van de kansen op IR en CR door de onderstaande tabel te volgen voor een detectierisico van 5%:

| | Hoog | Gemiddeld | Laag |
| :---: | :---: | :---: |
| R | 3 | 2 | 1 |

Deze waarden van *R* worden gebruikt om standaardpercentages in te stellen voor IR en CR. De Audit-module verwerkt de volgende standaardwaarden voor IR en CR:

- Hoog: 100%
- Gemiddeld: 60%
- Laag: 36%

U kunt de waarde van IR en CR handmatig aanpassen door de optie Aangepast te selecteren onder de bijbehorende risicobeoordeling, waardoor de risicofactor *R* wordt aangepast.

#### Verwachte fouten in steekproef
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden gevonden terwijl de gespecificeerde steekproefdoelstellingen nog steeds worden bereikt. Er wordt een steekproefomvang berekend zodat, wanneer het aantal verwachte fouten in de steekproef wordt gevonden, het gewenste vertrouwen behouden blijft.

*Opmerking:* Het wordt aangeraden om deze waarde conservatief in te stellen om de kans te minimaliseren dat de waargenomen fouten de verwachte fouten overschrijden, wat zou betekenen dat er onvoldoende werk is verricht.

- Relatief: voer uw verwachte fouten in als een percentage ten opzichte van de totale grootte van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van (proportionele) fouten.

#### Kansverdeling
- Poisson: De Poisson-verdeling gaat uit van een oneindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang groot is. Het is een kansverdeling die het percentage afwijkingen (*\u03B8*) modelleert als functie van de waargenomen steekproefomvang (*n*) en de som van de proportionele fouten (*t*). Omdat de Poisson-verdeling rekening houdt met gedeeltelijke fouten, wordt deze over het algemeen gebruikt wanneer u een steekproef in een munteenheid plant.
- Binomiaal: De binomiale verdeling gaat uit van een oneindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang groot is. Het is een kansverdeling die het afwijkingspercentage (*\u03B8*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte transacties (*n - k*). Omdat de binominale verdeling strikt geen rekening houdt met gedeeltelijke fouten, wordt deze over het algemeen gebruikt wanneer u geen steekproef in een munteenheid plant.
- Hypergeometrische verdeling: De hypergeometrische verdeling gaat uit van een eindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang klein is. Het is een kansverdeling die het aantal fouten (*K*) in de populatie modelleert als functie van de populatieomvang (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal correcte transacties ( *N*).

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Figuren
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde foutenverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefomvang.

#### Tabellen opmaken
- Cijfers: geef tabeluitvoer weer als getallen.
- Percentages: geef de tabeluitvoer weer als percentages.

#### Stapgrootte
Met de stapgrootte kunt u de mogelijke steekproefomvang beperken tot een veelvoud van de waarde. Een stapgrootte van 5 staat bijvoorbeeld alleen steekproefomvang van 5, 10, 15, 20, 25, enz. toe.

### Uitgang
---

#### Planningsoverzicht
- Uitvoeringsmaterialiteit: indien aanwezig, de uitvoeringsmaterialiteit.
- Min. precisie: indien aanwezig, de minimale precisie.
- Verwachte fouten: Het aantal (som van proportionele taints) verwachte / toelaatbare fouten in de steekproef.
- Minimale steekproefomvang: de minimale steekproefomvang.

#### Figuren
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde foutenverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefomvang.

### Referenties
---
- AICPA (2017). <i>Auditgids: controlesteekproeven</i>. American Institute of Certified Public Accountants.
- Derks, K. (2022). jfa: Bayesiaanse en klassieke auditsteekproeven. R-pakket versie 0.6.2.
-Stewart, T. (2012). <i>Technische opmerkingen over de AICPA-auditgids Auditsteekproeven</i>. American Institute of Certified Public Accountants, New York.

### R-pakketten
---
- jfa