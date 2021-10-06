Bayesiaanse Steekproef Workflow
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

#### Verwachte fouten in steekproef
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden gevonden terwijl de gespecificeerde steekproefdoelstellingen nog steeds worden bereikt. Er wordt een steekproefomvang berekend zodat, wanneer het aantal verwachte fouten in de steekproef wordt gevonden, het gewenste vertrouwen behouden blijft.

*Opmerking:* Het wordt aangeraden om deze waarde conservatief in te stellen om de kans te minimaliseren dat de waargenomen fouten de verwachte fouten overschrijden, wat zou betekenen dat er onvoldoende werk is verricht.

- Relatief: voer uw verwachte fouten in als een percentage ten opzichte van de totale grootte van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van (proportionele) fouten.

#### Kansverdeling
- Gamma: De gammaverdeling gaat samen met de Poisson-verdeling. De Poisson-verdeling gaat uit van een oneindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang groot is. Het is een verdeling waarmee het percentage afwijkingen (*\u03B8*) modelleerd als functie van de waargenomen steekproefomvang (*n*) en de som van de gevonden proportionele fouten (*t*). Omdat de gammaverdeling deelfouten mogelijk maakt, wordt deze over het algemeen gebruikt bij het plannen van een steekproef in munteenheden (Stewart, 2013).
- Beta: de bètaverdeling gaat samen met de binominaalverdeling. De binominaalverdeling gaat uit van een oneindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang groot is. Het is een verdeling waarmee het percentage afwijkingen (*\u03B8*) wordt gemodelleerd als functie van het waargenomen aantal fouten (*k*) en het aantal correcte transacties (*n - k*). Omdat de binominaalverdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze over het algemeen gebruikt wanneer u geen steekproef in een munteenheid plant. De betaverdeling is echter geschikt voor gedeeltelijke fouten en kan ook worden gebruikt voor steekproeven op monetaire eenheden (de Swart, Wille & Majoor, 2013).
- Beta-binomiaal: De beta-binomiaalverdeling gaat samen met de hypergeometrische verdeling (Dyer & Pierce, 1993). De hypergeometrische verdeling gaat uit van een eindige populatieomvang en wordt daarom over het algemeen gebruikt wanneer de populatieomvang klein is. Het is een verdeling waarmee het aantal fouten (*K*) in de populatie wordt gemodelleerd als functie van de populatieomvang (*N*), het aantal geobserveerde gevonden fouten (*k*) en het aantal correcte transacties (*N*).

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Tabellen
- Beschrijvende statistieken: Produceert een tabel met beschrijvende statistieken van de boekwaarden in de populatie.
- Impliciete eerdere steekproef: Produceert een tabel die de impliciete steekproef weergeeft waarop de prior verdeling is gebaseerd.
- Prior en posterior: Produceert een tabel waarin de eerdere en verwachte posterieure distributie worden samengevat door middel van verschillende statistieken, zoals hun functionele vorm, hun eerdere en verwachte posterieure kansen en kansen, en de verschuiving daartussen.

#### Figuren
- Prior en posterior: Produceert een plot die de prior verdeling en de posterieure distributie toont na observatie van het beoogde monster.
  - Extra info: Produceert stippen op de materialiteit.
- Prior predictive: Produceert een plot van de voorspellingen van de prior verdeling.
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.

#### Prior
- Standaard: deze optie neemt geen informatie op in de statistische analyse en gaat daarom uit van een verwaarloosbare en conservatieve eerdere verdeling.
- Handmatig: geef de parameters van de prior verdeling op.
- Eerdere steekproef: Maak een eerdere verdeling op basis van een eerdere steekproef.
  - Grootte: eerdere steekproefomvang.
  - Fouten: eerder gevonden fouten.
- Onpartijdig: maak een voorafgaande verdeling die onpartijdig is met betrekking tot de geteste hypothesen.
- Risicobeoordelingen: Vertaal informatie uit het auditrisicomodel naar een eerdere verspreiding.
  - Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico op een afwijking van materieel belang als gevolg van een fout of weglating in een financieel overzicht als gevolg van een andere factor dan een falen van de interne beheersing.
  - Beheersingsrisico: Een categorie of waarschijnlijkheid voor het internecontrolerisico. Het interne beheersingsrisico wordt gedefinieerd als het risico van een afwijking van materieel belang in de financiële overzichten die voortvloeit uit het ontbreken of falen van de relevante interne beheersingsmaatregelen van de gecontroleerde.

#### Kritieke items
- Negatieve boekwaarden: Isoleert negatieve boekwaarden van de populatie.
  - Bewaren: houdt negatieve boekwaarden die moeten worden geïnspecteerd in het monster.
  - Verwijderen: verwijdert negatieve boekwaarden.

#### Tabellen opmaken
- Cijfers: geef tabeluitvoer weer als getallen.
- Percentages: geef de tabeluitvoer weer als percentages.

#### Stapgrootte
Met de stapgrootte kunt u de mogelijke steekproefomvang beperken tot een veelvoud van de waarde. Een stapgrootte van 5 staat bijvoorbeeld alleen steekproefomvang van 5, 10, 15, 20, 25, enz. toe.

#### Veronderstel homogene taints
Als u op dit vakje klikt, kunt u de bekende en onbekende afwijking in de populatie scheiden om efficiënter te werken. Let op dat hiervoor de aanname vereist is dat de taints in de steekproef representatief zijn voor de taints in het onzichtbare deel van de populatie.

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

#### Impliciete voorafgaande steekproef
- Impliciete steekproefomvang: de steekproefomvang die overeenkomt met de voorafgaande informatie.
- Impliciete fouten: het aantal fouten dat gelijk is aan de eerdere informatie.

#### Prior en posterieur
- Functionele vorm: De functionele vorm van de distributie.
- Ondersteuning H-: Totale kans in het bereik van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Ondersteuning H+: Totale kans in het bereik van H+ onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Verhouding H- / H+: Kansen in het voordeel van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Gemiddelde: gemiddelde van de verdeling.
- Mediaan: Mediaan van de verdeling.
- Mode: Mode van de distributie.
- Bovengrens: x-% percentiel van de verdeling.
- Precisie: verschil tussen de bovengrens en de wijze van verdeling.

#### Figuren
- Prior en posterior: Produceert een plot die de prior verdeling en de posterieure distributie toont na observatie van het beoogde monster.
  - Extra info: Produceert stippen op de materialiteit.
- Prior predictive: Produceert een plot van de voorspellingen van de prior verdeling.
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.
- Verdeling van boekwaarden: Produceert een histogram van de boekwaarden in de populatie.

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
Zie *Kansverdeling*.

#### Gebied onder posterior
- Eenzijdige bovengrens: Geeft een (bovenste) schatting van de afwijking in de populatie.
- Tweezijdig interval: Geeft een (bovenste en onderste) schatting van de afwijking in de populatie.

#### Tabellen
- Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.
- Prior en posterior: Produceert een tabel waarin de eerdere en verwachte posterieure distributie worden samengevat door middel van verschillende statistieken, zoals hun functionele vorm, hun eerdere en verwachte posterieure kansen en kansen, en de verschuiving daartussen.
- Aannamecontroles: Produceert een tabel die de correlatie weergeeft tussen de boekwaarden in de steekproef en hun invloeden.
  - Betrouwbaarheidsinterval: Breedte van het betrouwbaarheidsinterval voor de correlatie.

#### Figuren
- Prior en posterior: Produceert een plot die de prior verdeling en de posterieure distributie toont na observatie van het beoogde monster.
  - Extra info: Produceert stippen op de materialiteit.
- Posterior predictive: Produceert een plot van de voorspellingen van de posterieure verdeling.
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de bovengrens van de afwijking en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.
  - Correlatie weergeven: Voegt de correlatie tussen de boekwaarden en de controlewaarden toe aan de plot.
  - Item-ID's weergeven: voegt de item-ID's toe aan de plot.

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
- BF-+: De Bayes-factor voor de test.

#### Prior en posterieur
- Functionele vorm: De functionele vorm van de distributie.
- Ondersteuning H-: Totale kans in het bereik van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Ondersteuning H+: Totale kans in het bereik van H+ onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Verhouding H- / H+: Kansen in het voordeel van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een uitvoeringsmaterialiteit.
- Gemiddelde: gemiddelde van de verdeling.
- Mediaan: Mediaan van de verdeling.
- Mode: Mode van de distributie.
- Bovengrens: x-% percentiel van de verdeling.
- Precisie: verschil tussen de bovengrens en de wijze van verdeling.

#### Correcties voor de bevolking
- Correctie: Het van de populatie af te trekken bedrag of percentage.

#### Aannamecontroles
- n: steekproefomvang.
- Pearsons r: Pearson-correlatiecoëfficiënt.
- x-% bovengrens: bovengrens voor correlatiecoëfficiënt.
- p: p-waarde voor de test.
- BF-0: Bayes-factor voor de test.

#### Figuren
- Prior en posterior: Produceert een plot die de prior verdeling en de posterieure distributie toont na observatie van het beoogde monster.
  - Extra info: Produceert stippen op de materialiteit.
- Posterior predictive: Produceert een plot van de voorspellingen van de posterieure verdeling.
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de bovengrens van de afwijking en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Spreidingsplot: Produceert een spreidingsplot die boekwaarden van de selectie vergelijkt met hun controlewaarden. Waarnemingen die fout zijn, zijn rood gekleurd.
  - Correlatie weergeven: Voegt de correlatie tussen de boekwaarden en de controlewaarden toe aan de plot.
  - Item-ID's weergeven: voegt de item-ID's toe aan de plot.

### Referenties
---
- AICPA (2017). <i>Auditgids: controlesteekproeven</i>. American Institute of Certified Public Accountants.
- Derks, K (2021). jfa: Bayesiaanse en klassieke auditsteekproeven. R-pakket versie 0.6.0.
- Dyer, D., & Pierce, R.L. (1993). Over de keuze van de voorafgaande verdeling bij hypergeometrische steekproeven. <i>Communicatie in statistiek-theorie en methoden</i>, 22(8), 2125-2146.
- Stewart, TR (2013). Een Bayesiaans audit assurance-model met toepassing op het component materialiteitsprobleem bij groepsaudits (proefschrift).
- de Swart, J., Wille, J., & Majoor, B. (2013). Het 'Push-Left'-Principe als Motor van Data Analytics in de Accountantcontrole [Het 'Push-Left'-Principe als aanjager van Data Analytics in Financial Audit]. <i>Maandblad voor Accountancy en Bedrijfseconomie</i>, 87, 425-432.

### R-pakketten
---
- jfa