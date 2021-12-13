-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------


-- S6.1.
--
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoering combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie

-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
--     CREATE OR REPLACE VIEW personeel AS
-- 	     SELECT mnr, voorl, naam as medewerker, afd, functie
--       FROM medewerkers;
CREATE OR REPLACE VIEW deelnemers AS
SELECT i.cursist, i.cursus, i.begindatum, u.docent, u.locatie
from inschrijvingen i, uitvoeringen u
WHERE i.cursus = u.cursus AND i.begindatum = u.begindatum;


CREATE OR REPLACE VIEW personeel AS
  SELECT mnr, voorl, naam as medewerker, afd, functie
  FROM medewerkers;

SELECT d.cursist, p.medewerker as cursist_naam, d.cursus, d.begindatum, d.docent FROM deelnemers d, personeel p
WHERE d.cursist = p.mnr;


-- 3. Is de view "deelnemers" updatable ? Waarom ?
  -- Nee, de view kan geen  "UPDATES" uitvoeren, dus de weergave bevat geen INSERT, UPDATE of DELETE.
  --Daarom is de deelnemers view een materialised view

-- S6.2.
--
-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen: 
--      code, omschrijving en type uit de tabel curssussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt.

-- 2. Maak een tweede view met de naam "daguitvoeringen". 
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcurssussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt
-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP view <viewnaam> CASCADE en bij DROP view <viewnaam> RESTRICT
CREATE OR REPLACE VIEW dagcursussen AS
SELECT code, omschrijving, type
from cursussen
WHERE lengte = 1;

SELECT * from dagcursussen;


CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT *
from uitvoeringen, dagcursussen
WHERE cursus IN (dagcursussen.code);

SELECT * FROM daguitvoeringen;

DROP VIEW dagcursussen CASCADE;
--Met cascade verwijdert u alles wat (in dit geval) afhangt van de dagcursussen view,dus ook daguitvoeringen
--want de dagutivoeringen gebruikt de dagcursussen view en werkt niet als de dagcursussen view er niet is
--Dus deze dropdown-code verwijdert dagcursussen en daguitvoeringen.

DROP view dagcursussen RESTRICT;
-- Met restrict verwijder je juist niet (in dit geval) de dagcursussen view, omdat er iets afhankelijk van is.
-- In dit geval wordt dus de dagcursussen view niet verwijderd omdat de daguitvoeringen er afhankelijk van is.
-- Dus deze drop code verwijdert niks.

-- Dus als je met restrict iets wilt verwijderen moet het iets zijn waar niks afhankelijk van is, zoals de daguitvoeringen view.

DROP view daguitvoeringen RESTRICT;
-- Deze drop verwijdert dus alleen de daguitvoeringen.