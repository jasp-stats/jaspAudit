Evaluatie
===

De evaluatieanalyse stelt de gebruiker in staat om op basis van een controlesteekproef conclusies te trekken over de totale afwijking in de populatie.

<img src="%HELP_FOLDER%/img/workflowEvaluation.png" />

Zie de handleiding van de Audit module (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Invoer
---

#### Steekproef Doelstellingen
- Uitvoeringsmaterialiteit: ook wel de bovengrens voor de fout, het maximaal toelaatbare afwijkingspercentage of de maximaal toelaatbare afwijking genoemd, de uitvoeringsmaterialiteit is de bovengrens van de toelaatbare afwijking in de te testen populatie. Door te toetsen aan een uitvoeringsmaterialiteit bent u in staat een steekproef te plannen om bewijs te verzamelen voor of tegen de stelling dat de populatie als geheel geen afwijkingen bevat die als materieel worden beschouwd (d.w.z groter zijn dan de uitvoeringsmaterialiteit). U moet deze doelstelling inschakelen als u met een steekproef uit de populatie wilt weten of de populatie een afwijking boven of onder een bepaalde limiet (de prestatiematerialiteit) bevat. Een lagere uitvoeringsmaterialiteit zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een lagere steekproefomvang.
- Minimale precisie: de precisie is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef plannen zodat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de afwijking tot een minimumpercentage wordt teruggebracht. U moet deze doelstelling inschakelen als u geïnteresseerd bent in het maken van een schatting van de populatieafwijking met een bepaalde nauwkeurigheid. Een lagere minimaal vereiste precisie zal resulteren in een hogere steekproefomvang. Omgekeerd zal een hogere minimale precisie resulteren in een vereiste steekproefomvang.

#### Populatie
- Aantal items: Het totale aantal items (rijen) in de populatie.
- Aantal eenheden: Het totale aantal eenheden in de populatie. Let op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van het controlevraagstuk.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de gebruiker bereid is te nemen om een ​​onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een controlerisico van 5% wilt hebben, staat dit gelijk aan 95% betrouwbaarheid.

#### Opdrachtbox
- Item-ID: een unieke niet-ontbrekende identifier voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarden: de variabele die de boekwaarden van de items in de populatie bevat.
- Auditresultaat / waarden: De variabele die de audit (true) waarden bevat, of de binaire classificatie van correct (0) of incorrect (1).
- Selectieteller: De variabele die aangeeft hoe vaak elke waarneming moet worden geëvalueerd.

#### Gegevens
- Raw: gebruik onbewerkte gegevens.
- Overzichtsstatistieken: gebruik overzichtsstatistieken.

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

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Tabellen
- Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.

#### Figuren
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de maximale afwijking en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.

#### Kritieke items
- Negatieve boekwaarden: Isoleert negatieve boekwaarden van de populatie.
  - Bewaren: houdt negatieve boekwaarden die moeten worden geïnspecteerd in het monster.
  - Verwijderen: verwijdert negatieve boekwaarden.

#### Tabellen opmaken
- Cijfers: geef tabeluitvoer weer als getallen.
- Percentages: geef de tabeluitvoer weer als percentages.
- Geëxtrapoleerde bedragen: geef tabeluitvoer weer als geldwaarden.

### Uitgang
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
- Derks, K (2021). jfa: Bayesiaanse en klassieke auditsteekproeven. R-pakket versie 0.6.0.
- Leslie, D.A., Teitlebaum, A.D., Anderson, R.J. (1979). <i>Sampling in dollars: een praktische gids voor auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K.W. (1963) Praktische aspecten van statistische steekproeven bij auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R-pakketten
---
- jfa