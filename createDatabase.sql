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
	pnr		varchar(4) PRIMARY KEY,
	name  		varchar(30),
	hnr		varchar(4) REFERENCES hersteller(hnr),
	preis		numeric(8,2),
	gueltigab	date
);

CREATE TABLE preishist(
	phnr		SERIAL PRIMARY KEY,
	pnr		varchar(4) REFERENCES produkt(pnr),
	preis		numeric(8,2),
	gueltigab	date
);

-- TRIGGER

CREATE FUNCTION change() RETURNS trigger AS $change$
DECLARE
	letzteaenderung DATE;
BEGIN
	-- LETZTE ÄNDERUNG SELEKTIEREN
	SELECT gueltigab INTO letzteaenderung FROM preishist WHERE pnr = OLD.pnr ORDER BY gueltigab DESC limit 1; --id or gueltigbis macht kein unterschied
	IF letzteaenderung IS NULL THEN
		letzteaenderung := TO_DATE('01.01.1970', 'DD.MM.YYYY'); --letzteaenderung := old.gueltigab;
	END IF;
	
	IF NEW.gueltigab < letzteaenderung THEN 
		RAISE EXCEPTION 'gueltigab ist älter als das jüngste Änderungsdatum';
	END IF;	
	
	IF NEW.gueltigab > OLD.gueltigab AND NEW.preis != OLD.preis THEN -- Historientabelle nur dann wenn NEW.gueltigab > OLD.gueltigab, sonst kann Inkonsitenz auftretten
		INSERT INTO preishist(pnr, preis, gueltigab) VALUES (OLD.pnr, OLD.preis, OLD.gueltigab);
	END IF;
	
	RETURN NEW;
END;
$change$ LANGUAGE plpgsql;

CREATE TRIGGER produktTrigger BEFORE UPDATE ON produkt FOR EACH ROW EXECUTE PROCEDURE change();

-- CREATE VIEW

CREATE VIEW preisliste AS
SELECT h.pnr as pnr, h.gueltigab as gueltigab, h.preis as preis FROM preishist AS h
UNION
SELECT p.pnr as pnr, p.gueltigab as gueltigab, p.preis as preis FROM produkt AS p
ORDER BY gueltigab DESC;

-- Testvalues
-- INSERT HERSTELLER
INSERT INTO hersteller(hnr, name) VALUES ('h1', 'SAP');
