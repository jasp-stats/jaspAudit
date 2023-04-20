Evaluatie
===

Met de evaluatieanalyse kan de gebruiker op basis van een controlesteekproef conclusies trekken over de totale onjuistheid in de populatie.

<img src="%HELP_FOLDER%/img/workflowEvaluation.png" />

Zie de handleiding van de module Audit (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Input
---

#### Toewijzingsvak
- Item ID: Een unieke, niet ontbrekende identifier voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarden: De variabele die de boekwaarden van de items in de populatie bevat. Idealiter zijn alle boekwaarden positieve waarden, zie de <i>Kritische items</i> optie voor de afhandeling van negatieve boekwaarden.
- Audit resultaat / waarden: De variabele die de controle (ware) waarden bevat, of de binaire classificatie van juist (0) of onjuist (1).
- Selectieteller: De variabele die bevat hoeveel keer elke waarneming moet worden geëvalueerd.
- Stratum: Een optionele variabele die voor elk item bevat tot welk stratum een item behoort in de populatie. Het verstrekken van een stratumvariabele geeft aan de analyse aan dat de populatie in verschillende subgroepen is verdeeld en dat voor elk van deze subgroepen een schatting moet worden gemaakt.

#### Steekproefdoelstellingen
- Uitvoeringsmaterialiteit: Ook wel de maximale fout, het aanvaardbare foutpercentage of de toelaatbare fout genoemd, is de uitvoeringsmaterialiteit de bovengrens van de fout in de te toetsen populatie. Door te toetsen aan een uitvoeringsmaterialiteit kunt u een steekproef plannen om bewijs te verzamelen voor of tegen de conclusie dat de populatie als geheel geen fouten bevat die als materieel worden beschouwd (d.w.z. groter zijn dan de bovengrens van de toelaatbare fout). U moet deze doelstelling inschakelen wanneer u aan de hand van een steekproef van de populatie wilt nagaan of de populatie fouten bevat boven of onder een bepaalde grens (de uitvoeringsmaterialiteit). Een lagere uitvoeringsmaterialiteit leidt tot een grotere vereiste steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een kleinere vereiste steekproefomvang.
- Minimale precisie: De precisie is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef zo plannen dat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout tot een minimumpercentage wordt beperkt. U moet deze doelstelling inschakelen als u een schatting van de fout van de populatie met een bepaalde nauwkeurigheid wilt maken. Een lagere minimaal vereiste nauwkeurigheid leidt tot een hogere vereiste steekproefomvang. Omgekeerd zal een hogere minimaal vereiste nauwkeurigheid resulteren in een lagere vereiste steekproefomvang.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de auditor bereid is te nemen om een onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een auditrisico van 5% wilt hebben, komt dit overeen met een betrouwbaarheidsniveau van 95%.

#### Gegevenstype
- Populatie: Geef aan dat u een gegevensbestand gebruikt dat de populatie vertegenwoordigt. Dit vereist dat u een <i>Selectieteller</i> variabele gebruikt die aangeeft hoe vaak elk item is geselecteerd voor de steekproef.
- Steekproef: Geef aan dat u een gegevensbestand gebruikt dat alleen steekproefgegevens weergeeft.
- Samenvattende statistieken: Vereist geen gegevensinvoer en alleen samenvattende statistieken van de steekproef.

#### Populatie
- Aantal items: Het totale aantal items (rijen) in de populatie.
- Aantal eenheden: Het totale aantal eenheden in de populatie. De eenheden kunnen items (rijen) of monetaire eenheden (waarden) zijn, afhankelijk van de controlevraag.

#### Audit Risico Model
- Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico op een materiele fout in de populatie door een andere factor dan het falen van de interne controle.
- Intern beheersingsrisico: Een categorie of waarschijnlijkheid voor het interne beheersingsrisico. Intern beheersingsrisico wordt gedefinieerd als het risico op een materiele fout in de populatie als gevolg van het ontbreken of falen van de werking van relevante interne controles van de gecontroleerde.

Wanneer de accountant over informatie beschikt die wijst op een laag risicoprofiel van de populatie, kan hij deze informatie gebruiken om zijn vereiste steekproefomvang te beperken via het Audit Risico Model (ARM), mits er geen fouten in de populatie voorkomen. Volgens het ARM is het auditrisico (AR) een functie van het inherente risico (IR), het interne beheersingsrisico (IBR) en het detectierisico (DR).

*AR = IR x IBR x DR*

De accountant beoordeelt het inherente risico en het interne beheersingsrisico doorgaans op een driepuntsschaal bestaande uit hoog, gemiddeld en laag om het passende detectierisico te bepalen. Om het ARM te kunnen gebruiken, moeten deze categorische risicobeoordelingen worden omgezet in percentages. Standaard gebruikt de Auditmodule de percentages in onderstaande tabel, die zijn geïnspireerd op het <i>Handboek Auditing Rijksoverheid</i>. U kunt de percentages voor één of beide risico's handmatig aanpassen door in de keuzelijst onder de betreffende risicobeoordeling de optie Aangepast te selecteren.

| Inherent risico (IR) | Intern beheersingsrisico (IBR) |
| ---: | :---: | :---: |
| High | 100% | 100% |
| Medium | 63% | 52% |
| Low | 40% | 34% |

#### Weergave
- Verklarende tekst: Indien aangevinkt, wordt in de analyse verklarende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.

#### Rapport
- Tabellen
  - Foutieve items: Produceert een tabel met alle items die een onjuiste opgave bleken te bevatten.
  - Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.

- Plots
  - Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, maximale onjuistheid en meest waarschijnlijke fout (MLE) worden vergeleken.
  - Schattingen: Produceert een intervalplot voor de populatie en optioneel de stratumschattingen van de onjuistheid.

- Formaat uitvoer
  - Getallen: Geef de tabeluitvoer weer als getallen.
  - Percentages: Geef tabeluitvoer weer als percentages.
  - Monetaire waarden: Tabeluitvoer weergeven als monetaire waarden.

#### Geavanceerd
- Methode
  - Poisson: Gebruikt de Poisson waarschijnlijkheid om de steekproef te evalueren.
  - Binomiaal: Gebruikt de binomiale waarschijnlijkheid om de steekproef te evalueren.
  - Hypergeometrisch: Gebruikt de hypergeometrische waarschijnlijkheid om de steekproef te evalueren.
  - Stringer: De Stringer bound om de steekproef te evalueren (Stringer, 1963).
    - LTA-aanpassing: LTA-aanpassing voor de stringer bound om understatements op te nemen (Leslie, Teitlebaum, & Anderson, 1979).
  - Gemiddelde-per-eenheidsschatter: Gebruikt de gemiddelde-per-eenheidsschatter.
  - Directe schatter: Deze methode gebruikt alleen de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).
  - Verschilschatter: Deze methode gebruikt het verschil tussen de boekwaarden en de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).
  - Ratioschatter: Deze methode gebruikt de correctieratio tussen de boekwaarden en de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).
  - Regressieschatter: Deze methode gebruikt de lineaire relatie tussen de boekwaarden en de controlewaarden om de onjuistheid te schatten (Touw en Hoogduin, 2011).

- Kritische posten
  - Negatieve boekwaarden: Isoleert negatieve boekwaarden uit de populatie.
    - Bewaart: Houdt negatieve boekwaarden aan voor controle in de steekproef.
    - Verwijderen: Verwijdert negatieve boekwaarden.

- Betrouwbaarheidsinterval (Alt. Hypothese)
  - Bovengrens (< materialiteit): Bereken de bovengrens en test de alternatieve hypothese dat onjuistheid < materialiteit.
  - Tweezijdig (< materialiteit): Bereken de boven- en ondergrens en toets de alternatieve hypothese dat onjuiste opgave != materialiteit.
  - Ondergrens (< materialiteit): Bereken de ondergrens en test de alternatieve hypothese dat onjuistheid > materialiteit.

### Output
---

#### Samenvatting van de evaluatie
- Materialiteit: Indien verstrekt, de materialiteit van de prestatie.
- Min. nauwkeurigheid: Indien verstrekt, de minimale precisie.
- Steekproefgrootte: De steekproefgrootte (aantal eenheden).
- Fouten: Het aantal foutieve elementen in de selectie.
- Fouten: De som van de proportionele fouten. Gecontroleerde posten kunnen worden geëvalueerd met inachtneming van de omvang van de onjuistheid door hun tint te berekenen. De tint van een post *i* is het proportionele verschil tussen de boekwaarde van die post (*y*) en de gecontroleerde (werkelijke) waarde van de post (*x*). Positieve tinten worden geassocieerd met te hoge opgaven, terwijl negatieve tinten voorkomen wanneer posten te laag zijn opgegeven.
<img src="%HELP_FOLDER%/img/taints.png" />
- Meest waarschijnlijke fout: De meest waarschijnlijke fout in de populatie.
- x-% Betrouwbaarheidsgrens: Bovengrens van de fout in de populatie.
- Precisie: Verschil tussen bovengrens en meest waarschijnlijke fout.
- p: De p-waarde voor de test.

#### Correcties op de populatie
- Correctie: De hoeveelheid of het percentage dat van de populatie moet worden afgetrokken.

#### Plots
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de bovengrens van de onjuistheid en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Scatter plot: Produceert een scatter plot waarin de boekwaarden van de selectie worden vergeleken met hun controlewaarden. Waarnemingen die een fout bevatten zijn rood gekleurd.
  - Weergave correlatie: Voegt de correlatie tussen de boekwaarden en de controlewaarden toe aan de plot.
  - Item ID's weergeven: Voegt de item ID's toe aan de plot.

### Referenties
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R-pakket versie 0.6.6.
- Leslie, D. A., Teitlebaum, A. D., Anderson, R. J. (1979). <i>Dollar-unit Sampling: A Practical Guide for Auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K. W. (1963) Practical aspects of statistical sampling in auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- jfa