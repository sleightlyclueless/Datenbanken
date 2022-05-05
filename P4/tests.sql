select cmdBreak();

/* 1.1. Test getFreeSeats(varchar(60), date) function */
select getFreeSeats('LH-200', '2018-01-10');
select cmdBreak();

/* 1.2. Test maintenance(varchar(60)) */
select maintenance('D-ABCA');
select maintenance('D-ABCA'); /* double to check same day */
select maintenance('D-ABCC'); /* also another plane */
select * from wartung;
select cmdBreak();

/* 1.3. test allPassenger(); */
select allPassenger();
select cmdBreak();

/* 2.1 test bonusmeilen */
SELECT bonusmeilenkonto AS Bonusmeilen_INGE_pre_buchung FROM passagier WHERE kundennr = 2;
INSERT INTO buchung (kennzeichen, flugnr, datum, kundennr, preis, buchungsdatum, sitzklasse)
VALUES ('D-ABCA', 'LH-200', '2018-01-10', 2, 105.00, '2018-01-10', DEFAULT);

/* 2.1 check bonusmeilen again */
SELECT bonusmeilenkonto AS Bonusmeilen_INGE_post_buchung FROM passagier WHERE kundennr = 2;

/* also check 999 price constraint */
INSERT INTO buchung (kennzeichen, flugnr, datum, kundennr, preis, buchungsdatum, sitzklasse)
VALUES ('D-ABCA', 'LH-200', '2018-01-10', 2, 1050.00, '2018-01-10', DEFAULT);

/* now overfill flight */
INSERT INTO buchung (kennzeichen, flugnr, datum, kundennr, preis, buchungsdatum, sitzklasse)
VALUES
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 6, 150.00, '2018-01-10', 2),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 150.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 3, 150.00, '2018-01-10', 2),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT); /* no free seats left! */

SELECT bonusmeilenkonto AS Bonusmeilen_INGE_post_buchungen FROM passagier WHERE kundennr = 2;