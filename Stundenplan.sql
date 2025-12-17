USE BZT_Stundenplan;
GO

-- 1) Erst Kind-Tabelle droppen, dann Eltern-Tabellen
IF OBJECT_ID('dbo.StundenplanEintraege', 'U') IS NOT NULL DROP TABLE dbo.StundenplanEintraege;
IF OBJECT_ID('dbo.Schulzimmer', 'U') IS NOT NULL DROP TABLE dbo.Schulzimmer;
IF OBJECT_ID('dbo.Lehrer', 'U') IS NOT NULL DROP TABLE dbo.Lehrer;
IF OBJECT_ID('dbo.Klassen', 'U') IS NOT NULL DROP TABLE dbo.Klassen;
GO

-- 2) Tabellen neu erstellen (normalisiert)
CREATE TABLE dbo.Klassen (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dbo.Lehrer (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.Schulzimmer (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Bezeichnung NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.StundenplanEintraege (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    KlasseId INT NOT NULL,
    Datum DATE NOT NULL,
    Uhrzeit TIME(0) NOT NULL,
    LehrerId INT NOT NULL,
    SchulzimmerId INT NOT NULL,

    CONSTRAINT FK_Stundenplan_Klassen FOREIGN KEY (KlasseId) REFERENCES dbo.Klassen(Id),
    CONSTRAINT FK_Stundenplan_Lehrer FOREIGN KEY (LehrerId) REFERENCES dbo.Lehrer(Id),
    CONSTRAINT FK_Stundenplan_Schulzimmer FOREIGN KEY (SchulzimmerId) REFERENCES dbo.Schulzimmer(Id)
);
GO

CREATE UNIQUE INDEX UX_Stundenplan_Klasse_Datum_Uhrzeit
ON dbo.StundenplanEintraege (KlasseId, Datum, Uhrzeit);
GO

-- 3) Testdaten NUR wenn Tabellen leer sind (kein Duplicate)
IF NOT EXISTS (SELECT 1 FROM dbo.Klassen)
    INSERT INTO dbo.Klassen (Code) VALUES ('INF22'), ('INF23');

IF NOT EXISTS (SELECT 1 FROM dbo.Lehrer)
    INSERT INTO dbo.Lehrer (Name) VALUES ('Müller'), ('Meier');

IF NOT EXISTS (SELECT 1 FROM dbo.Schulzimmer)
    INSERT INTO dbo.Schulzimmer (Bezeichnung) VALUES ('B101'), ('C202');

IF NOT EXISTS (SELECT 1 FROM dbo.StundenplanEintraege)
    INSERT INTO dbo.StundenplanEintraege (KlasseId, Datum, Uhrzeit, LehrerId, SchulzimmerId)
    VALUES
    (1, '2025-12-18', '08:00', 1, 1),
    (1, '2025-12-18', '10:00', 2, 2);
GO
