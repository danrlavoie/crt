CREATE TABLE IF NOT EXISTS "file" (
	"id" INTEGER NOT NULL UNIQUE,
	"filename" VARCHAR NOT NULL,
	"filepath" VARCHAR NOT NULL UNIQUE,
	"runtimeminutes" INTEGER,
	"mediaid" INTEGER UNIQUE,
	"maybedeleted" BOOLEAN,
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
	"primaryTitle" VARCHAR,
	"synopsis" TEXT,
	"rating" NUMERIC,
	"studioid" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("id") REFERENCES "file"("mediaid")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "media_index_0"
ON "media" ("formatid", "studioid");
CREATE TABLE IF NOT EXISTS "episode" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER,
	"parentmediaid" INTEGER,
	"seasonnum" INTEGER,
	"episodenum" INTEGER,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "episode_index_0"
ON "episode" ("mediaid", "parentmediaid");
CREATE TABLE IF NOT EXISTS "mediarelation" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaidorig" INTEGER,
	"mediaidnew" INTEGER,
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
	"name" VARCHAR,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "mediagenre" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER,
	"genreid" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("genreid") REFERENCES "genre"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "mediagenre_index_0"
ON "mediagenre" ("mediaid", "genreid");
CREATE TABLE IF NOT EXISTS "contentwarningrating" (
	"id" INTEGER NOT NULL UNIQUE,
	"contentrating" VARCHAR,
	"isadult" BOOLEAN,
	"mediaid" INTEGER,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "contentwarningrating_index_0"
ON "contentwarningrating" ("mediaid");
CREATE TABLE IF NOT EXISTS "cast" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER,
	"personid" INTEGER,
	"role" VARCHAR,
	PRIMARY KEY("id"),
	FOREIGN KEY ("personid") REFERENCES "person"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "cast_index_0"
ON "cast" ("mediaid", "personid");
CREATE TABLE IF NOT EXISTS "crew" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER,
	"personid" INTEGER,
	"crewjobid" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("crewjobid") REFERENCES "crewjob"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "crew_index_0"
ON "crew" ("mediaid", "personid", "crewjobid");
CREATE TABLE IF NOT EXISTS "productioncompany" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR,
	"description" TEXT,
	"homepage" VARCHAR,
	"parentcompanyid" INTEGER,
	"origincountry" VARCHAR,
	"headquarters" VARCHAR,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "awardinstance" (
	"id" INTEGER NOT NULL UNIQUE,
	"mediaid" INTEGER,
	"personid" INTEGER,
	"awardid" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("mediaid") REFERENCES "media"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "awardinstance_index_0"
ON "awardinstance" ("mediaid", "personid", "awardid");
CREATE TABLE IF NOT EXISTS "person" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR,
	"birthdate" DATE,
	"deathdate" DATE,
	"genderid" INTEGER,
	"homepage" VARCHAR,
	"biography" TEXT,
	"birthplace" VARCHAR,
	PRIMARY KEY("id")	
);

CREATE INDEX IF NOT EXISTS "person_index_0"
ON "person" ("fullname");
CREATE TABLE IF NOT EXISTS "crewjob" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR,
	"description" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "award" (
	"id" INTEGER NOT NULL UNIQUE,
	"committeeid" INTEGER,
	"name" VARCHAR,
	"description" TEXT,
	PRIMARY KEY("id"),
	FOREIGN KEY ("committeeid") REFERENCES "committee"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "award_index_0"
ON "award" ("committeeid");
CREATE TABLE IF NOT EXISTS "committee" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR,
	"description" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "format" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" VARCHAR,
	"description" VARCHAR,
	PRIMARY KEY("id"),
	FOREIGN KEY ("id") REFERENCES "media"("formatid")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "network" (
	"id" INTEGER NOT NULL UNIQUE,
	"tmdb_id" INTEGER,
	"name" VARCHAR,
	"headquarters" VARCHAR,
	"homepage" VARCHAR,
	"origincountry" VARCHAR,
	PRIMARY KEY("id")	
);
