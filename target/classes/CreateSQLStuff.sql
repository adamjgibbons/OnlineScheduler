CREATE SCHEMA `FinalProject` DEFAULT CHARACTER SET utf8;

drop table if exists `companies`;
drop table if exists `people`;

CREATE TABLE people (
    person_id INTEGER AUTO_INCREMENT PRIMARY KEY
    ,person_name VARCHAR(64)  NOT NULL
 --   ,is_manager BOOLEAN NOT NULL
 --   ,desired_weekly_hours INTEGER NOT NULL
    ,person_scheduleJson text NOT NULL
);

CREATE TABLE companies (
    company_id INTEGER AUTO_INCREMENT PRIMARY KEY
    ,person_id INTEGER NOT NULL
    ,company_name VARCHAR(64)  NOT NULL
    ,company_password varchar(64)  NOT NULL
    ,company_scheduleJson text NOT NULL
    ,CONSTRAINT fk_event_id FOREIGN KEY (person_id)
        REFERENCES people(person_id)
);