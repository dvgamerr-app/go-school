-- +goose Up
-- +goose StatementBegin
CREATE SCHEMA school;
CREATE TYPE school.permissionItem AS ENUM (
  'user',
  'admin'
);

CREATE TABLE school.university (
  "id" serial PRIMARY KEY,
  "name" varchar,
  "schedule_levelup" TIMESTAMP WITH TIME ZONE
);

CREATE TABLE school.user_profressor (
  "id" bigint,
  "university_id" bigint,
  "national_id" varchar NOT NULL,
  "password" varchar,
  "en_name" varchar NOT NULL,
  "en_surename" varchar NOT NULL,
  "th_name" varchar,
  "th_surename" varchar,
  "permission" school.permissionItem DEFAULT 'user',
  "registered" TIMESTAMP WITH TIME ZONE NOT NULL,
  "resigned" TIMESTAMP WITH TIME ZONE DEFAULT null,
  "created" TIMESTAMP WITH TIME ZONE DEFAULT 'now()',
  PRIMARY KEY ("id")
);

CREATE TABLE school.user_collegian (
  "id" bigint,
  "university_id" bigint,
  "code" varchar NOT NULL,
  "national_id" varchar NOT NULL,
  "password" varchar,
  "en_name" varchar NOT NULL,
  "en_surename" varchar NOT NULL,
  "th_name" varchar,
  "th_surename" varchar,
  "permission" school.permissionItem DEFAULT 'user',
  "registered" TIMESTAMP WITH TIME ZONE NOT NULL,
  "resigned" TIMESTAMP WITH TIME ZONE DEFAULT null,
  "graduation" TIMESTAMP WITH TIME ZONE DEFAULT null,
  "created" TIMESTAMP WITH TIME ZONE DEFAULT 'now()',
  PRIMARY KEY ("id")
);

CREATE TABLE school.lesson (
  "id" bigint PRIMARY KEY,
  "profressor_id" bigint,
  "subject_code" varchar,
  "grade_level" smallint,
  "label" varchar
);

CREATE TABLE school.subject (
  "code" varchar PRIMARY KEY NOT NULL,
  "label" varchar,
  "credit" bigint
);

CREATE TABLE school.grade (
  "level" smallint PRIMARY KEY,
  "label" varchar NOT NULL,
  "minimum_credit" bigint
);

CREATE TABLE school.classroom (
  "id" bigint PRIMARY KEY,
  "collegian_id" bigint,
  "grade_level" smallint,
  "label" varchar NOT NULL,
  "year" smallint,
  "no" smallint
);

CREATE TABLE school.classroom_timetable (
  "classroom_id" bigint,
  "lesson_id" bigint,
  "time" smallint,
  "minutes" smallint,
  PRIMARY KEY ("classroom_id", "lesson_id")
);

CREATE TABLE school.exam (
  "id" bigint PRIMARY KEY,
  "label" varchar NOT NULL,
  "description" varchar,
  "score" smallint DEFAULT 10
);

ALTER TABLE "school"."user_collegian" ADD FOREIGN KEY ("university_id") REFERENCES "school"."university" ("id");
ALTER TABLE "school"."user_profressor" ADD FOREIGN KEY ("university_id") REFERENCES "school"."university" ("id");

ALTER TABLE "school"."classroom" ADD FOREIGN KEY ("collegian_id") REFERENCES "school"."user_collegian" ("id");
ALTER TABLE "school"."classroom" ADD FOREIGN KEY ("grade_level") REFERENCES "school"."grade" ("level");

ALTER TABLE "school"."classroom_timetable" ADD FOREIGN KEY ("classroom_id") REFERENCES "school"."classroom" ("id");
ALTER TABLE "school"."classroom_timetable" ADD FOREIGN KEY ("lesson_id") REFERENCES "school"."lesson" ("id");

ALTER TABLE "school"."lesson" ADD FOREIGN KEY ("profressor_id") REFERENCES "school"."user_profressor" ("id");
ALTER TABLE "school"."lesson" ADD FOREIGN KEY ("subject_code") REFERENCES "school"."subject" ("code");
ALTER TABLE "school"."lesson" ADD FOREIGN KEY ("grade_level") REFERENCES "school"."grade" ("level");

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

DROP TABLE school.lesson;
DROP TABLE school.subject;
DROP TABLE school.grade;
DROP TABLE school.user_profressor;
DROP TABLE school.user_collegian;
DROP TABLE school.university;
DROP TABLE school.classroom_timetable;
DROP TABLE school.classroom;
DROP TABLE school.exam;

DROP TYPE school.permissionItem;
DROP SCHEMA school;

-- +goose StatementEnd
