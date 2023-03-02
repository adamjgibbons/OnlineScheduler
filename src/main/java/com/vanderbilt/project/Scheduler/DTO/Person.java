package com.vanderbilt.project.Scheduler.DTO;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name="people")
public class Person implements Serializable {

    private static final long serialVersionUID = -2060173648972096986L;

    public Person() {
        super();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "person_id", columnDefinition = "INTEGER")
    private int personId;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "company_id", referencedColumnName = "company_id", columnDefinition = "INTEGER")
    private Company company;

    @Column(name = "person_name", columnDefinition = "VARCHAR(64)")
    private String personName;


    @Column(name = "person_schedule_json", columnDefinition = "text")
    private String personScheduleJson;

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int personId) {
        this.personId = personId;
    }

    public Company getCompany() {
        return company;
    }

    public void setCompany(Company company) {
        this.company = company;
    }

    public String getPersonName() {
        return personName;
    }

    public void setPersonName(String personName) {
        this.personName = personName;
    }

    public String getPersonScheduleJson() {
        return personScheduleJson;
    }

    public void setPersonScheduleJson(String companyScheduleJson) {
        this.personScheduleJson = companyScheduleJson;
    }
}