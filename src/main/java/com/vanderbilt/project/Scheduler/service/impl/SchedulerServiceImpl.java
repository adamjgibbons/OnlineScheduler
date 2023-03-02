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
import com.vanderbilt.project.Scheduler.DTO.Person;
import com.vanderbilt.project.Scheduler.service.SchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

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
}
