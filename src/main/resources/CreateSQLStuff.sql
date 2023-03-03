CREATE SCHEMA `FinalProject` DEFAULT CHARACTER SET utf8;

drop table if exists `people`;
drop table if exists `companies`;

CREATE TABLE companies (
    company_id INTEGER AUTO_INCREMENT PRIMARY KEY
    ,company_name VARCHAR(64)  NOT NULL
    ,company_schedule_json text NOT NULL
);


CREATE TABLE people (
    person_id INTEGER AUTO_INCREMENT PRIMARY KEY
    ,company_id INTEGER NOT NULL
    ,person_name VARCHAR(64)  NOT NULL
    ,person_schedule_json text NOT NULL
	,CONSTRAINT fk_event_id FOREIGN KEY (company_id)
        REFERENCES companies(company_id)
);


INSERT INTO companies (company_name,company_schedule_json)
VALUES ("boeing", "EMpty data for now");
INSERT INTO people (company_id, person_name, person_schedule_json)
VALUES (1, "Adam", "njafenijnifnjisafdd");
select * from companies;
select * from people;