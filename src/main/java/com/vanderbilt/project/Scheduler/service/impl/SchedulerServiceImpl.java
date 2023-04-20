/**

 -- AUTHORS --
 + Adam Gibbons

 -- DESCRIPTION: --
 This is the service layer that has almost all the logic

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

package com.vanderbilt.project.Scheduler.service.impl;

import com.vanderbilt.project.Scheduler.DAO.FinalProjectRepository;
import com.vanderbilt.project.Scheduler.DTO.Company;
import com.vanderbilt.project.Scheduler.DTO.Person;
import com.vanderbilt.project.Scheduler.service.SchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

@Service
public class SchedulerServiceImpl implements SchedulerService {

    @Autowired
    FinalProjectRepository finalProjectRepository;

    @Override
    public Object getDataFromBar(String keywords) {
        System.out.println(keywords);
        return null;
    }

    @Override
    public Object savePerson(Person person) {
        System.out.println("enter the save the data");

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails)principal).getUsername();
        } else {
            username = principal.toString();
        }

        ArrayList<Company> companyList = finalProjectRepository.getCompanyData();
        for (Company company: companyList) {
            if(company.getCompanyName().equals(username))
            {
                person.setCompany(company);
                List<Person> listOfPeople = company.getPersonList();
                listOfPeople.add(person);
                System.out.println("Saving the data");
                finalProjectRepository.save(company);
                return null;
            }
        }

        return null;

    }

    @Override
    public Object saveCompanySchedule(Company company) {

        finalProjectRepository.deleteAll();
        System.out.println("delete everyting");
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else {
            username = principal.toString();
        }

        company.setCompanyName(username);
        finalProjectRepository.save(company);

        return null;
    }

    @Override
    public Object saveGeneratedSchedule(Company company) {

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else {
            username = principal.toString();
        }

        company.setCompanyName(username);
        finalProjectRepository.save(company);

        return null;
    }


    public void executeAlgorithm() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails)principal).getUsername();
        } else {
            username = principal.toString();
        }
        String officialPeopleJson = "{ \"People\": [";
        String officialSchedule = "";
        ArrayList<Company> companyList = finalProjectRepository.getCompanyData();
        for (Company company: companyList) {
            if(company.getCompanyName().equals(username))
            {
                officialSchedule = company.getCompanyScheduleJson();
                List<Person> peopleList = company.getPersonList();
                for (int i =0; i<peopleList.size(); i++)
                {
                    officialPeopleJson = officialPeopleJson + peopleList.get(i).getPersonScheduleJson();
                    if(i+1<peopleList.size())
                    {
                        officialPeopleJson = officialPeopleJson + ", ";
                    }
                    else {
                        officialPeopleJson = officialPeopleJson + "] }";
                    }
                }
            }
        }
        try {
            FileWriter myWriter = new FileWriter("People.json");
            myWriter.write(officialPeopleJson);
            myWriter.close();
        } catch (IOException e) {
        System.out.println("An error occurred.");
        e.printStackTrace();
        }
        try {
            FileWriter myWriter = new FileWriter("Schedule.json");
            myWriter.write(officialSchedule);
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

        try {
            Path path = Files.createTempFile("Schedule", ".json");
            while(Files.exists(path)==false)
            {
                System.out.println("Waiting...");

            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }


        try {
            String output = Runtime.getRuntime().exec("python pythonOptimizer.py").toString();
            System.out.println(output);

            BufferedReader br = new BufferedReader(new FileReader("scheduleDF.json"));
            String fullJson = "";
            String line;
            while ((line = br.readLine()) != null) {
                fullJson = fullJson + line;
            }

            for (Company company: companyList) {
                if(company.getCompanyName().equals(username))
                {
                    company.setGeneratedScheduleJson(fullJson);
                    saveGeneratedSchedule(company);
                    break;

                }
            }

        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }


    @Override
    public ArrayList<Person> getAllPeopleFromCurrentCompany(){

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails)principal).getUsername();
        } else {
            username = principal.toString();
        }
        ArrayList<Person> returnValue = finalProjectRepository.getAllPeopleFromCurrentCompany(username);
        return returnValue;
    }

    @Override
    public Object getGeneratedSchedule() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails)principal).getUsername();
        } else {
            username = principal.toString();
        }
        String generatedSchedule = "";
        ArrayList<Company> companyList = finalProjectRepository.getCompanyData();
        for (Company company: companyList) {
            if(company.getCompanyName().equals(username))
            {
                return company.getGeneratedScheduleJson();
            }
        }
        return null;
    }

    @Override
    public Object deletePerson(int person_id) {
        System.out.println(person_id);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = "";
        if (principal instanceof UserDetails) {
            username = ((UserDetails)principal).getUsername();
        } else {
            username = principal.toString();
        }
        ArrayList<Company> companyList = finalProjectRepository.getCompanyData();
        finalProjectRepository.deleteAll();
        ArrayList<Person> newListOfPeople = new ArrayList<>();
        for (Company company: companyList) {
            if(company.getCompanyName().equals(username))
            {
                for(Person person  : company.getPersonList()){
                    if (person.getPersonId() != person_id)
                    {
                        newListOfPeople.add(person);
                    }
                }
                company.setPersonList(newListOfPeople);
                company.setGeneratedScheduleJson("");
            }

            finalProjectRepository.save(company);
        }
        return null;
    }
}
