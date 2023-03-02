/**
 -- AUTHORS --
 + Adam Gibbons

 --------------------------------------
 The MIT License (MIT)
 Copyright (c) 2021 OpenFin
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 **/

package com.vanderbilt.project.Scheduler.DAO.impl;

import com.vanderbilt.project.Scheduler.DAO.custom.FinalProjectRepositoryCustom;
import com.vanderbilt.project.Scheduler.DTO.Company;
import com.vanderbilt.project.Scheduler.DTO.Person;
import com.vanderbilt.project.Scheduler.DTO.QCompany;
import com.vanderbilt.project.Scheduler.DTO.QPerson;
import org.springframework.data.jpa.repository.support.QuerydslRepositorySupport;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class FinalProjectRepositoryImpl extends QuerydslRepositorySupport implements FinalProjectRepositoryCustom {

    QCompany companyTable = QCompany.company;
    QPerson personTable = QPerson.person;

    public FinalProjectRepositoryImpl() {
        super(Company.class);

    }

    @Override
    public ArrayList<Company> getCompanyData() {

        return (ArrayList<Company>) from(companyTable).fetch();
    }

    @Override
    public ArrayList<Person> getAllPeople() {
        return (ArrayList<Person>) from(personTable).fetch();
    }

    @Override
    public ArrayList<Person> getAllPeopleFromCurrentCompany(String companyName) {
        ArrayList<Company> listOfCompanies = (ArrayList<Company>) from(companyTable).fetch();
        int idOfLoggedIn = 0;

        for (Company company: listOfCompanies)
        {
            if(company.getCompanyName().equals(companyName) )
            {
                idOfLoggedIn = company.getCompanyId();
                break;
            }
        }
        ArrayList<Person> listOfPeople = (ArrayList<Person>) from(personTable).fetch();
        ArrayList<Person> returnList = new ArrayList<>();
        for (Person person: listOfPeople)
        {
            if(person.getCompany().getCompanyId() == idOfLoggedIn)
            {
                returnList.add(person);
                System.out.println(person.getPersonName());
            }
        }
        return returnList;
    }


}