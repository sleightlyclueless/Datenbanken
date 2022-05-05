DELETE FROM buchung;
DELETE FROM abflug;
DELETE FROM passagier;

DELETE FROM flug;
DELETE FROM wartung;

DELETE FROM flugzeug;
DELETE FROM flughafen;


INSERT INTO flughafen
VALUES
('ATL', 'Hartsfield-Jackson International Airport Atlanta', -84.428056, 33.636667),
('PEK', 'Beijing Capital International Airport', 116.5975, 40.0725),
('DXB', 'Dubai International Airport', 55.364444, 25.252778),
('ORD', 'Chicago O Hare International Airport', -87.904722, 41.978611),
('HND', 'Tokyo International Airport', 139.781111, 35.553333),
('LHR', 'Heathrow Airport', -0.461389, 51.4775),
('LAX', 'Los Angeles International Airport', -118.408056, 33.9425),
('HKG', 'Hong Kong International Airport', 113.914444, 22.308889),
('CDG', 'Paris Charles de Gaulle Airport', 2.547778, 49.009722),
('DFW', 'Dallas International Airport', -97.038056, 32.896944),
('IST', 'Istanbul AtatÃ¼rk Airport', 28.814167, 40.976111),
('FRA', 'Frankfurt Airport', 8.570556, 50.033333),
('WDH', 'Hosea Kutako International Airport', 17.47095, -22.479894);


INSERT INTO flugzeug
VALUES
('D-ABBB', 'Airbus A330-300', 236),
('D-ABBC', 'Airbus A330-300', 240),
('D-ABBD', 'Airbus A330-300', 221),
('D-ABBE', 'Airbus A330-300', 231),
('D-ABBF', 'Airbus A340-300', 280),
('D-ABBG', 'Airbus A340-300', 271),
('D-ABBH', 'Airbus A340-300', 243),
('D-ABBI', 'Airbus A340-600', 266),
('D-ABBK', 'Airbus A340-600', 293),
('D-ABBL', 'Airbus A380-800', 509),
('D-ABBM', 'Airbus A350-900', 293),
('D-ABBO', 'Airbus A350-900', 297),
('D-ABBP', 'Airbus A350-900', 288),
('D-ABBQ', 'Airbus A350-200', 288),
('D-ABBR', 'Airbus A320-200', 168),
('D-ABBS', 'Airbus A320-200', 168),
('D-ABBT', 'Airbus A320-200', 170),
('D-ABBU', 'Airbus A320-200', 142),
('D-ABBW', 'Boeing B747-8', 364),
('D-ABBX', 'Boeing B747-8', 364),
('D-ABBY', 'Boeing B747-8', 364),
('D-ABBZ', 'Boeing B747-8', 364),
('D-ABCA', 'Boeing B737-700', 20), /* NOTE: Changed to 20 to reach seat limits faster in tests */
('D-ABCC', 'Boeing B737-700', 88);


INSERT INTO flug
VALUES
('LH-100', 'FRA', 'ATL'),
('LH-102', 'FRA', 'DXB'),
('LH-103', 'FRA', 'ORD'),
('LH-104', 'FRA', 'HND'),
('LH-105', 'FRA', 'LHR'),
('LH-106', 'FRA', 'LAX'),
('LH-107', 'FRA', 'HKG'),
('LH-108', 'FRA', 'CDG'),
('LH-109', 'FRA', 'DFW'),
('LH-110', 'FRA', 'IST'),
('LH-200', 'LHR', 'ATL'),
('LH-201', 'LHR', 'PEK'),
('LH-202', 'LHR', 'DXB'),
('LH-203', 'LHR', 'ORD'),
('LH-204', 'LHR', 'FRA');


INSERT INTO abflug
VALUES
('2018-01-10', 'D-ABBL', 'LH-100'),
('2018-02-10', 'D-ABBL', 'LH-100'),
('2018-03-10', 'D-ABBL', 'LH-100'),
('2018-04-10', 'D-ABBL', 'LH-100'),
('2018-05-10', 'D-ABBL', 'LH-100'),
('2018-06-10', 'D-ABBL', 'LH-100'),
('2018-07-10', 'D-ABBK', 'LH-100'),
('2018-08-10', 'D-ABBK', 'LH-100'),
('2018-02-10', 'D-ABBB', 'LH-102'),
('2018-04-10', 'D-ABBB', 'LH-102'),
('2018-06-10', 'D-ABBB', 'LH-102'),
('2018-09-10', 'D-ABBB', 'LH-103'),
('2018-03-10', 'D-ABBB', 'LH-104'),
('2018-05-10', 'D-ABBB', 'LH-104'),
('2018-07-10', 'D-ABBB', 'LH-104'),
('2018-09-10', 'D-ABBB', 'LH-104'),
('2018-01-10', 'D-ABBB', 'LH-105'),
('2018-02-10', 'D-ABBB', 'LH-105'),
('2018-03-10', 'D-ABBB', 'LH-105'),
('2018-01-10', 'D-ABCA', 'LH-200'),
('2018-02-10', 'D-ABCA', 'LH-200'),
('2018-03-10', 'D-ABCA', 'LH-201'),
('2018-05-10', 'D-ABBR', 'LH-201'),
('2018-05-10', 'D-ABCA', 'LH-202'),
('2018-09-10', 'D-ABCA', 'LH-202'),
('2018-04-10', 'D-ABCA', 'LH-203'),
('2018-05-10', 'D-ABCA', 'LH-203'),
('2018-06-10', 'D-ABCC', 'LH-203'),
('2018-01-10', 'D-ABBF', 'LH-204'),
('2018-03-10', 'D-ABBI', 'LH-204'),
('2018-08-10', 'D-ABBM', 'LH-204');

INSERT INTO passagier (vorname, nachname)
VALUES
('Michael', 'Roth'),
('Inge', 'Schestag'),
('Uta', 'Stoerl'),
('Peter', 'Muth'),
('Thorsten', 'Peter'),
('Stefan', 'Ruehl');

INSERT INTO buchung (kennzeichen, flugnr, datum, kundennr, preis, buchungsdatum, sitzklasse)
VALUES
('D-ABBL', 'LH-100', '2018-01-10', 1, 100.00, '2018-01-10', DEFAULT),
('D-ABBB', 'LH-102', '2018-04-10', 5, 100.00, '2018-04-10', DEFAULT),
('D-ABBB', 'LH-104', '2018-07-10', 6, 100.00, '2018-07-10', 2),
('D-ABBL', 'LH-100', '2018-02-10', 1, 100.00, '2018-02-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-01-10', 2, 100.00, '2018-01-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-01-10', 3, 100.00, '2018-01-10', DEFAULT),
('D-ABBB', 'LH-105', '2018-01-10', 1, 105.00, '2018-01-10', DEFAULT),
('D-ABCA', 'LH-200', '2018-01-10', 1, 200.00, '2018-01-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-02-10', 2, 105.00, '2018-02-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-03-10', 2, 100.00, '2018-03-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-04-10', 2, 100.00, '2018-04-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-05-10', 2, 100.00, '2018-05-10', DEFAULT),
('D-ABBL', 'LH-100', '2018-06-10', 2, 100.00, '2018-06-10', DEFAULT),
('D-ABBK', 'LH-100', '2018-07-10', 2, 100.00, '2018-07-10', DEFAULT),
('D-ABBK', 'LH-100', '2018-08-10', 2, 100.00, '2018-08-10', DEFAULT);