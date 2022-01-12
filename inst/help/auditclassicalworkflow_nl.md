Steekproef Workflow
===

De taak van een auditor is om een ​​oordeel te vellen over de billijkheid van de gepresenteerde transacties in een populatie. Wanneer de auditor toegang heeft tot de onbewerkte populatiegegevens, kan hij de *auditworkflow* gebruiken om te berekenen hoeveel monsters moeten worden geëvalueerd om een ​​zeker vertrouwen in zijn oordeel te krijgen. De gebruiker kan vervolgens steekproeven nemen van deze items uit de populatie, deze items inspecteren en controleren, en statistische conclusies trekken over de afwijking in de populatie. De workflow voor steekproeven leidt de auditor door het auditproces en maakt onderweg de juiste keuzes van berekeningen.

Zie de handleiding van de Audit module (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Werkstroom
---

- Planning: Bereken de minimale steekproefomvang om uw steekproefdoelstellingen met het gespecificeerde vertrouwen te bereiken.
- Selectie: Selecteer de gewenste steekproefeenheden uit de populatie.
- Uitvoering: Annoteer de selectie met uw beoordeling van de eerlijkheid van de geselecteerde items.
- Evaluatie: maak een bevolkingsverklaring op basis van uw geannoteerde selectie.

<img src="%HELP_FOLDER%/img/workflow.png" />

### Invoer - Planning
---

#### Steekproef Doelstellingen
- Uitvoeringsmaterialiteit: ook wel de bovengrens voor de fout, het maximaal toelaatbare afwijkingspercentage of de maximaal toelaatbare afwijking genoemd, de uitvoeringsmaterialiteit is de bovengrens van de toelaatbare afwijking in de te testen populatie. Door te toetsen aan een uitvoeringsmaterialiteit bent u in staat een steekproef te plannen om bewijs te verzamelen voor of tegen de stelling dat de populatie als geheel geen afwijkingen bevat die als materieel worden beschouwd (d.w.z groter zijn dan de uitvoeringsmaterialiteit). U moet deze doelstelling inschakelen als u met een steekproef uit de populatie wilt weten of de populatie een afwijking boven of onder een bepaalde limiet (de prestatiematerialiteit) bevat. Een lagere uitvoeringsmaterialiteit zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een lagere steekproefomvang.
- Minimale precisie: de precisie is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef plannen zodat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de afwijking tot een minimumpercentage wordt teruggebracht. U moet deze doelstelling inschakelen als u geïnteresseerd bent in het maken van een schatting van de populatieafwijking met een bepaalde nauwkeurigheid. Een lagere minimaal vereiste precisie zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere minimale precisie resulteren in een vereiste steekproefomvang.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de gebruiker bereid is te nemen om een ​​onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een controlerisico van 5% wilt hebben, staat dit gelijk aan 95% betrouwbaarheid.

#### Opdrachtbox
- Item-ID: een unieke niet-ontbrekende identifier voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarden: de variabele die de boekwaarden van de items in de populatie bevat.

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

#### Tabellen
- Beschrijvende statistieken: Produceert een tabel met beschrijvende statistieken van de boekwaarden in de populatie.

#### Figuren
- Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde foutenverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefomvang.

#### Kritieke items
- Negatieve boekwaarden: Isoleert negatieve boekwaarden van de populatie.
  - Bewaren: houdt negatieve boekwaarden die moeten worden geïnspecteerd in het monster.
  - Verwijderen: verwijdert negatieve boekwaarden.

#### Tabellen opmaken
- Cijfers: geef tabeluitvoer weer als getallen.
- Percentages: geef de tabeluitvoer weer als percentages.

#### Stapgrootte
Met de stapgrootte kunt u de mogelijke steekproefomvang beperken tot een veelvoud van de waarde. Een stapgrootte van 5 staat bijvoorbeeld alleen steekproefomvang van 5, 10, 15, 20, 25, enz. toe.

### Uitgang - Planning
---

#### Planningsoverzicht
- Uitvoeringsmaterialiteit: indien aanwezig, de uitvoeringsmaterialiteit.
- Min. precisie: indien aanwezig, de minimale precisie.
- Verwachte fouten: Het aantal (som van proportionele taints) verwachte / toelaatbare fouten in de steekproef.
- Minimale steekproefomvang: de minimale steekproefomvang.

#### Beschrijvende statistieken
- Populatiegrootte: aantal items in de populatie.
- Waarde: Totale waarde van de boekwaarden.
- Absolute waarde: Absolute waarde van de boekwaarden.
- Gemiddelde: gemiddelde van de boekwaarden.
- Soa. afwijking: Standaarddeviatie van de boekwaarden.
- Kwartiel: Kwartielen van de boekwaarden.

#### Figuren
- Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Veronderstelde foutenverdeling: Produceert een plot die de kansverdeling weergeeft die wordt geïmpliceerd door de invoeropties en de berekende steekproefomvang.

### Invoer - Selectie
---

#### Opdrachtbox
- Rangschikkingsvariabele: indien opgegeven, wordt de populatie eerst gerangschikt in oplopende volgorde met betrekking tot de waarden van deze variabele.
- Aanvullende variabelen: alle andere variabelen die in de steekproef moeten worden opgenomen.

#### Steekproefgrootte
Het vereiste aantal steekproefeenheden dat uit de populatie moet worden geselecteerd. Houd er rekening mee dat de steekproefeenheden worden bepaald door de optie *eenheden*. Als er geen boekwaarden worden opgegeven, zijn de steekproefeenheden standaard items (rijen). Wanneer boekwaarden worden verstrekt, zijn de ideale steekproefeenheden om te gebruiken monetaire eenheden.

#### Bemonsteringseenheden
- Items: voert selectie uit met behulp van de items in de populatie als steekproefeenheden.
- Monetaire eenheden: voert een selectie uit waarbij de monetaire eenheden in de populatie als steekproefeenheden worden gebruikt. Deze methode heeft de voorkeur als u meer items met een hoge waarde in de steekproef wilt opnemen.

#### Methode
- Steekproef met vast interval: voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een vaste eenheid te selecteren. Elk item met een waarde groter dan het interval wordt altijd in de steekproef opgenomen.
  - Startpunt: Selecteert welke bemonsteringseenheid wordt geselecteerd uit elk interval.
- Celbemonstering: voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een variabele eenheid te selecteren. Elk item met een waarde groter dan tweemaal het interval wordt altijd in de steekproef opgenomen.
  - Seed: Selecteert de seed voor de generator van willekeurige getallen om resultaten te reproduceren.
- Willekeurige steekproef: Voert willekeurige selectie uit waarbij elke steekproefeenheid een gelijke kans heeft om geselecteerd te worden.
  - Seed: Selecteert de seed voor de generator van willekeurige getallen om resultaten te reproduceren.

#### Items willekeurig maken
Randomiseert de items in de populatie voordat de selectie wordt uitgevoerd.

#### Tabellen
- Beschrijvende statistiek: Produceert een tabel met beschrijvende informatie over numerieke variabelen in de selectie. Statistieken die zijn opgenomen zijn het gemiddelde, de mediaan, de standaarddeviatie, de variantie, het minimum, het maximum en het bereik.
- Ruwe steekproef: produceert een tabel met de geselecteerde transacties samen met eventuele aanvullende waarnemingen in het veld met aanvullende variabelen.

### Uitvoer - Selectie
---

#### Selectie Samenvatting
- Aantal eenheden: Het aantal geselecteerde steekproefeenheden uit de populatie.
- Aantal items: Het aantal geselecteerde items uit de populatie.
- Selectiewaarde: De totale waarde van de geselecteerde items. Alleen weergegeven wanneer steekproeven op munteenheid worden gebruikt.
- % van populatieomvang / waarde: Het geselecteerde deel van de totale omvang of waarde van de populatie.

#### Informatie over monetaire intervalselectie
- Items: Het aantal items in de populatie.
- Waarde: De waarde van de items in de populatie.
- Geselecteerde items: het aantal items in de steekproef.
- Geselecteerde eenheden: Het aantal geselecteerde eenheden uit de populatie.
- Selectiewaarde: De waarde van de items in de steekproef.
- % van totale waarde: het geselecteerde aandeel van de totale waarde van de items in vergelijking met de items in de populatie.

#### Beschrijvende statistieken
- Geldig: aantal geldige gevallen.
- Gemiddelde: rekenkundig gemiddelde van de gegevenspunten.
- Mediaan: Mediaan van de gegevenspunten.
- Soa. deviatie: Standaarddeviatie van de gegevenspunten.
- Variantie: Variantie van de datapunten.
- Bereik: bereik van de datapunten.
- Minimum: Minimum van de datapunten.
- Maximum: Maximum van de datapunten.

#### Ruw monster
- Rij: het rijnummer van het item.
- Geselecteerd: het aantal keren (een eenheid in) dat het item is geselecteerd.

### Invoer - Uitvoering
---

#### Annotatie
- Auditwaarde: Annoteer de items in de selectie met hun audit (true) waarden. Deze aanpak wordt aanbevolen (en automatisch geselecteerd) wanneer de items een geldwaarde hebben.
- Correct/Incorrect: Annoteer de items in de selectie met correct (0) of incorrect (1). Deze aanpak wordt aanbevolen (en automatisch geselecteerd) wanneer uw artikelen geen geldwaarde hebben.

### Invoer - Evaluatie
---

#### Opdrachtbox
- Auditresultaat / waarden: De variabele die de audit (true) waarden bevat, of de binaire classificatie van correct (0) of incorrect (1).

#### Methode
- Poisson: gebruikt de Poisson-waarschijnlijkheid om het monster te evalueren.
- Binomiaal: gebruikt de binominale waarschijnlijkheid om het monster te evalueren.
- Hypergeometrische: gebruikt de hypergeometrische waarschijnlijkheid om het monster te evalueren.
- Stringer: de Stringer moet het monster evalueren (Stringer, 1963).
  - LTA-aanpassing: LTA-aanpassing voor de stringer die onvermijdelijk understatements bevat (Leslie, Teitlebaum, & Anderson, 1979).
- Gemiddelde-per-eenheid schatter: Gebruikt de gemiddelde-per-eenheid schatter.
- Directe schatter: Deze methode gebruikt alleen de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Verschilschatter: Deze methode gebruikt het verschil tussen de boekwaarden en de controlewaarden om de afwijking in te schatten (Touw en Hoogduin, 2011).
- Ratio schatter: Deze methode gebruikt de verhouding van correctheid tussen de boekwaarden en de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).
- Regressieschatter: Deze methode gebruikt de lineaire relatie tussen de boekwaarden en de controlewaarden om de afwijking te schatten (Touw en Hoogduin, 2011).

#### Tabellen
- Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.

#### Figuren
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de maximale afwijking en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.

### Uitvoer - Evaluatie
---

#### Evaluatieoverzicht
- Materialiteit: indien aanwezig, de uitvoeringsmaterialiteit.
- Min. precisie: indien aanwezig, de minimale precisie.
- Steekproefomvang: De steekproefomvang (aantal eenheden).
- Fouten: het aantal foutieve elementen in de selectie.
- Taint: De som van de proportionele fouten. Gecontroleerde items kunnen worden geëvalueerd terwijl de omvang van de afwijking wordt meegenomen door hun taint te berekenen. De taint van een item *i* is het proportionele verschil tussen de boekwaarde van dat item (*y*) en de controlewaarde (true) van het item (*x*). Positieve taint worden geassocieerd met te hoge bedragen, terwijl negatieve taints optreden wanneer items worden onderschat.
<img src="%HELP_FOLDER%/img/taints.png" />
- Meest waarschijnlijke fout: De meest waarschijnlijke fout in de populatie.
- x-% Betrouwbaarheidsgrens: Bovengrens van de afwijking in de populatie.
- Precisie: verschil tussen bovengrens en meest waarschijnlijke fout.
- p: De p-waarde voor de test.

#### Correcties voor de bevolking
- Correctie: Het van de populatie af te trekken bedrag of percentage.

#### Figuren
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de bovengrens van de afwijking en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.
  - Correlatie weergeven: Voegt de correlatie tussen de boekwaarden en de controlewaarden toe aan de plot.
  - Item-ID's weergeven: voegt de item-ID's toe aan de plot.

### Referenties
---
- AICPA (2017). <i>Auditgids: controlesteekproeven</i>. American Institute of Certified Public Accountants.
- Derks, K. (2022). jfa: Bayesiaanse en klassieke auditsteekproeven. R-pakket versie 0.6.2.
- Leslie, D. A., Teitlebaum, A.D., Anderson, R.J. (1979). <i>Sampling in dollars: een praktische gids voor auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K. W. (1963) Praktische aspecten van statistische steekproeven bij auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- jfa