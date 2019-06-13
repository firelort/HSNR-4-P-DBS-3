---- Funktioniert ohne Änderung in der Historie Tabelle
UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY') where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.03.2019','DD.MM.YYYY') where pnr = 'p2';
UPDATE produkt SET gueltigab = TO_DATE('01.03.2019','DD.MM.YYYY') where pnr = 'p3';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;

---- Funktioniert, da NEW.gueltigab > letzteanederung (1970) ist
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p2';
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p3';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;

---- Sollte nicht funktionieren, da gueltigab < letzteanederung
SELECT 'Hier sollten 3 Fehler auftretten....' as " ";
UPDATE produkt SET gueltigab = TO_DATE('01.01.1969','DD.MM.YYYY') where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.01.1969','DD.MM.YYYY') where pnr = 'p2';
UPDATE produkt SET gueltigab = TO_DATE('01.01.1969','DD.MM.YYYY') where pnr = 'p3';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;

-- Preisänderung wird in die Historie übernommen
UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY'), preis='100.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY'), preis='100.00' where pnr = 'p2';
UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY'), preis='100.00' where pnr = 'p3';
UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY'), preis='100.00' where pnr = 'p4';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Preishistorie Tabelle' as " ";
SELECT * FROM preishist;
SELECT 'Preisliste View' as " ";
SELECT * FROM preisliste;

-- Preisänderung wird nicht in die Historie übernommen
UPDATE produkt SET preis = '999.99' where pnr = 'p1';
UPDATE produkt SET preis = '999.99' where pnr = 'p2';
UPDATE produkt SET preis = '999.99' where pnr = 'p3';
UPDATE produkt SET preis = '999.99' where pnr = 'p4';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Historie Tabelle' as " ";
SELECT * FROM produkt;

---- Sollte nicht funktionieren, da gueltigab < letzteanederung
SELECT 'Hier sollten 3 Fehler auftretten....' as " ";
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p2';
UPDATE produkt SET gueltigab = TO_DATE('01.01.2019','DD.MM.YYYY') where pnr = 'p3';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;

-- Preisänderung wird in die Historie übernommen
UPDATE produkt SET gueltigab = TO_DATE('01.03.2019','DD.MM.YYYY'), preis='300.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.04.2019','DD.MM.YYYY'), preis='400.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.05.2019','DD.MM.YYYY'), preis='500.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('01.06.2019','DD.MM.YYYY'), preis='600.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('07.06.2019','DD.MM.YYYY'), preis='625.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('14.06.2019','DD.MM.YYYY'), preis='650.00' where pnr = 'p1';
UPDATE produkt SET gueltigab = TO_DATE('21.06.2019','DD.MM.YYYY'), preis='675.00' where pnr = 'p1';

SELECT 'Produkt Tabelle' as " ";
SELECT * FROM produkt;
SELECT 'Preishistorie Tabelle' as " ";
SELECT * FROM preishist;
SELECT 'Preisliste View' as " ";
SELECT * FROM preisliste;

-- Preis eines Produktes herausfinden
SELECT 'Preis herausfinden' AS " ";
SELECT pnr, preis from preisliste where pnr = 'p1' and TO_DATE('01.02.2019','DD.MM.YYYY') BETWEEN gueltigab AND gueltigbis;

--SELECT 'DEBUG' AS " ";
--SELECT pnr, preis, gueltigab, gueltigbis from preisliste where pnr = 'p1' ORDER BY gueltigbis DESC;
