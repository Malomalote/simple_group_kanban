BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "state" (
	"state_id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("state_id")
);
CREATE TABLE IF NOT EXISTS "priority" (
	"priority_id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"priority_color"	TEXT NOT NULL,
	PRIMARY KEY("priority_id")
);
CREATE TABLE IF NOT EXISTS "rol" (
	"rol_id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("rol_id")
);
CREATE TABLE IF NOT EXISTS "team" (
	"team_id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("team_id")
);
CREATE TABLE IF NOT EXISTS "user" (
	"user_id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"rol"	TEXT NOT NULL,
	FOREIGN KEY("rol") REFERENCES "rol"("rol_id"),
	PRIMARY KEY("user_id")
);
CREATE TABLE IF NOT EXISTS "user_team" (
	"user_id"	TEXT NOT NULL,
	"team_id"	TEXT NOT NULL,
	FOREIGN KEY("team_id") REFERENCES "team"("team_id"),
	FOREIGN KEY("user_id") REFERENCES "user"("user_id")
);
CREATE TABLE IF NOT EXISTS "card" (
	"card_id"	TEXT NOT NULL UNIQUE,
	"creator"	TEXT NOT NULL,
	"user_asigned"	TEXT,
	"team_asigned"	TEXT,
	"state"	TEXT NOT NULL,
	"priority"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
	"description"	TEXT,
	"expiration_date"	TEXT,
	"comments"	TEXT,
	"card_color"	TEXT NOT NULL,
	FOREIGN KEY("user_asigned") REFERENCES "user"("user_id"),
	FOREIGN KEY("team_asigned") REFERENCES "team"("team_id"),
	FOREIGN KEY("state") REFERENCES "state"("state_id"),
	FOREIGN KEY("priority") REFERENCES "priority"("priority_id"),
	FOREIGN KEY("creator") REFERENCES "user"("user_id"),
	PRIMARY KEY("card_id")
);
COMMIT;
