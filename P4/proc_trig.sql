/*0. function for gaps in cmd line*/
create or replace function cmdBreak() returns void as $$
begin raise notice '======================================'; end;
$$ language plpgsql; 


/*1. Eine Funktion **getFreeSeats**, welche eine Flugnummer und ein Datum übergeben bekommt, und die freien Plätze auf diesem Flug berechnet und zurück gibt.*/
create or replace function getFreeSeats(VARCHAR(60), DATE) returns INTEGER as $$
    declare
        _flugnr varchar(60) := $1;
        _datum date := $2;
        _seatsTotal integer;
        _seatsUsed integer;
    begin
        select flugzeug.sitzplaetze into _seatsTotal
            from flugzeug, abflug
            where _flugnr = abflug.flugnr and _datum = abflug.datum and abflug.kennzeichen = flugzeug.kennzeichen;
        select count(*) into _seatsUsed
            from buchung
            where buchung.flugnr = _flugnr;
            raise notice 'remaining free seats in flight no. %: %', _flugnr, (_seatsTotal - _seatsUsed);  
        return (_seatsTotal - _seatsUsed);
    end;
$$ language plpgsql;


/*2. Eine Funktion **maintenance**, welche als Parameter ein Flugzeugkennzeichen entgegen nimmt, und für dieses Flugzeug einen Wartungsvorgang mit Flugfreigabe für den heutigen Tag erstellt. „Heute“ bedeutet das aktuelle Datum, mit dem die Funktion aufgerufen wurde. Beachten Sie hierbei, dass Ihre Funktion mit den folgenden beiden Fällen umgehen können muss:
    - Es gibt keinen Eintrag in der Wartungstabelle, daher muss ein neuer Eintrag erstellt werden
    - Es existiert bereits ein Eintrag, unter Umständen ohne Flugfreigabe*/
create or replace function maintenance(VARCHAR(60)) returns void as $$
    declare
        _kennzeichen varchar(60) := $1;
        _today date := current_date;
        _nextNumber integer := 0;
    begin
        if not exists(select * from wartung)
            then _nextNumber := 1;
            else select max(wartungsnr) into _nextNumber from wartung;
            _nextNumber := _nextNumber + 1;
        end if;
        if exists(select * from wartung
                    where kennzeichen = _kennzeichen and wartungsdatum = _today)
        then update wartung set wartungsdatum = _today, flugfreigabe = TRUE
            where kennzeichen = _kennzeichen;
        else insert into wartung values (_nextNumber, _kennzeichen, _today, TRUE);
        end if;
    end;
$$ language plpgsql;


/*3. Eine Funktion (oder View), welche die gleiche Aufgabe erfüllt wie Aufgabe 1.12 aus dem letzten Praktikum (Ausgabe aller Passagiere inkl. aller Flugdaten). Sie dürfen hierfür auch eine Stored Procedure mit SQL schreiben.*/
create or replace function allPassenger() returns void as $$
    declare
        row1 record;
        row2 record;
    begin
        for row1 in select distinct passagier.nachname, passagier.vorname, buchung.preis, buchung.flugnr, buchung.datum, flug.ende, flug.start, flughafen.name, flughafen.iata_code
            from buchung, passagier, abflug, flug, flughafen
            where passagier.kundennr = buchung.kundennr 
                and buchung.flugnr = abflug.flugnr 
                and buchung.datum = abflug.datum 
                and buchung.kennzeichen = abflug.kennzeichen 
                and abflug.flugnr = flug.flugnr
                and flug.start = flughafen.iata_code
            order by passagier.nachname loop
            
                for row2 in select flughafen.name
                    from flughafen
                    where row1.ende = flughafen.iata_code loop
                    raise notice 'Nachname: %, Vorname: %, Preis: %, Flugnummer: %, Datum: %, IATA-Start: %, Name-Start: %, IATA-Ende: %, Name-Ende: %', row1.nachname, row1.vorname, row1.preis, row1.flugnr, row1.datum, row1.start, row1.name, row1.ende, row2.name;
    
                end loop;
        end loop;
    end;
$$ language plpgsql;



/*# 2  Entfernungsberechnung für Bonusmeilen
Es soll ein Bonusmeilen System eingeführt werden, bei denen Passagiere bei Buchung 10% der zu erwartenden Reisedistanz auf ein Konto gut geschrieben bekommen. Diese Bonusmeilen können für Flüge verwendet werden.

Beispiel:
- Ein Passagier fliegt den Flug FRA nach LAX (Entfernung 9321km) und bekommt dafür 932 Bonusmeilen gutgeschrieben.
- Der gleiche Passagier (mit 932 Bonusmeilen) bucht erneut einen Flug, diesmal von Frankfurt nach Paris (Entfernung 449km). Die Bonusmeilen reichen also aus, um diesen Flug zu bezahlen. Dem Passagier werden demnach 449km von seinen 932 Bonusmeilen abgezogen, der Flug allerdings ist kostenlos.
- Ob Sie Bonusmeilen mit Nachkommastellen erfassen bzw. ob Sie für einen kostenlosen Flug erneut Bonusmeilen vergeben, bleibt Ihnen überlassen.

Um dies umzusetzen, implementieren Sie folgendes:
1. Eine Funktion **getDistance**, welche zwei IATA-Codes als Parameter erhält und die Entfernung zwischen diesen beiden Flughäfen berechnet.*/
create or replace function getDistance(varchar(60), varchar(60)) returns float as $$
    declare
        lat1 float;
        lon1 float;
        lat2 float;
        lon2 float;
        pii float = 3.14159265358979323846;
        earthRadius float = 6371.0;
        deltaLat float;
        deltaLon float;
        dist float;

    begin
        select flughafen.breitengrad into lat1
            from flughafen
            where flughafen.iata_code = $1;
        lat1 = lat1 * (pii/180.0);
        select flughafen.laengengrad into lon1
            from flughafen
            where flughafen.iata_code = $1;
        lon1 = lon1 * (pii/180.0);
        select flughafen.breitengrad into lat2
            from flughafen
            where flughafen.iata_code = $2;
        lat2 = lat2 * (pii/180.0);
        select flughafen.laengengrad into lon2
            from flughafen
            where flughafen.iata_code = $2;
        lon2 = lon2 * (pii/180.0);

        deltaLat = (lat2 - lat1) / 2.0;
        deltaLon = (lon2 - lon1) / 2.0;

        dist = 2.0 * earthRadius * asin(sqrt((sin(deltaLat) * sin(deltaLat)) + cos(lat1) * cos(lat2) * (sin(deltaLon) * sin(deltaLon))));

        return dist;
    end;
$$ language plpgsql;


/* # 3  Trigger
Sie haben bereits ein Attribut für Bonusmeilen in Passagier bzw. Kunde aus einem früheren Praktikum. Dies können und sollen Sie verwenden, um für jeden Kunden Bonusmeilen zu speichern.

Implementieren Sie die folgenden drei Triggerfunktionen und Trigger auf die Buchungstabelle. Verwenden Sie hierfür, wenn angebracht, die Stored Procedures aus Aufgabe 1 bzw. 2:
1. Einen *before insert* Trigger. Dieser soll überprüfen, ob auf dem gewünschten Flug überhaupt noch Platz ist, und gegebenenfalls den *insert* abweisen.*/
create or replace function AseatsAvailable() returns trigger as $$
    begin
        if(select getFreeSeats(new.flugnr, new.datum)  = 0 )
            then raise exception 'Keine freien Plaetze verfuegbar!';
        else return new;
        end if;
    end;
$$ language plpgsql; 
create trigger AseatsAvailableTrigger before insert on buchung for each row execute procedure AseatsAvailable();


/* 2. Einen *before insert* Trigger welcher überprüft, ob der Flug mit Bonusmeilen anstatt mit Geld bezahlt werden kann. Falls dies der Fall ist, werden dem Passagier die Bonusmeilen entsprechend abgezogen und der Preis der Buchung wird auf 0 € gesetzt.*/ 
create or replace function checkPayment() returns trigger as $$
    declare
        calculateDist float = getDistance((select flug.start from flug where flug.flugnr = new.flugnr),(select flug.ende from flug where flug.flugnr = new.flugnr));
        miles int;
    begin
        select passagier.bonusmeilenkonto into miles from passagier where passagier.kundennr = new.kundennr;
        if(calculateDist <= miles)
            then update passagier set bonusmeilenkonto = bonusmeilenkonto - floor(calculateDist) where kundennr = new.kundennr;
            new.preis = 0;
        end if;
        return new;
    end;
$$ language plpgsql; 
create trigger checkPaymentTrigger before insert on buchung for each row execute procedure checkPayment();


/* 3. Einen *after insert* Trigger, der die Bonusmeilen für den gerade gebuchten Flug berechnet und dem Passagier gut schreibt. */
create or replace function checkBonusmeilen() returns trigger as $$
    declare
        calculateDist float = getDistance((select flug.start from flug where flug.flugnr = new.flugnr),(select flug.ende from flug where flug.flugnr = new.flugnr));
    begin
        update passagier set bonusmeilenkonto = bonusmeilenkonto + (floor(calculateDist)*0.1) where kundennr = new.kundennr;
        return new;
    end;
$$ language plpgsql;
create trigger checkBonusmeilenTrigger after insert on buchung for each row execute procedure checkBonusmeilen();