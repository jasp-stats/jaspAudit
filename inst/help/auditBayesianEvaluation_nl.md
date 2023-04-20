Bayesiaanse evaluatie
===

Met de Bayesiaanse evaluatieanalyse kan de gebruiker op basis van een controlesteekproef conclusies trekken over de totale fout in de populatie.

<img src="%HELP_FOLDER%/img/workflowEvaluation.png" />

Zie de handleiding van de module Audit (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Input
---

#### Toewijzingsvak
- Item ID: Een unieke, niet ontbrekende identifier voor elk item in de populatie. Het rijnummer van de posten is voldoende.
- Boekwaarden: De variabele die de boekwaarden van de posten in de populatie bevat. Idealiter zijn alle boekwaarden positieve waarden, zie de optie <i>Kritische posten</i> voor de afhandeling van negatieve boekwaarden.
- Audit resultaat / waarden: De variabele die de audit (ware) waarden bevat, of de binaire classificatie van juist (0) of onjuist (1).
- Selectieteller: De variabele die bevat hoeveel keer elke waarneming moet worden geëvalueerd.
- Deelpopulatie: Een optionele variabele die voor elk item bevat tot welke deelpopulatie een poast behoort in de populatie. Het verstrekken van een deelpopulatie-variabele geeft aan de analyse aan dat de populatie in verschillende deelpopulatie is verdeeld en dat voor elk van deze deelpopulatie een uitspraak moet worden gedaan.

#### Steekproefdoelstellingen
- Uitvoeringsmaterialiteit: Ook wel de maximale fout, het aanvaardbare foutpercentage of de toelaatbare fout genoemd, is de uitvoeringsmaterialiteit de bovengrens van de fout in de te toetsen populatie. Door te toetsen aan een uitvoeringsmaterialiteit kunt u een steekproef plannen om bewijs te verzamelen voor of tegen de conclusie dat de populatie als geheel geen fouten bevat die als materieel worden beschouwd (d.w.z. groter zijn dan de bovengrens van de toelaatbare fout). U moet deze doelstelling inschakelen wanneer u aan de hand van een steekproef van de populatie wilt nagaan of de populatie fouten bevat boven of onder een bepaalde grens (de uitvoeringsmaterialiteit). Een lagere uitvoeringsmaterialiteit leidt tot een grotere vereiste steekproefomvang. Omgekeerd zal een hogere uitvoeringsmaterialiteit resulteren in een kleinere vereiste steekproefomvang.
- Minimale nauwkeurigheid: De nauwkeurigheid is het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout. Door deze steekproefdoelstelling in te schakelen, kunt u een steekproef zo plannen dat het verschil tussen de geschatte meest waarschijnlijke fout en de bovengrens van de fout tot een minimumpercentage wordt beperkt. U moet deze doelstelling inschakelen als u een schatting van de fout van de populatie met een bepaalde nauwkeurigheid wilt maken. Een lagere minimaal vereiste nauwkeurigheid leidt tot een hogere vereiste steekproefomvang. Omgekeerd zal een hogere minimaal vereiste nauwkeurigheid resulteren in een lagere vereiste steekproefomvang.

#### Betrouwbaarheid
Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de auditor bereid is te nemen om een onjuist oordeel over de populatie te geven. Als u bijvoorbeeld een auditrisico van 5% wilt hebben, komt dit overeen met een betrouwbaarheidsniveau van 95%.

#### Gegevenstype
- Populatie: Geef aan dat u een gegevensbestand gebruikt dat de populatie vertegenwoordigt. Dit vereist dat u een <i>Selectieteller</i> variabele gebruikt die aangeeft hoe vaak elk item is geselecteerd voor de steekproef.
- Steekproef: Geef aan dat u een gegevensbestand gebruikt dat alleen steekproefgegevens weergeeft.
- Samenvattende statistieken: Vereist geen gegevensinvoer en alleen samenvattende statistieken van de steekproef.

#### Populatie
- Aantal posten: Het totale aantal posten (rijen) in de populatie.
- Aantal eenheden: Het totale aantal eenheden in de populatie. De eenheden kunnen posten (rijen) of geldeenheden (waarden) zijn, afhankelijk van de controlevraag.

#### Weergave
- Toelichtende tekst: Indien aangevinkt, wordt in de analyse verklarende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.

#### Prior
- Kansverdeling: Specificeer de familie van de prior-verdeling.
  - Beta-binomiaal: De beta-binomiale verdeling hoort bij de hypergeometrische kansverdeling (Dyer & Pierce, 1993). De hypergeometrische kansverdeling gaat uit van een eindige populatie en wordt daarom meestal gebruikt als de populatieomvang klein is. Het is een waarschijnlijkheid die het aantal fouten (*K*) in de populatie modelleert als functie van de populatiegrootte (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal correcte verrichtingen (*n*).
  - Beta: De betaverdeling hoort bij de binomiale kansverdeling. De binomiale kansverdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt wanneer de populatieomvang groot is. Het is een kansverdeling die het percentage fouten (*\u03B8*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte eenheden (*n - k*). Omdat de binomiale verdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u geen geldsteekproef uitvoert. De beta-verdeling herbergt echter wel partiële fouten, en kan ook worden gebruikt voor geldsteekproeven (de Swart, Wille & Majoor, 2013).
  - Gamma: De gammaverdeling hoort bij de Poisson kansverdeling. De Poisson kansverdeling gaat uit van een oneindige populatie en wordt daarom meestal gebruikt als de populatieomvang groot is. Het is een waarschijnlijkheid die het percentage fouten (*\u03B8*) modelleert als functie van de steekproefomvang (*n*) en de som van de gevonden proportionele fouten (*t*). Omdat de gamma-verdeling rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u een geldsteekproef uitvoert (Stewart, 2013).

- Opstelling: Specificeer hoe de prior-verdeling moet worden geconstrueerd, of met andere woorden, welk type audit-informatie in de prior-verdeling moet worden opgenomen.
  - Standaard: Deze optie neemt geen informatie op in de statistische analyse en gaat daarom uit van een verwaarloosbare en conservatieve prior-verdeling.
  - Parameters: Geef de parameters van de prior-verdeling.
  - Eerdere steekproef: Creëer een prior-verdeling op basis van een eerdere steekproef.
    - Grootte: Grootte van de eerdere steekproef.
    - Fouten: Aantal eerder gevonden fouten.
  - Onpartijdig: Maak een prior-verdeling die onpartijdig is ten opzichte van de geteste hypothesen.
  - Risicobeoordelingen: Vertaal informatie uit het audit risicomodel in een prior verdeling.
    - Inherent risico: Een categorie of waarschijnlijkheid voor het inherente risico. Inherent risico wordt gedefinieerd als het risico van een materiele fout in de populatie door een andere factor dan het falen van de interne controle.
    - Intern beheersingsrisico: Een categorie of waarschijnlijkheid voor het interne beheersingsrisico. Intern beheersingsrisico wordt gedefinieerd als het risico op een materiele fout in de populatie als gevolg van het ontbreken of falen van de werking van relevante interne controles van de gecontroleerde.

- Verwachte fouten
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden aangetroffen terwijl toch de gespecificeerde steekproefdoelstellingen worden gehaald. Een steekproefomvang wordt zodanig berekend zodat, wanneer het aantal verwachte fouten in de steekproef wordt aangetroffen, de gewenste betrouwbaarheid behouden blijft.

*Noot:* Geadviseerd wordt deze waarde conservatief vast te stellen om de kans dat de waargenomen fouten groter zijn dan de verwachte fouten, hetgeen zou betekenen dat er onvoldoende werk is verricht, zo klein mogelijk te houden.

- Relatief: Voer uw verwachte fouten in als percentage ten opzichte van de totale omvang van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van de (proportionele) fouten.

#### Verslag
- Tabellen
  - Foute posten: Produceert een tabel met alle posten die een fout bleken te bevatten.
  - Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.
  - Prior en posterior: Produceert een tabel waarin de prior en verwachte posterior verdeling worden samengevat via verschillende statistieken, zoals hun functionele vorm, hun prior en verwachte posterior kansen en waarschijnlijkheden, en de verschuiving daartussen.
  - Aannamecontroles: Produceert een tabel die de correlatie weergeeft tussen de boekwaarden in de steekproef en hun tinten.
    - Betrouwbaarheidsinterval: Breedte van het betrouwbaarheidsinterval voor de correlatie.

- Figuren
  - Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, maximale onjuistheid en meest waarschijnlijke fout (MLE) worden vergeleken.
  - Schattingen: Produceert een intervalplot voor de populatie en optioneel de stratumschattingen van de onjuistheid.
  - Prior en posterior: Produceert een plot die de prior-verdeling en de posterior-verdeling toont na het observeren van de beoogde steekproef.
    - Extra info: Annoteert de figuur met de modus en het geloofwaardigheidsinterval. Als een materialiteit is gespecificeerd, wordt de figuur geannoteerd met de materialiteit en bevat een visualisatie van de Bayes-factor via een proportioneel wiel.

- Weergave Getallen
  - Numeriek: Getallen weergeven als numerieke waarden.
  - Percentages: Getallen weergeven als percentages.
  - Geldeenheden: Getallen weergeven als geldeenheden.

#### Geavanceerd
- Kritische posten
  - Negatieve boekwaarden: Isoleert negatieve boekwaarden uit de populatie.
    - Behoud: Houdt negatieve boekwaarden aan voor controle in de steekproef.
    - Verwijder: Verwijdert negatieve boekwaarden.

- Algoritme
  - Gedeeltelijke projectie: Als u op dit vakje klikt, kunt u de bekende en de onbekende fouten in de populatie scheiden om efficiënter te werk te gaan. Merk op dat dit de veronderstelling vereist dat de fouten in het geziene deel van de populatie representatief zijn voor de fouten in het ongeziene deel van de populatie.
  - Informatie delen: Als u op dit vakje klikt, kunt u informatie delen tussen deelpopulaties met behulp van een zogenaamd multilevel-model.

- Geloofwaardigheidsinterval (Alt. Hypothese)
  - Bovengrens (< materialiteit): Bereken de bovengrens en toets de alternatieve hypothese dat fout < materialiteit.
  - Tweezijdig (= materialiteit): Bereken de boven- en ondergrens en toets de alternatieve hypothese dat fout != materialiteit.
  - Ondergrens (< materialiteit): Bereken de ondergrens en toets de alternatieve hypothese dat fout > materialiteit.

### Output
---

#### Samenvatting van de evaluatie
- Materialiteit: Indien verstrekt, de uitvoeringsmaterialiteit.
- Min. nauwkeurigheid: Indien verstrekt, de minimale precisie.
- Steekproefgrootte: De steekproefgrootte (aantal eenheden).
- Fouten: Het aantal fouten in de steekproef.
- Taint: De som van de proportionele fouten. Gecontroleerde posten kunnen worden geëvalueerd met inachtneming van de omvang van de fout door hun taint te berekenen. De taint van een post *i* is het proportionele verschil tussen de boekwaarde van die post (*y*) en de gecontroleerde (werkelijke) waarde van de post (*x*). Positieve taints worden geassocieerd met te hoge opgaven, terwijl negatieve taints voorkomen wanneer posten te laag zijn opgegeven.
<img src="%HELP_FOLDER%/img/taints.png" />
- Meest waarschijnlijke fout: De meest waarschijnlijke fout in de populatie.
- x-% Betrouwbaarheidsgrens: De bovengrens van de fout in de populatie.
- Precisie: Het verschil tussen bovengrens en meest waarschijnlijke fout.
- BF-+: De Bayes factor voor de toets.

#### Prior en posterior
- Functionele vorm: De functionele vorm van de verdeling.
- Ondersteuning H-: Totale kans in het bereik van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Ondersteuning H+: Totale kans in het bereik van H+ onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Verhouding H- / H+: Kans in het voordeel van H- onder de verdeling. Wordt alleen weergegeven bij toetsing aan een prestatiematerialiteit.
- Gemiddelde: Gemiddelde van de verdeling.
- Mediaan: Mediaan van de verdeling.
- Modus: Modus van de verdeling.
- Bovengrens: x-percentiel van de verdeling.
- Nauwkeurigheid: Verschil tussen de bovengrens en de modus van de verdeling.

#### Correcties op de populatie
- Correctie: De hoeveelheid of het percentage dat van de populatie moet worden afgetrokken.

#### Aannamecontroles
- n: Steekproefgrootte.
- Pearsons r: Pearson correlatiecoëfficiënt.
- x-% bovengrens: Bovengrens voor de correlatiecoëfficiënt.
- p: p-waarde voor de test.
- BF-0: Bayes-factor voor de test.

#### Plots
- Prior en posterior: Produceert een plot die de prior-verdeling en de posterior-verdeling toont na waarneming van het beoogde monster.
  - Extra info: Annoteert de figuur met de modus en het geloofwaardigheidsinterval. Indien een materialiteit is gespecificeerd, wordt de figuur geannoteerd met de materialiteit en bevat een visualisatie van de Bayes-factor via een proportiewiel.
- Steekproefdoelstellingen: Produceert een staafdiagram waarin de materialiteit, de maximale fout en de meest waarschijnlijke fout (MLE) worden vergeleken.

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