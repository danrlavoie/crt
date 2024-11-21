CREATE TABLE IF NOT EXISTS "file" (
	"id" INTEGER NOT NULL UNIQUE,
	-- Name of the file, e.g. Top_Gun.mkv
	"filename" VARCHAR NOT NULL,
	-- Absolute filepath of the file from the perspective of the media server app
	"filepath" VARCHAR NOT NULL UNIQUE,
	-- Rounded down, runtime of the media file in minutes
	"runtimeminutes" INTEGER,
	"mediaid" INTEGER UNIQUE,
	-- Toggled on if an update occurred and this file wasn't updated, suggesting a file was maybe deleted
	"maybedeleted" BOOLEAN,
	-- Last date of update check on the file
	"updatedon" DATE,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "file_index_0"
ON "file" ("filename", "mediaid");
CREATE TABLE IF NOT EXISTS "media" (
	"id" INTEGER NOT NULL UNIQUE,
	-- movie, short, tvepisode, musicvideo, tvseries
	"formatid" INTEGER NOT NULL,
	"startyear" INTEGER NOT NULL,
	"endyear" INTEGER,
	"maintitle" VARCHAR,
	"synopsis" TEXT,
	"studioid" INTEGER,
	"tmdbid" INTEGER UNIQUE,
	"seasonnum" INTEGER,
	"episodenum" INTEGER,
	"parentmediaid" INTEGER,
	"networkid" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("id") REFERENCES "file"("mediaid")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "media_index_0"
ON "media" ("formatid", "studioid", "parentmediaid", "networkid", "tmdbid");
CREATE TABLE IF NOT EXISTS "mediarelation" (
	"id" INTEGER NOT NULL UNIQUE,
	-- The original for comparison. I.e. is New media a sequel to Orig media
	"mediaidorig" INTEGER NOT NULL,
	"mediaidnew" INTEGER NOT NULL,
	"sequel" BOOLEAN,
	"prequel" BOOLEAN,
	"remake" BOOLEAN,
	"reboot" BOOLEAN,
	"crossover" BOOLEAN,
	"spiritualsuccessor" BOOLEAN,
	"spinoff" BOOLEAN,
	"recut" BOOLEAN,
	"revival" BOOLEAN,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "mediarelation_index_0"
ON "mediarelation" ("mediaidorig", "mediaidnew");
CREATE TABLE IF NOT EXISTS "genre" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"tmdbid" INTEGER UNIQUE,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "mediagenre" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER NOT NULL,
	"genreid" INTEGER NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY ("genreid") REFERENCES "genre"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "mediagenre_index_0"
ON "mediagenre" ("mediaid", "genreid");
CREATE TABLE IF NOT EXISTS "contentwarningrating" (
	"id" INTEGER NOT NULL UNIQUE,
	"contentrating" VARCHAR NOT NULL,
	"isadult" BOOLEAN,
	"mediaid" INTEGER NOT NULL,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "contentwarningrating_index_0"
ON "contentwarningrating" ("mediaid");
CREATE TABLE IF NOT EXISTS "cast" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER NOT NULL,
	"personid" INTEGER NOT NULL,
	"role" VARCHAR NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY ("personid") REFERENCES "person"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "cast_index_0"
ON "cast" ("mediaid", "personid");
CREATE TABLE IF NOT EXISTS "crew" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER NOT NULL,
	"personid" INTEGER NOT NULL,
	"crewjobid" INTEGER NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY ("crewjobid") REFERENCES "crewjob"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "crew_index_0"
ON "crew" ("mediaid", "personid", "crewjobid");
CREATE TABLE IF NOT EXISTS "productioncompany" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"description" TEXT,
	"homepage" VARCHAR,
	"parentcompanyid" INTEGER,
	"origincountry" VARCHAR,
	"headquarters" VARCHAR,
	"tmdbid" INTEGER UNIQUE,
	PRIMARY KEY("id"),
	FOREIGN KEY ("parentcompanyid") REFERENCES "productioncompany"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "awardinstance" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER NOT NULL,
	"personid" INTEGER,
	"awardid" INTEGER NOT NULL,
	"year" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("mediaid") REFERENCES "media"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "awardinstance_index_0"
ON "awardinstance" ("mediaid", "personid", "awardid");
CREATE TABLE IF NOT EXISTS "person" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"birthdate" DATE,
	"deathdate" DATE,
	"genderid" INTEGER,
	"homepage" VARCHAR,
	"biography" TEXT,
	"birthplace" VARCHAR,
	"tmdbid" INTEGER UNIQUE,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "person_index_0"
ON "person" ("fullname");
CREATE TABLE IF NOT EXISTS "crewjob" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"description" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "award" (
	"id" INTEGER NOT NULL UNIQUE,
	"committeeid" INTEGER NOT NULL,
	"name" VARCHAR NOT NULL,
	"description" TEXT,
	PRIMARY KEY("id"),
	FOREIGN KEY ("committeeid") REFERENCES "committee"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "award_index_0"
ON "award" ("committeeid");
CREATE TABLE IF NOT EXISTS "committee" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"description" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "format" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR NOT NULL,
	"description" VARCHAR,
	PRIMARY KEY("id"),
	FOREIGN KEY ("id") REFERENCES "media"("formatid")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "network" (
	"id" INTEGER NOT NULL UNIQUE,
	"tmdbid" INTEGER UNIQUE,
	"name" VARCHAR NOT NULL,
	"headquarters" VARCHAR,
	"homepage" VARCHAR,
	"origincountry" VARCHAR,
	PRIMARY KEY("id")	
);
