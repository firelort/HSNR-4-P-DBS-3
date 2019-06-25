INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p1', 'Kaffee', 'h1', '10', TO_DATE('01.01.2000','DD.MM.YYYY'));

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET preis='20.00' where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2002','DD.MM.YYYY') where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2001','DD.MM.YYYY') where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2003','DD.MM.YYYY'), preis='30.00' where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2002','DD.MM.YYYY') where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2000','DD.MM.YYYY') where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

UPDATE produkt SET gueltigab = TO_DATE('01.01.2004','DD.MM.YYYY'), preis = '40.00' where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM preishist;

SELECT pnr, preis from preisliste where pnr = 'p1' and TO_DATE('01.01.2005','DD.MM.YYYY') >= gueltigab ORDER BY gueltigab DESC limit 1;
SELECT pnr, preis from preisliste where pnr = 'p1' and TO_DATE('01.01.2003','DD.MM.YYYY') >= gueltigab ORDER BY gueltigab DESC limit 1;
SELECT pnr, preis from preisliste where pnr = 'p1' and TO_DATE('30.01.2001','DD.MM.YYYY') >= gueltigab ORDER BY gueltigab DESC limit 1;
SELECT pnr, preis from preisliste where pnr = 'p1' and TO_DATE('01.01.1999','DD.MM.YYYY') >= gueltigab ORDER BY gueltigab DESC limit 1;
