/**

 -- AUTHORS --
 + Adam Gibbons

 -- DESCRIPTION: --
 This is the controller. This is place where the javascript sends its data.

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


package com.vanderbilt.project.Scheduler.controllers;

import com.vanderbilt.project.Scheduler.service.SchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;

@Controller
public class SchedulerController {

    @Autowired
    private SchedulerService schedulerService;

    @GetMapping({"/", "/ViewSchedules"})
    public String Scheduler(Model model){
        try {
            String output = Runtime.getRuntime().exec("Python3 pythonFile.py >> pythonOutput.txt").toString();
            System.out.println(output);

        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return "ViewSchedules";
    }

    @GetMapping({"/EditTimeFrame"})
    public String editTimeFrame(Model model){
        return "EditTimeFrame";
    }

    @GetMapping({"/EditPerson"})
    public String editPerson(Model model){
        return "EditPerson";
    }

    @GetMapping({"/AddPerson"})
    public String addPerson(Model model){
        return "AddPerson";
    }

    @ResponseBody
    @PostMapping(value = "/getDataFromBar", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getDataFromBar(@RequestBody String keywords, Model model) {

        return schedulerService.getDataFromBar(keywords);
    }

}


