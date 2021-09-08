Bayesiaanse Planning
===

Met de Bayesiaanse planningsanalyse kan de gebruiker een minimale steekproefomvang berekenen op basis van een reeks steekproefdoelstellingen en samenvattende statistieken van de populatie. Houd er rekening mee dat wanneer u toegang heeft tot de onbewerkte populatiegegevens, u misschien de auditworkflow wilt gebruiken, een analyse die u door het steekproefproces leidt.

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
- Impliciete eerdere steekproef: Produceert een tabel die de impliciete steekproef weergeeft waarop de prior verdeling is gebaseerd.
- Prior en posterior: Produceert een tabel waarin de eerdere en verwachte posterieure distributie worden samengevat door middel van verschillende statistieken, zoals hun functionele vorm, hun eerdere en verwachte posterieure kansen en kansen, en de verschuiving daartussen.

#### Figuren
- Prior en posterior: Produceert een plot die de prior verdeling en de posterieure distributie toont na observatie van het beoogde monster.
  - Extra info: Produceert stippen op de materialiteit.
- Prior predictive: Produceert een plot van de voorspellingen van de prior verdeling.
- Vergelijk steekproefomvang: Produceert een plot die de steekproefomvang vergelijkt 1) over kansverdelingen, en 2) over het aantal verwachte fouten in de steekproef.

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