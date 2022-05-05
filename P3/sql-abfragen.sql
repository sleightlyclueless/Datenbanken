1:
SELECT *
FROM abflug
WHERE datum = '2018-01-10';

2:
SELECT p.nachname, p.vorname, b.flugnr
FROM passagier p INNER JOIN buchung b ON p.kundennr = b.kundennr;

3:
SELECT p.nachname, p.vorname, b.flugnr
FROM passagier p INNER JOIN buchung b ON p.kundennr = b.kundennr
WHERE b.datum = '2018-02-10';

4:
SELECT f.name
FROM flughafen f, flug
WHERE f.iata_code = flug.ende
AND flug.start = 'LHR';

5:
SELECT SUM(b.preis) AS "Ausgaben Herr Roth"
FROM buchung b, passagier p
WHERE b.kundennr = p.kundennr
AND p.nachname = 'Roth'
AND p.vorname = 'Michael';

6:
SELECT COUNT(b.buchungsnr) AS "Anzahl Tickets", p.nachname, p.vorname
FROM passagier p, buchung b
WHERE p.kundennr = b.kundennr
GROUP BY b.kundennr, p.nachname, p.vorname
ORDER BY COUNT(b.buchungsnr) DESC; 

7:
SELECT flug.flugnr, COUNT(abflug.flugnr) AS "Anzahl"
FROM flug, abflug
WHERE flug.flugnr = abflug.flugnr
GROUP BY flug.flugnr
ORDER BY COUNT(abflug.flugnr) DESC;

8:
SELECT DISTINCT flughafen.iata_code
FROM flughafen, flug
WHERE flughafen.iata_code NOT IN (SELECT flug.ende FROM flug);

9:
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

10:
WITH semi_flights AS (
                SELECT a.datum, a.flugnr, flug.start, flug.ende
                FROM flug, abflug a
                WHERE flug.flugnr = a.flugnr
                AND flug.start = 'LHR'
                AND flug.ende = 'PEK')


SELECT a.datum AS "Start-Datum", a.flugnr, flug.start, semi_flights.start AS "Zwischenstopp",
       semi_flights.datum AS "Zwischenstopp-Datum",
       semi_flights.flugnr AS "Zwischenstopp-FlugNr",  semi_flights.ende
FROM abflug a, flug, semi_flights
WHERE a.flugnr = flug.flugnr
AND flug.start = 'FRA'
AND a.datum = '2018-03-10'
AND flug.ende = 'LHR'
AND flug.ende = semi_flights.start;


11:
SELECT SUM(f.sitzplaetze) AS "Gesamtanzahl moegliche Passagiere"
FROM abflug a, flugzeug f, flug
WHERE a.kennzeichen = f.kennzeichen
AND a.flugnr = flug.flugnr
AND a.datum = '2018-02-10'
AND flug.start = 'FRA';


12:
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


13:
SELECT f.typ, SUM(f.sitzplaetze) AS "Anzahl-Passagiere"
FROM abflug a, flugzeug f
WHERE a.kennzeichen = f.kennzeichen
GROUP BY f.typ
ORDER BY SUM(f.sitzplaetze) DESC;


14:
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


