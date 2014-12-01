
DROP TABLE IF EXISTS Heroes CASCADE;
DROP TABLE IF EXISTS Abilities CASCADE;
DROP TABLE IF EXISTS Players CASCADE;
DROP TABLE IF EXISTS PlaysAs CASCADE;
DROP TABLE IF EXISTS Inventory CASCADE;
DROP TABLE IF EXISTS ItemsOwned CASCADE;


-- Heroes -- 
CREATE TABLE Heroes (
  HeroName			text not null,
  Class				text not null,
  numAbilities			int,
  primary key(HeroName)
);

-- Abilities -- 
CREATE TABLE Abilities (
  AbilityName			text not null,
  HeroName			text not null references Heroes (HeroName),
  AbilityType			text not null,
  TargetType			text,
  AgsUpgrade			boolean not null,
  MagicalPhysical		text,
  PiercesMagImmune		boolean,
  primary key(AbilityName)
);


-- Players -- 
CREATE TABLE Players (
  SteamAccount			text not null,
  DisplayName			text not null,
  RealName			text,
  SteamLevel			int not null,
  DotALevel			int,
  numWins			int,
  SoloMMR			int,
  PartyMMR			int,
  primary key(SteamAccount)
);


-- PlaysAs -- 
CREATE TABLE PlaysAs (
  SteamAccount			text not null references Players (SteamAccount),
  HeroName			text not null references Heroes (HeroName)
);


-- Inventory -- 
CREATE TABLE Inventory (
  invid				serial,
  SteamAccount 			text not null references Players (SteamAccount),
  ItemSlotsMax			int,
  numItems			int,
  primary key(invid)
);


-- ItemsOwned -- 
CREATE TABLE ItemsOwned (
  Name	 			text not null,
  invid				int references Inventory (invid),
  Qty				text not null,
  Rarity			text not null,
  Tradable			boolean not null,
  primary key(Name)
);


-- Heroes --
INSERT INTO Heroes (HeroName, Class, numAbilities)
  VALUES('Nature''s Prophet', 'Intelligence', 4),
  ('Pudge', 'Strength', 4),
  ('Mirana', 'Agility', 4),
  ('Jakiro', 'Intelligence', 4),
  ('Weaver', 'Agility', 4),
  ('Enigma', 'Intelligence', 4),
  ('Lina', 'Intelligence', 4),
  ('Lich', 'Intelligence', 4),
  ('Kunkka', 'Strength', 4),
  ('Faceless Void', 'Agility', 4);
  

-- Abilities --
INSERT INTO Abilities (AbilityName, HeroName, AbilityType, TargetType, AgsUpgrade, MagicalPhysical, PiercesMagImmune)
  VALUES('Teleportation', 'Nature''s Prophet', 'Targetable', 'Point Target', false, null, null),
  ('Tidebringer', 'Kunkka', 'Passive', null, false, 'Physical', true),
  ('Chronosphere', 'Faceless Void', 'Targetable', 'Area Point Target', true, null, true),
  ('Dismember', 'Pudge', 'Targetable', 'Unit Target', true, 'Magical', true),
  ('Liquid Fire', 'Jakiro', 'Auto-Cast', 'Unit Target', false, 'Magical', true);

-- Players --
INSERT INTO Players (SteamAccount, DisplayName, RealName, SteamLevel, DotALevel, numWins, SoloMMR, PartyMMR)
VALUES('TedAndMe', 'John Bennette', 'Mark Wahlberg', 5, 98, 415, 3650, 3550),
('C00lDud3xyz', 'LaserMan', 'John Royals', 2, 215, 980, 4150, 3780),
('SexTown69', 'Im the Boss', 'Tony Danza', 15, 190, 1251, 5120, 5504),
('CSGOnly', 'KwikScope 360', 'Will Krasten', 4, null, null, null, null);

-- Inventory -- 
INSERT INTO Inventory (SteamAccount, ItemSlotsMax, numItems)
VALUES('TedAndMe', 720, 71),
('C00lDud3xyz', 960, 747),
('SexTown69', 12000, 11999),
('CSGOnly', null, null);

-- ItemsOwned --
INSERT INTO ItemsOwned (Name, invid, Qty, Rarity, Tradable)
VALUES('Golden Doomling', 1, 1, 'Immortal', true),
('Bonehunter Skullguard', 2, 3, 'Rare', true),
('Moldering Mask of Ka', 3, 1, 'Rare', false),
('Shroud of Ka', 3, 1, 'Common', false),
('Scythe of Ka', 3, 1, 'Rare', false);

-- PlaysAs --
INSERT INTO PlaysAs (SteamAccount, HeroName)
VALUES('TedAndMe', 'Pudge'),
('TedAndMe', 'Nature''s Prophet'),
('TedAndMe', 'Faceless Void'),
('C00lDud3xyz', 'Pudge'),
('C00lDud3xyz', 'Enigma'),
('SexTown69','Kunkka');

-- VIEWS --
CREATE VIEW HeroesAndAbilities AS
SELECT h.HeroName, h.Class, h.numAbilities, 
a.AbilityName, a.AbilityType, a.TargetType, a.AgsUpgrade, a.MagicalPhysical, a.PiercesMagImmune  
FROM Heroes h
JOIN Abilities a
ON h.HeroName = a.HeroName;

SELECT * FROM HeroesAndAbilities
WHERE HeroName = 'Nature''s Prophet'
ORDER BY AbilityName ASC;

-- REPORTS --
SELECT * FROM Heroes
WHERE Class = 'Agility'
Order BY HeroName ASC;

-- STORED PROCEDURES --
CREATE or REPLACE FUNCTION tradedAllItems()
RETURNS void AS $$
begin
ALTER TABLE ItemsOwned
DROP TABLE ItemsOwned;
end;
$$ language plpgsql;

select tradeAllItems();
Fetch all from results;

-- TRIGGERS --
CREATE TRIGGER quittingDotA
after DELETE on Inventory
for each row execute procedure tradedAllItems()

-- Security --
CREATE ROLE administrator WITH LOGIN PASSWORD 'alpaca';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO administrator;

CREATE ROLE users LOGIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO users;

CREATE ROLE gabe WITH LOGIN PASSWORD 'IamGabeNewellMasterOfAll';
GRANT ALL PRIVILEGES ON ALL TABLES TO gabe;