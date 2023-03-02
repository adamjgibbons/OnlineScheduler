package com.vanderbilt.project.Scheduler.DTO;

import javax.persistence.*;
import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="companies")
public class Company implements Serializable{

    public Company() {
        super();
    }

    private static final long serialVersionUID = -4513604167770036149L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "company_id", columnDefinition = "INTEGER")
    private int companyId;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "company", cascade = {CascadeType.ALL})
    List<Person> personList = new ArrayList<Person>();

    @Column(name = "company_name", columnDefinition = "VARCHAR(64)")
    private String companyName;

    @Column(name = "company_schedule_json", columnDefinition = "text")
    private String companyScheduleJson;

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public List<Person> getPersonList() {
        return personList;
    }

    public void setPersonList(List<Person> personList) {
        this.personList = personList;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyScheduleJson() {
        return companyScheduleJson;
    }

    public void setCompanyScheduleJson(String companyScheduleJson) {
        this.companyScheduleJson = companyScheduleJson;
    }



}