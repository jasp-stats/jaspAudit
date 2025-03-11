Selectie
===

Met de selectieanalyse kan de gebruiker een aantal steekproefeenheden uit een populatie selecteren met een combinatie van steekproefeenheden (postensteekproef versus geldsteekproef) en selectiemethoden (aselecte steekproef, cel steekproef, vast interval steekproef) die standaard zijn in een auditcontext.

<img src="%HELP_FOLDER%/img/workflowSelection.png" />

Zie de handleiding van de Audit module (lees [hier](https://koenderks.github.io/jaum/)) voor meer gedetailleerde informatie over deze analyse.

### Input
---

#### Toewijzingsvak
- Item ID: Een unieke, niet ontbrekende identifier voor elke post in de populatie. Het rijnummer van de posten is voldoende.
- Boekwaarden: De variabele die de boekwaarden van de posten in de populatie bevat. Idealiter zijn alle boekwaarden positief, alle posten met negatieve boekwaarden worden verwijderd voor selectie.
- Aanvullende variabelen: Alle andere variabelen die in de steekproef moeten worden opgenomen.

#### Steekproefomvang
Het vereiste aantal steekproefeenheden dat uit de populatie moet worden geselecteerd. De steekproefeenheden worden bepaald door de optie *Eenheden*. Als er geen boekwaarden zijn opgegeven, zijn de steekproefeenheden standaard posten (rijen). Wanneer boekwaarden worden opgegeven, zijn de ideale steekproefeenheden geldeenheden.

#### Toevalsgenerator beginwaarde
Selecteert  voor de random number generator om de resultaten te reproduceren.

#### Randomize Item Order
Randomiseert de volgorde van de items in de populatie voordat de selectieprocedure wordt uitgevoerd.

#### Steekproefeenheden
- Posten: Voert een selectie uit met de posten in de populatie als steekproefeenheden.
- Geldeenheden: Voert de selectie uit met de monetaire eenheden in de populatie als steekproefeenheden. Deze methode verdient de voorkeur wanneer u meer posten met een hoge waarde in de steekproef wilt opnemen.

#### Selectiemethode
- Vast interval steekproef: Voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een vaste eenheid te selecteren. Elke post met een boekwaarde groter dan het interval wordt altijd opgenomen in de steekproef.
  - Startpunt: Bepaalt welke steekproefeenheid wordt geselecteerd uit elk van de berekende intervallen.
    - Willekeurig: Stelt willekeurig een startpunt in het berekende interval in met behulp van de opgegeven toevalsgenerator beginwaarde.
    - Aangepast: Handmatig een beginpunt in het berekende interval opgeven.
- Cel steekproef: Voert selectie uit door de populatie in gelijke intervallen te verdelen en in elk interval een variabele eenheid te selecteren. Elke post met een boekwaarde groter dan tweemaal het interval wordt altijd opgenomen in de steekproef. Deze methode gebruikt de opgegeven toevalsgenerator beginwaarde.
- Willekeurige steekproef: Voert een willekeurige selectie uit waarbij elke steekproefeenheid een gelijke kans heeft om geselecteerd te worden. Deze methode gebruikt de opgegeven toevalsgenerator beginwaarde.

#### Weergave
- Toelichtende tekst: Indien aangevinkt, wordt in de analyse verklarende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.

#### Rapport
- Tabellen
  - Geselecteerde posten: Produceert een tabel met de geselecteerde posten samen met eventuele aanvullende waarnemingen die in het veld aanvullende variabelen zijn opgegeven.
  - Beschrijvende statistieken: Produceert een tabel met beschrijvende informatie over numerieke variabelen in de selectie. Statistieken die worden opgenomen zijn het gemiddelde, de mediaan, de standaardafwijking, de variantie, het minimum, het maximum en het bereik.

#### Exporteren
- Kolomnaam Selectieresultaat: Wanneer een naam is opgegeven, wordt het resultaat van de selectieanalyse in een nieuwe kolom aan de gegevens toegevoegd. De nieuwe kolom geeft aan hoe vaak elke transactie in de steekproef is opgenomen.
- Bestandsnaam: Klik op Bladeren om een locatie op uw computer te kiezen om de steekproefgegevens op te slaan.
- Synchronisatie inschakelen: Schakel synchronisatie in tussen de JASP-uitvoer en het op uw computer opgegeven bestand, waardoor de steekproefgegevens naar het opgegeven bestand worden geschreven.

### Uitvoer
---

#### Selectieoverzicht
- Aantal eenheden: Het aantal geselecteerde steekproefeenheden uit de populatie.
- Aantal posten: Het aantal geselecteerde posten uit de populatie.
- Selectie waarde: De totale waarde van de geselecteerde items. Wordt alleen weergegeven bij steekproeven met monetaire eenheden.
- % van populatieomvang: Het geselecteerde aandeel van de totale omvang of waarde van de populatie.

#### Informatie over monetaire intervalselectie
- Posten: Het aantal posten in de populatie.
- Waarde: De waarde van de posten in de populatie.
- Geselecteerde posten: Het aantal posten in de steekproef.
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

### Referenties
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R-pakket versie 0.7.0.

### R-pakketten
---
- jfa