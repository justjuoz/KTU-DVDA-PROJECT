### Sukurti duomenų produkciją - analitinę aplikaciją, skirtą banko paskolos įvertinimui naudojant mašininio mokymosi algoritmus.

### Struktūra:

### "1-data" - Duomenų failų aplankas;

### "2-report" - Atlikta žvalgomoji analizė;

### "3-R" - R programavimo kalba failuose atlikti duomenų tvarkymo darbai ir modeliavimas;

### "4-model" - Aplanke patalpintas modelis "my_best_gbmmodel", atitinkantis minimalias užduoties sąlygas (AUC > 0.8); Modelis sukurtas naudojant GBM metodą. Testavimo imties AUC kreivė = 0;

### "5-predictions" - csv failas, nurodantis prognozuojamas tikimybes priskirtiems įrašams. "predictionsgbm1.csv" sukurtas su  sugeneruotas naudojant GBM modelį iš "4-model" aplanko.

### "app" - Šiame aplankale yra Shiny WEB aplikacija, kuri leidžia banko darbuotojui įvesti duomenis apie klientą ir su sukurtu modeliu prognozuoti ar paskolą verta duoti ar ne.




