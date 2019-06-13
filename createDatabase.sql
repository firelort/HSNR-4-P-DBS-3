-- Altes Löschen
DROP VIEW IF EXISTS preisliste;
DROP TRIGGER IF EXISTS produktTrigger ON produkt;
DROP FUNCTION IF EXISTS change;
DROP TABLE preishist;
DROP TABLE produkt;
DROP TABLE hersteller;

-- Tabellen anlegen

CREATE TABLE hersteller (
	hnr 		varchar(4) PRIMARY KEY,
	name 		varchar(30)
);

CREATE TABLE produkt (
	pnr			varchar(4) PRIMARY KEY,
	name  		varchar(30),
	hnr			varchar(4) REFERENCES hersteller(hnr),
	preis		numeric(8,2),
	gueltigab	date
);

CREATE TABLE preishist(
	phnr		SERIAL PRIMARY KEY,
	pnr		varchar(4) REFERENCES produkt(pnr),
	preis		numeric(8,2),
	gueltigab	date,
	gueltigbis	date NOT NULL
);

-- TRIGGER

CREATE FUNCTION change() RETURNS trigger AS $change$
DECLARE
	letzteaenderung DATE;
BEGIN
	-- LETZTE ÄNDERUNG SELEKTIEREN
	SELECT gueltigbis INTO letzteaenderung FROM preishist WHERE pnr = OLD.pnr ORDER BY phnr DESC limit 1; --id or gueltigbis macht kein unterschied
	IF letzteaenderung IS NULL THEN
		letzteaenderung := TO_DATE('01.01.1970', 'DD.MM.YYYY'); --letzteaenderung := old.gueltigab;
	END IF;
	
	IF NEW.gueltigab < letzteaenderung THEN 
		RAISE EXCEPTION 'gueltigab ist älter als das jüngste Änderungsdatum';
	END IF;	
	
	IF NEW.gueltigab > OLD.gueltigab AND NEW.preis != OLD.preis THEN -- Historientabelle nur dann wenn NEW.gueltigab > OLD.gueltigab, sonst kann Inkonsitenz auftretten
		INSERT INTO preishist(pnr, preis, gueltigab, gueltigbis) VALUES (OLD.pnr, OLD.preis, OLD.gueltigab, NEW.gueltigab - 1);
	END IF;
	
	RETURN NEW;
END;
$change$ LANGUAGE plpgsql;


CREATE TRIGGER produktTrigger BEFORE UPDATE ON produkt FOR EACH ROW EXECUTE PROCEDURE change();

-- CREATE VIEW

CREATE VIEW preisliste AS
SELECT h.pnr as pnr, h.gueltigab as gueltigab, h.gueltigbis as gueltigbis, h.preis as preis FROM preishist AS h
UNION
SELECT p.pnr as pnr, p.gueltigab as gueltigab, TO_DATE('31.12.9999', 'DD.MM.YYYY') as gueltigbis, p.preis as preis FROM produkt AS p
ORDER BY gueltigab DESC;

-- SELECT preis from preisliste where pnr = 'p1' and TO_DATE('01.04.2019','DD.MM.YYYY') BETWEEN gueltigab AND gueltigbis ORDER BY preis DESC limit 1;

-- Testvalues
	-- INSERT HERSTELLER
	INSERT INTO hersteller(hnr, name) VALUES ('h1', 'SAP');
	INSERT INTO hersteller(hnr, name) VALUES ('h2', 'HP');
	INSERT INTO hersteller(hnr, name) VALUES ('h3', 'Dell');
	
	-- INSERT PRODUCTS
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p1', 'S/4HANA', 'h1', '1999.99', TO_DATE('01.01.2019','DD.MM.YYYY'));
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p2', 'Black and White Laser Printer', 'h2', '350.00', TO_DATE('01.01.2019','DD.MM.YYYY'));
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p3', 'Laptop 3000', 'h3', '799.99', TO_DATE('01.01.2019','DD.MM.YYYY'));
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p4', 'ERP', 'h1', '3999.99', TO_DATE('01.01.2019','DD.MM.YYYY'));
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p5', 'Business Ink Printer', 'h2', '799.99', TO_DATE('01.01.2019','DD.MM.YYYY'));
	INSERT INTO produkt(pnr, name, hnr, preis, gueltigab) VALUES ('p6', 'Laptop 2000', 'h3', '599.99', TO_DATE('01.01.2019','DD.MM.YYYY'));

-- UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY'), preis = '1.99' where pnr = 'p1';
-- UPDATE produkt SET gueltigab = TO_DATE('01.02.2019','DD.MM.YYYY') where pnr = 'p1';
-- UPDATE produkt SET preis = '1.99' where pnr = 'p1';
