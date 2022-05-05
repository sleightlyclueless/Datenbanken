# Aufgabenbeschreibung zu den SQL-SELECTs

Diese readme.md dient als **Template** für Ihre SQL-SELECT Statements für Praktikum 3.
 
Nachdem Sie die zusätzlichen Daten (siehe Aufgabenbeschreibung Praktikum 3) in Ihre Datenbank geladen haben und Ihre SQL-SELECT Statements das erwartete Ergebnis (siehe bereitgestellte Lösungen in Moodle) liefern, fügen Sie diese SQL Statements hier in die entsprechenden Felder unter [SQL-SELECT Statements](#sql-select-statements) ein. Diese Statements werden geprüft und Gegenstand des Praktikums sein. 

Die Musterlösungen zu den einzelnen SQL-Statements werden Ihnen ausgehändigt, sodass Sie vor der Einreichung selbst kontrollieren können, ob Ihr Ergebnis korrekt ist. 

<br>

# Zu beachtende Regeln!
Beachten Sie bei der Bearbeitung dieser Aufgabe folgendes:

### Regel Nr. 1 
Formatieren sie die SQL-SELECT Statements so, dass es einfach ist diese zu lesen. Das bedeutet, schreiben Sie die SELECT-Statements **NICHT** in eine einzige Zeile, wie z.B.:    
```sql
SELECT  a.col1, b.col2, AVG(b.col3) AS avg, FROM table_a a, table_b b WHERE a.col1 = b.col2 GROUP BY a.col1, b.col2 ORDER BY avg HAVING (avg > (SELECT max(col1) FROM table_c)); 
```    
    
Schreiben Sie die Statements stattdessen mit den einzelnen SQL Key-Fragmenten (SELECT, FROM, WHERE, etc.) pro Zeile und mit den nötigen Indents (Einrückungen) auf, wie z.B. hier:
```sql
SELECT a.col1, b.col2, AVG(b.col3) AS avg
    FROM table_a a, table_b b
    WHERE a.col1 = b.col2
    GROUP BY a.col1, b.col2
    ORDER BY avg
    HAVING (avg < 
        (SELECT max(col1)
            FROM table_c));       
```  

<br>

### Regel Nr. 2 (WICHTIG!!!)
Machen Sie sich klar, dass Ihr SQL-Statement nicht dadurch automatisch korrekt ist, dass es die gleichen
Ausgaben liefert, wie sie in der Lösung stehen! Ihr Statement sollte die gestellte Frage beantworten, und nicht „rein zufällig“ die gleiche Ausgabe liefern.

Als Beispiel folgende **Aufgabe 0**:<br>
"Für welche Flugnummern haben Passagiere $200 für einen Platz bezahlt?"<br>
Das richtige Ergebnis ist die Projektion von Flugnummer mit dem einzigen Eintrag "**LH-200**". 

Ihre SQL-Abfrage darf **NICHT** folgendermaßen lauten:
```sql
SELECT flugnr
    FROM Buchung
    WHERE flugnr = "LH-200";
``` 
Das wäre eine vollkommen falsche Abfrage mit der zufällig gleichen Ausgabe. Durch solche SQL-Statements gefährden Sie die Erteilung eines Testats enorm! 

Korrekt wäre die Abfrage:
```sql
SELECT flugnr
    FROM Buchung
    WHERE Preis = "$200";
```

Zusätzlich können Sie auch gerne Erklärungen zu Ihren SQL-Select Statements schreiben, um zu erklären was da genau passiert, oder warum Sie sich für diese Query entschieden haben

<br>

Und nun viel Spaß bei der Generierung der SQL-Statements :-)

<br>

# SQL-SELECT Statements

1. Welche Flüge gehen am 01.10.2018?
    ```sql
    SELECT *
    FROM abflug
    WHERE datum = '2018-01-10';
    ```
2. Geben Sie Name, Vorname und Flugnummer aller Passagiere aus, die überhaupt Flüge gebucht haben.
    ```sql
    SELECT p.nachname, p.vorname, b.flugnr
    FROM passagier p INNER JOIN buchung b ON p.kundennr = b.kundennr;
    ```
3. Wie 2, jedoch nur für Abﬂüge am 02.10.2018.
    ```sql
    SELECT p.nachname, p.vorname, b.flugnr
    FROM passagier p INNER JOIN buchung b ON p.kundennr = b.kundennr
    WHERE b.datum = '2018-02-10';
    ```
4.  Geben Sie die Namen (und **nur** die Namen) der Flughäfen an, die von London Heathrow (LHR) aus angeﬂogen werden.
    ```sql
    SELECT f.name
    FROM flughafen f, flug
    WHERE f.iata_code = flug.ende
    AND flug.start = 'LHR';
    ```
5. Geben Sie die Gesamtsumme aus, die der Passagier „Michael Roth“ für Tickets ausgegeben hat.
     ```sql
    SELECT SUM(b.preis) AS "Ausgaben Herr Roth"
    FROM buchung b, passagier p
    WHERE b.kundennr = p.kundennr
    AND p.nachname = 'Roth'
    AND p.vorname = 'Michael';   
    ```
   
6. Geben Sie eine nach Anzahl der gebuchten Tickets sortierte Liste mit Namen und Vornamen der Passagiere sowie der Ticktanzahl aus.
     ```sql
    SELECT COUNT(b.buchungsnr) AS "Anzahl Tickets", p.nachname, p.vorname
    FROM passagier p, buchung b
    WHERE p.kundennr = b.kundennr
    GROUP BY b.kundennr, p.nachname, p.vorname
    ORDER BY COUNT(b.buchungsnr) DESC; 
    ```

7. Generieren Sie eine Liste, bei der alle Flüge mit der **Anzahl** der Abﬂüge ausgegeben werden. Sortieren Sie die Liste so, dass der Flug mit den meisten Abﬂügen ganz oben steht.
     ```sql
    SELECT flug.flugnr, COUNT(abflug.flugnr) AS "Anzahl"
    FROM flug, abflug
    WHERE flug.flugnr = abflug.flugnr
    GROUP BY flug.flugnr
    ORDER BY COUNT(abflug.flugnr) DESC;
    ```

8. Schreiben Sie eine Abfrage, welche Flughäfen anzeigt die **gar nicht** angeﬂogen werden.
     ```sql
    SELECT DISTINCT flughafen.iata_code
    FROM flughafen, flug
    WHERE flughafen.iata_code NOT IN (SELECT flug.ende FROM flug);
    ```

9. Welche Flughäfen sind von Frankfurt aus nicht mit einem Direktﬂug, sondern lediglich **mit einem Umstieg** zu erreichen?
     ```sql
    SELECT DISTINCT f.iata_code, f.name, f.laengengrad, f.breitengrad
    FROM flughafen f, flug
    /*Exclude direct flights from FRA*/
    WHERE f.iata_code NOT IN (SELECT flug.ende
                                FROM flug
                                WHERE flug.start = 'FRA')
    AND f.iata_code IN (SELECT flug.ende
                            FROM flug)
    /* Exclude Frankfurt from Results (no Flight from FRA-FRA) */
    AND f.iata_code NOT LIKE 'FRA';
    ```

10. Ist es möglich, am 03.10.2018 von Frankfurt (FRA) **über** London (LHR) nach Beijing (PEK) zu ﬂiegen? Geben Sie für jede mögliche Verbindung Startdatum, Startﬂughafen, Zwischenlandung, Zielﬂughafen **in jeweils einer Zeile** an. (Dabei wird davon ausgegangen, dass Folgeﬂüge am selben Tag noch erreicht werden können) 
    ```sql
    WITH semi_flights AS (
                SELECT a.datum, a.flugnr, flug.start, flug.ende
                FROM flug, abflug a
                WHERE flug.flugnr = a.flugnr
                AND flug.start = 'LHR'
                AND flug.ende = 'PEK')


    SELECT a.datum AS "Start-Datum", a.flugnr, flug.start, semi_flights.start AS "Zwischenstopp",
           semi_flights.datum AS "Zwischenstopp-Datum",
           semi_flights.flugnr AS "Zwischenstopp-FlugNr", semi_flights.ende
    FROM abflug a, flug, semi_flights
    WHERE a.flugnr = flug.flugnr
    AND flug.start = 'FRA'
    AND a.datum = '2018-03-10'
    AND flug.ende = 'LHR'
    AND flug.ende = semi_flights.start;
    ```

11. Wie viele Passagiere könnten theoretisch (bei voller Auslastung aller geplanten Abﬂüge) am 02.10.2018 von Frankfurt aus transportiert werden?
    ```sql
    SELECT SUM(f.sitzplaetze) AS "Gesamtanzahl moegliche Passagiere"
    FROM abflug a, flugzeug f, flug
    WHERE a.kennzeichen = f.kennzeichen
    AND a.flugnr = flug.flugnr
    AND a.datum = '2018-02-10'
    AND flug.start = 'FRA';
    ```
    
12. Geben Sie eine Liste aller Passagiere inklusive aller Flugdaten aus:
    - Nachname
    - Vorname
    - Preis
    - Flugnummer
    - Flugdatum
    - IATA-Code des Startﬂughafens
    - Name des Startﬂughafens
    - IATA-Code des Zielﬂughafens
    - Name des Zielﬂughafens
     ```sql
    /* Save end names and iata codes in tmp table */
    WITH end_query AS (
                SELECT f.name, flug.ende
                FROM passagier p, buchung b, abflug a, flug, flughafen f

                /* Connection between Buchung and Passagier (Customer name) */
                WHERE b.kundennr = p.kundennr

                /* Connection between Buchung and Abflug*/
                AND b.flugnr = a.flugnr
                AND b.datum = a.datum
                AND b.kennzeichen = a.kennzeichen

                /* Connection between Abflug and Flug (Start and End iata) */
                AND a.flugnr = flug.flugnr

                /*Connection between Flug and Flughafen (Name from iata) */
                AND flug.ende = f.iata_code)


    /* Main query with join from tmp end_query */
    SELECT DISTINCT p.nachname, p.vorname, b.preis, b.flugnr, b.datum, flug.start AS "IATA-Start",
                    f.name AS "Name-Start", flug.ende AS "IATA-Ende", end_query.name AS "Name-Ende"
    FROM passagier p, buchung b, abflug a, flug, flughafen f, end_query

    /* Connection between Buchung and Passagier (Customer name) */
    WHERE b.kundennr = p.kundennr

    /* Connection between Buchung and Abflug */
    AND b.flugnr = a.flugnr
    AND b.datum = a.datum
    AND b.kennzeichen = a.kennzeichen

    /* Connection between Abflug and Flug (Start and End iata) */
    AND a.flugnr = flug.flugnr

    /*Connection between Flug and Flughafen (Name from iata)*/
    AND flug.start = f.iata_code

    /* Add End-IATA to table from tmp query */
    AND end_query.ende = flug.ende

    /* Order result by lastname */
    ORDER BY p.nachname;
    ```

13. Generieren Sie eine absteigend sortierte Liste, die pro Flugzeugtyp angibt wie viele Passagiere in Summe bei voller Auslastung aller Abﬂüge befördert werden können.
     ```sql
    SELECT f.typ, SUM(f.sitzplaetze) AS "Anzahl-Passagiere"
    FROM abflug a, flugzeug f
    WHERE a.kennzeichen = f.kennzeichen
    GROUP BY f.typ
    ORDER BY SUM(f.sitzplaetze) DESC;
    ```

14. Welche Flughäfen sind am häuﬁgsten **Ziel** von Flugverbindungen?
     ```sql
    SELECT flughafen.iata_code, COUNT(flug.ende)
    FROM flug, flughafen
    WHERE flug.ende = flughafen.iata_code
    GROUP BY flug.ende, flughafen.iata_code
    HAVING COUNT(flug.ende) = (
                            SELECT COUNT(flug.ende)
                            FROM flug, flughafen
                            WHERE flug.ende = flughafen.iata_code
                            GROUP BY flug.ende, flughafen.iata_code
                            ORDER BY COUNT(flug.ende) DESC
                            LIMIT 1
                            )
    ORDER BY flughafen.iata_code;
    ```




































