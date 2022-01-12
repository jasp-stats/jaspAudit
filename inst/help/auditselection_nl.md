Selectie
===

De selectieanalyse stelt de gebruiker in staat om een ​​aantal steekproefeenheden uit een populatie te selecteren met behulp van een combinatie van steekproeftechnieken (recordsteekproef versus geldeenheidsteekproef) en steekproefmethoden (willekeurige steekproef, celsteekproef, vaste intervalsteekproef) die standaard zijn in een audit context.

<img src="%HELP_FOLDER%/img/workflowSelection.png" />

Zie de handleiding van de Audit module (download [hier](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) voor meer gedetailleerde informatie over deze analyse.

### Invoer
---

#### Opdrachtbox
- Item-ID: een unieke niet-ontbrekende identifier voor elk item in de populatie. Het rijnummer van de items is voldoende.
- Boekwaarden: de variabele die de boekwaarden van de items in de populatie bevat.
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

#### Weergave
- Verklarende tekst: indien ingeschakeld, wordt verklarende tekst in de analyse ingeschakeld om de procedure en de statistische resultaten te helpen interpreteren.

#### Kolomnaam Selectie Resultaat
Wanneer een naam is opgegeven, wordt het resultaat van de selectieanalyse in een nieuwe kolom aan de gegevens toegevoegd. De nieuwe kolom geeft weer hoe vaak elke transactie in de steekproef is opgenomen.

#### Tabellen
- Beschrijvende statistiek: Produceert een tabel met beschrijvende informatie over numerieke variabelen in de selectie. Statistieken die zijn opgenomen zijn het gemiddelde, de mediaan, de standaarddeviatie, de variantie, het minimum, het maximum en het bereik.
- Ruwe steekproef: produceert een tabel met de geselecteerde transacties samen met eventuele aanvullende waarnemingen in het veld met aanvullende variabelen.

### Uitgang
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

### Referenties
---
- AICPA (2017). <i>Auditgids: controlesteekproeven</i>. American Institute of Certified Public Accountants.
- Derks, K. (2022). jfa: Bayesiaanse en klassieke auditsteekproeven. R-pakket versie 0.6.2.

### R-pakketten
---
- jfa