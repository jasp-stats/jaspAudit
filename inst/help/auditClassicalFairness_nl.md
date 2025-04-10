Eerlijkheidsstatistieken
===

De eerlijkheidsanalyse stelt de gebruiker in staat om de eerlijkheid en discriminatie met betrekking tot specifieke groepen in de gegevens in algoritmische besluitvormingssystemen te beoordelen. Met inachtneming van een bepaalde positieve klasse in de data kan eerlijkheid -of discriminatie- gekwantificeerd worden met behulp van modelagnostische eerlijkheidsstatistieken. De verhouding van twee eerlijkheidsstatistieken wordt pariteit genoemd, een bekend concept in algoritmische eerlijkheid.

### Invoer
---

#### Toewijzingsvak
- Doel: In dit vak moet de doelvariabele (d.w.z. de te voorspellen variabele) worden ingevoerd.
- Voorspellingen: In dit vak moeten de voorspellingen van het algoritme over de doelvariabele worden ingevoerd.
- Gevoelig Kenmerk: In dit vak moet het beschermde (d.w.z. gevoelige) kenmerk worden ingevoerd.

#### Analyse
- Betrouwbaarheid: Het gebruikte betrouwbaarheidsniveau. Het betrouwbaarheidsniveau is het complement van het auditrisico: het risico dat de gebruiker bereid is te nemen om een onjuist oordeel over de populatie te geven. Als je bijvoorbeeld een auditrisico van 5% wilt gebruiken, is dit gelijk aan 95% betrouwbaarheid.
- Metriek: Het type eerlijkheidsstatistiek dat berekend moet worden.

#### Factorniveaus
- Bevoorrechte groep: De bevoorrechte groep verwijst naar de klasse in de beschermde variabele die historisch of systematisch bepaalde voordelen, voordelen of voorrechten ervaart.
- Positieve klasse: De positieve klasse in de doelvariabele.

### Alt. Hypothese
- Niet-bevoorrecht \u2260 Bevoorrecht: Test de alternatieve hypothese dat de eerlijkheidsmetriek van een niet-bevoorrechtte groep niet gelijk is aan de eerlijkheidsmetriek in de bevoorrechte groep.
- Niet-bevoorrecht < Bevoorrecht: Test de alternatieve hypothese dat de eerlijkheidsmetriek van een niet-bevoorrechtte groep lager is dan de eerlijkheidsmetriek in de bevoorrechte groep.
- Niet-bevoorrecht > Bevoorrecht: Test de alternatieve hypothese dat de eerlijkheidsmetriek van een niet-bevoorrechtte groep hoger is dan de eerlijkheidsmetriek in de bevoorrechte groep.

#### Bayes-factor
- BF10: Bayes factor om het bewijs voor de alternatieve hypothese ten opzichte van de nulhypothese te kwantificeren.
- BF01: Bayes factor om het bewijs voor de nulhypothese ten opzichte van de alternatieve hypothese te kwantificeren.
- Log(BF10): Natuurlijke logaritme van BF10.

#### Weergave
- Toelichtende tekst: Indien aangevinkt, wordt in de analyse toelichtende tekst weergegeven om de procedure en de statistische resultaten te helpen interpreteren.

#### Rapport
- Tabellen
  - Individuele vergelijkingen: Produceert een tabel waarin de niet-bevoorrechte groepen worden vergeleken met de bevoorrechte groep.
  - Modelprestaties: Produceert een tabel met de prestatiemetingen voor de classificatie, inclusief ondersteuning, nauwkeurigheid, precisie, recall en F1-score.
  - Verwarringsmatrix: Produceert de verwarringmatrix voor elke groep.
    - Proporties weergeven: Toont proporties in de verwarringstabel.

- Figuren
  - Pariteitsschattingen: Produceert een figuur met de pariteitstatistieken voor elke niet-bevoorrechte groep ten opzichte van de bevoorrechte groep.
  - Prior- en posterior-verdeling: Produceert een figuur die de prior- en posterior-verdeling laat zien.
  - Bayes factor robuustheid check: Produceert een figuur die de robuustheid van de Bayes factor ten opzichte van de prior-verdeling laat zien.
  - Sequentiële analyse: Produceert een figuur die de Bayes factor toont als functie van de steekproefgrootte.

#### Geavanceerd
- Prior-verdeling
  - Concentratie: De concentratieparameter van de Dirichlet prior-verdeling.
  - Toevalsgenerator beginwaarde: Selecteert de beginwaarde voor de willekeurige getallengenerator om de resultaten te reproduceren.

### Referenties
---
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package (latest version). https://cran.r-project.org/package=jfa

### R-pakketten
---
- jfa
