Bayesiaanse evaluatie
===

Met de Bayesiaanse evaluatieanalyse kan de gebruiker op basis van een controlesteekproef conclusies trekken over de totale onjuistheid in de populatie.

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
- Aantal eenheden: Het totale aantal eenheden in de populatie. Merk op dat de eenheden items (rijen) of monetaire eenheden (waarden) kunnen zijn, afhankelijk van de controlevraag.

#### Weergave
- Verklarende tekst: Indien aangevinkt, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Voorafgaande
- Verdeling
  - Gamma: De gamma-verdeling hoort bij de Poisson waarschijnlijkheid. De Poissonwaarschijnlijkheid gaat uit van een oneindige populatieomvang en wordt daarom meestal gebruikt wanneer de populatieomvang groot is. Het is een waarschijnlijkheid die het foutenpercentage (*u03B8*) modelleert als functie van de waargenomen steekproefomvang (*n*) en de som van de gevonden proportionele fouten (*t*). Omdat de gamma-verdeling rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u een steekproef voor monetaire eenheden plant (Stewart, 2013).
  - Bèta: De bèta-verdeling hoort bij de binomiale waarschijnlijkheid. De binomiale waarschijnlijkheid gaat uit van een oneindige populatiegrootte en wordt daarom meestal gebruikt als de populatiegrootte groot is. Het is een likelihood die het percentage onjuistheden (*n - k*) modelleert als functie van het waargenomen aantal fouten (*k*) en het aantal correcte transacties (*n - k*). Omdat de binomiale verdeling strikt genomen geen rekening houdt met gedeeltelijke fouten, wordt deze meestal gebruikt wanneer u geen steekproef voor monetaire eenheden plant. De bèta-verdeling accommodeert echter wel partiële fouten, en kan ook gebruikt worden voor monetaire eenheidssteekproeven (de Swart, Wille & Majoor, 2013).
  - Beta-binomiaal: De beta-binomiale verdeling hoort bij de hypergeometrische likelihood (Dyer & Pierce, 1993). De hypergeometrische waarschijnlijkheid gaat uit van een eindige populatiegrootte en wordt daarom meestal gebruikt als de populatiegrootte klein is. Het is een waarschijnlijkheid die het aantal fouten (*K*) in de populatie modelleert als functie van de populatiegrootte (*N*), het aantal waargenomen gevonden fouten (*k*) en het aantal correcte verrichtingen (*n*).

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

- Verwachte fouten
De verwachte fouten zijn de toelaatbare fouten die in de steekproef kunnen worden aangetroffen terwijl toch de gespecificeerde steekproefdoelstellingen worden gehaald. Een steekproefomvang wordt zodanig berekend dat, wanneer het aantal verwachte fouten in de steekproef wordt aangetroffen, de gewenste betrouwbaarheid behouden blijft.

*Noot:* Geadviseerd wordt deze waarde conservatief vast te stellen om de kans dat de waargenomen fouten groter zijn dan de verwachte fouten, hetgeen zou betekenen dat er onvoldoende werk is verricht, zo klein mogelijk te houden.

- Relatief: Voer uw verwachte fouten in als percentage ten opzichte van de totale omvang van de selectie.
- Absoluut: Voer uw verwachte fouten in als de som van de (proportionele) fouten.

#### Verslag
- Tabellen
  - Foutieve items: Produceert een tabel met alle items die een onjuiste opgave bleken te bevatten.
  - Prior en posterior: Produceert een tabel waarin de prior en verwachte posterior verdeling worden samengevat via verschillende statistieken, zoals hun functionele vorm, hun prior en verwachte posterior kansen en waarschijnlijkheden, en de verschuiving daartussen.
  - Correcties op populatie: Produceert een tabel die de vereiste correcties op de populatiewaarde bevat om de steekproefdoelstellingen te bereiken.
  - Aannamecontroles: Produceert een tabel die de correlatie weergeeft tussen de boekwaarden in de steekproef en hun tinten.
    - Betrouwbaarheidsinterval: Breedte van het betrouwbaarheidsinterval voor de correlatie.

- Plots
  - Steekproefdoelstellingen: Produceert een staafdiagram dat de materialiteit, maximale onjuistheid en meest waarschijnlijke fout (MLE) vergelijkt.
  - Schattingen: Produceert een intervalplot voor de populatie en optioneel de stratumschattingen van de onjuistheid.
  - Prior en posterior: Produceert een plot die de prior-verdeling en de posterior-verdeling toont na het observeren van de beoogde steekproef.
    - Extra info: Annoteert de figuur met de modus en het geloofwaardigheidsinterval. Als een materialiteit is gespecificeerd, wordt de figuur geannoteerd met de materialiteit en bevat een visualisatie van de Bayes-factor via een proportioneel wiel.

- Formaat uitvoer
  - Getallen: Tabeluitvoer weergeven als getallen.
  - Percentages: Tabeluitvoer weergeven als percentages.
  - Monetaire waarden: Tabeluitvoer weergeven als monetaire waarden.

#### Geavanceerd
- Kritische items
  - Negatieve boekwaarden: Isoleert negatieve boekwaarden uit de populatie.
    - Bewaren: Houdt negatieve boekwaarden om te inspecteren in de steekproef.
    - Verwijderen: Verwijdert negatieve boekwaarden.

- Algoritme
  - Gedeeltelijke projectie: Als u op dit vakje klikt, kunt u de bekende en de onbekende onjuistheden in de populatie scheiden om efficiënter te werk te gaan. Merk op dat dit de veronderstelling vereist dat de onjuistheden in de steekproef representatief zijn voor de onjuistheden in het ongeziene deel van de populatie.
  - Informatie delen: Als u op dit vakje klikt, kunt u informatie delen tussen strata met behulp van een zogenaamde multilevel-modellering.

- Geloofwaardigheidsinterval (Alt. Hypothese)
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
- BF-+: De Bayes-factor voor de test.

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

#### Correcties op de bevolking
- Correctie: Het bedrag of percentage dat van de populatie moet worden afgetrokken.

#### Aannamecontroles
- n: Steekproefgrootte.
- Pearsons r: Pearson correlatiecoëfficiënt.
- x-% bovengrens: Bovengrens voor de correlatiecoëfficiënt.
- p: p-waarde voor de test.
- BF-0: Bayes-factor voor de test.

#### Plots
- Prior en posterior: Produceert een plot die de prior-verdeling en de posterior-verdeling toont na waarneming van het beoogde monster.
  - Extra info: Annoteert de figuur met de modus en het geloofwaardigheidsinterval. Indien een materialiteit is gespecificeerd, wordt de figuur geannoteerd met de materialiteit en bevat een visualisatie van de Bayes-factor via een proportiewiel.
- Posterior voorspellend: Produceert een plot van de voorspellingen van de posterior distributie.
- Steekproefdoelen: Produceert een staafdiagram waarin de materialiteit, de maximale onjuistheid en de meest waarschijnlijke fout (MLE) worden vergeleken.
- Scatter plot: Produceert een scatter plot waarin de boekwaarden van de selectie worden vergeleken met hun controlewaarden. Waarnemingen die een fout bevatten zijn rood gekleurd.
  - Weergave correlatie: Voegt de correlatie tussen de boekwaarden en de controlewaarden toe aan de plot.
  - Item ID's weergeven: Voegt de item ID's toe aan de plot.

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