ALTER TABLE buchung
/* Constraint name C_Preis for check price and possible removal */
ADD CONSTRAINT c_preis CHECK (preis <= 999);
/* CHECK: UPDATE buchung SET preis = 1000000 WHERE buchungsnr = 1; */

ALTER TABLE flugzeug
ADD CONSTRAINT keine_leeren_flugzeuge CHECK (sitzplaetze >= 0);
/* CHECK: INSERT INTO flugzeug VALUES ('D-BBBB', 'A-4444', -100); */
/* SELECT * FROM FLUGZEUG */

ALTER TABLE flugzeug
ALTER COLUMN sitzplaetze set default 100;
/* CHECK: INSERT INTO flugzeug VALUES ('D-AAAA', 'A-3333', DEFAULT); */
/* SELECT * FROM FLUGZEUG */