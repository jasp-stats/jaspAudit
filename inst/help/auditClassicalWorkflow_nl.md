Bemonsteringsworkflow
===

De taak van een auditor is een oordeel te vellen over de eerlijkheid van de gepresenteerde transacties in een populatie. Als de auditor toegang heeft tot de ruwe populatiegegevens, kan hij de *audit workflow* gebruiken om te berekenen hoeveel steekproeven er moeten worden geëvalueerd om een bepaald vertrouwen in zijn oordeel te krijgen. De gebruiker kan dan een steekproef nemen uit de populatie, deze posten inspecteren en controleren, en statistische conclusies trekken over de onjuistheden in de populatie. De steekproefworkflow leidt de controleur door het controleproces, waarbij onderweg de juiste berekeningskeuzes worden gemaakt.

Zie de handleiding van de module Audit (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Workflow
---

- Planning: Bereken de minimale steekproefgrootte om uw steekproefdoelstellingen met de opgegeven betrouwbaarheid te bereiken.
- Selectie: Selecteer de vereiste steekproefeenheden uit de populatie.
- Uitvoering: Annoteer de selectie met uw beoordeling van de eerlijkheid van de geselecteerde items.
- Evaluatie: Maak een populatieverklaring op basis van je geannoteerde selectie.

<img src="%HELP_FOLDER%/img/workflow.png" />

### Input - Planning
---

#### Toewijzingsvak
- Item ID: Een unieke, niet ontbrekende identificatiecode voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarden: De variabele die de boekwaarden van de items in de populatie bevat. Idealiter zijn alle boekwaarden positieve waarden, zie de <i>Kritische items</i> optie voor de afhandeling van negatieve boekwaarden.

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
  - Beschrijvende statistieken: Produceert een tabel met beschrijvende statistieken van de boekwaarden in de populatie.

- Plots
  - Vergelijk steekproefgrootten: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
  - Veronderstelde gegevensverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefgrootte.
  - Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.

- Weergave Getallen
  - Numeriek: Getallen weergeven als numerieke waarden.
  - Percentages: Getallen weergeven als percentages.
  - Geldeenheden: Getallen weergeven als geldeenheden.

#### Geavanceerd
- Kansverdeling
  - Hypergeometrisch: De hypergeometrische verdeling gaat uit van een eindige populatie en wordt daarom meestal gebruikt als de populatieomvang klein is. Het is een kansverdeling die het aantal fouten (*K*) in de populatie modelleert als functie van de populatiegrootte (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal steekproefeenheden (*n*).
  - Binomiaal: De binomiale verdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt als de populatiegrootte groot is. Het is een kansverdeling die het percentage fouten (*\u03B8*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte eenheden (*n - k*). Omdat de binomiale verdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u geen steekproef voor monetaire eenheden plant.
  - Poisson: De Poisson-verdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt als de populatieomvang groot is. Het is een kansverdeling die het percentage fouten (*\u03B8*) modelleert als functie van het steekproefeenheden (*n*) en de som van de proportionele fouten (*t*). Omdat de Poisson-verdeling rekening houdt met gedeeltelijke fouten, wordt zij doorgaans gebruikt wanneer u een steekproef voor monetaire eenheden plant.

- Iteraties
  - Verhoging: Met het increment kunt u de mogelijke steekproefomvang beperken tot een veelvoud van de waarde ervan. Bijvoorbeeld, een increment van 5 staat alleen steekproefgroottes toe van 5, 10, 15, 20, 25, enz.
  - Maximum: Met het maximum kunt u de steekproefgrootte beperken met een maximum.

- Kritische items
  - Negatieve boekwaarden: Isoleert negatieve boekwaarden uit de populatie.
    - Houden: Houdt negatieve boekwaarden om te inspecteren in de steekproef.
    - Verwijderen: Verwijdert negatieve boekwaarden.

### Ouput - Planning
---

#### Planning Samenvatting
- Prestatiematerialiteit: Indien verstrekt, de prestatiematerialiteit.
- Min. nauwkeurigheid: Indien verstrekt, de minimale precisie.
- Verwachte fouten: Het aantal (som van proportionele tinten) verwachte / aanvaardbare fouten in de steekproef.
- Minimale steekproefomvang: De minimale steekproefomvang.

#### Beschrijvende statistieken
- Populatiegrootte: Aantal items in de populatie.
- Waarde: Totale waarde van de boekwaarden.
- Absolute waarde: Absolute waarde van de boekwaarden.
- Gemiddelde: Gemiddelde van de boekwaarden.
- Std. afwijking: Standaardafwijking van de boekwaarden.
- Kwartiel: Kwartielen van de boekwaarden.

#### Plots
- Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.
- Vergelijk steekproefgrootten: Produceert een plot die de steekproefgrootte vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde gegevensverdeling: Produceert een plot die de kansverdeling weergeeft die door de invoeropties en de berekende steekproefgrootte wordt geïmpliceerd.

### Invoer - Selectie
---

#### Toewijzingsvak
- Rangschikkingsvariabele: Indien opgegeven, wordt de populatie eerst gerangschikt in oplopende volgorde met betrekking tot de waarden van deze variabele.
- Aanvullende variabelen: Alle andere variabelen die in de steekproef moeten worden opgenomen.

#### Steekproefgrootte
Het vereiste aantal steekproefeenheden dat uit de populatie moet worden geselecteerd. De steekproefeenheden worden bepaald door de optie *eenheden*. Als er geen boekwaarden zijn opgegeven, zijn de steekproefeenheden standaard items (rijen). Wanneer boekwaarden worden opgegeven, zijn de ideale steekproefeenheden monetaire eenheden.

#### Steekproefeenheden
- Items: Voert een selectie uit met de items in de populatie als steekproefeenheden.
- Monetaire eenheden: Voert de selectie uit met de monetaire eenheden in de populatie als steekproefeenheden. Deze methode verdient de voorkeur wanneer u meer items met een hoge waarde in de steekproef wilt opnemen.

#### Selectiemethode
- Vast interval steekproef: Voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een vaste eenheid te selecteren. Elke post met een boekwaarde groter dan het interval wordt altijd opgenomen in de steekproef.
  - Startpunt: Bepaalt welke steekproefeenheid wordt geselecteerd uit elk van de berekende intervallen.
    - Willekeurig: Stelt willekeurig een startpunt in het berekende interval in met behulp van de opgegeven toevalsgenerator beginwaarde.
    - Aangepast: Handmatig een beginpunt in het berekende interval opgeven.
- Cel steekproef: Voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een variabele eenheid te selecteren. Elke post met een boekwaarde groter dan tweemaal het interval wordt altijd opgenomen in de steekproef. Deze methode gebruikt de opgegeven toevalsgenerator beginwaarde.
- Willekeurige steekproef: Voert een willekeurige selectie uit waarbij elke steekproefeenheid een gelijke kans heeft om geselecteerd te worden. Deze methode gebruikt de opgegeven toevalsgenerator beginwaarde.

#### Randomize Item Order
Randomiseert de items in de populatie voordat de selectie wordt uitgevoerd.

#### Tabellen
- Geselecteerde posten: Produceert een tabel met de geselecteerde posten samen met eventuele aanvullende waarnemingen die in het veld aanvullende variabelen zijn opgegeven.
- Beschrijvende statistieken: Produceert een tabel met beschrijvende informatie over numerieke variabelen in de selectie. Statistieken die worden opgenomen zijn het gemiddelde, de mediaan, de standaardafwijking, de variantie, het minimum, het maximum en het bereik.

### Uitvoer - Selectie
---

#### Selectieoverzicht
- Aantal eenheden: Het aantal geselecteerde steekproefeenheden uit de populatie.
- Aantal items: Het aantal geselecteerde items uit de populatie.
- Selectie waarde: De totale waarde van de geselecteerde items. Wordt alleen weergegeven bij steekproeven met monetaire eenheden.
- % van populatiegrootte / waarde: Het geselecteerde aandeel van de totale omvang of waarde van de populatie.

#### Informatie over monetaire intervalselectie
- Items: Het aantal items in de populatie.
- Waarde: De waarde van de items in de populatie.
- Geselecteerde items: Het aantal items in de steekproef.
- Geselecteerde eenheden: Het aantal geselecteerde eenheden uit de populatie.
- Selectie waarde: De waarde van de items in de steekproef.
- % van de totale waarde: Het geselecteerde aandeel van de totale waarde van de items ten opzichte van de items in de populatie.

#### Beschrijvende statistieken
- Geldig: Aantal geldige gevallen.
- Gemiddelde: Rekenkundig gemiddelde van de datapunten.
- Mediaan: Mediaan van de datapunten.
- Std. afwijking: Standaardafwijking van de gegevenspunten.
- Variantie: Variantie van de gegevenspunten.
- Bereik: Bereik van de gegevenspunten.
- Minimum: Minimum van de datapunten.
- Maximum: Maximum van de datapunten.

#### Geselecteerde items
- Rij: Het rijnummer van het item.
- Geselecteerd: Het aantal keren (een eenheid in) dat het item is geselecteerd.

### Invoer - Uitvoering
---

#### Annotatie
- Auditwaarde: Annoteer de items in de selectie met hun controle (ware) waarden. Deze aanpak wordt aanbevolen (en automatisch geselecteerd) wanneer de items een geldwaarde hebben.
- Juist / Onjuist: Annoteer de items in de selectie met correct (0) of incorrect (1). Deze aanpak wordt aanbevolen (en automatisch geselecteerd) wanneer de items geen geldwaarde hebben.

### Invoer - Evaluatie
---

#### Toewijzingsvak
- Auditresultaat / waarden: De variabele die de audit (ware) waarden bevat, of de binaire classificatie van juist (0) of onjuist (1).

#### Methode
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

#### Tabellen
- Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.

#### Plots
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, maximale onjuistheid en meest waarschijnlijke fout (MLE) worden vergeleken.
- Scatter plot: Produceert een scatter plot waarin de boekwaarden van de selectie worden vergeleken met hun controlewaarden. Waarnemingen met fouten zijn rood gekleurd.

### Output - Evaluatie
---

#### Evaluatie samenvatting
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
- AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R-pakket versie 0.6.5.
- Leslie, D. A., Teitlebaum, A. D., Anderson, R. J. (1979). <i>Dollar-unit Sampling: A Practical Guide for Auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K. W. (1963) Practical aspects of statistical sampling in auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- jfa