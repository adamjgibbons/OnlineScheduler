<!DOCTYPE html>
<html lang="en">

<!--
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
-->


<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="/css/style.css">
    <script src="/js/main.js"></script>
    <script src="/js/Person.js"></script>

    <title>BeHomePage | Scheduler</title>
</head>

<body id="bodyId">
    <header class="navBar">
        <div class="container">
            <h1>Scheduler</h1>
            <ul>
                <li><a href="ViewSchedules">View Schedules</a></li>
                <li><a href="EditTimeFrame">Edit Time Frame</a></li>
                <li><a href="AddPerson">Add People</a></li>
                <li><a class="selected" href="EditPerson">Edit People</a></li>
            </ul>
        </div>
    </header>

        <div id="resultContainer" class="container">
            <div class="leftContainer">
                <ul id="results"></ul>
            </div>
        </div>
        <div id="card">
            <img src="/imgs/cross.png">
            <p>Error: something went wrong</p>
        </div>
        <script>
            var fileArray = [];
            var currentFunctionId;
            document.addEventListener("DOMContentLoaded", () => {

                document.querySelector(".leftContainer").addEventListener("click", (e) => {
                    console.log(e.target.id);
                    let personId = e.target.id;


                    changePageLook(personId , "Adam");
                });
                populateData();
            });
            function populateData() {
                let people = [];
                var arrayOfPeople = [];
                var arrayOfPeople2 = {
                    personName: "Adam",
                    personId: 1
                };
                var arrayOfPeople3 = {
                    personName: "Marcus",
                    personId: 2
                };
                var arrayOfPeople4 = {
                    personName: "Person 3",
                    personId: 3
                };

                arrayOfPeople[0] = arrayOfPeople2;
                arrayOfPeople[1] = arrayOfPeople3;
                arrayOfPeople[2] = arrayOfPeople4;


                for (let i = 0; i < arrayOfPeople.length; i++) {
                    console.log( arrayOfPeople.at(i).personName);
                    people.push(new Person(
                        arrayOfPeople.at(i).personName,
                        arrayOfPeople.at(i).personId
                    ));
                }
                console.log(arrayOfPeople);
                let ul = document.getElementById("results");
                ul.innerHTML = "";
                for (let person of people) {
                    let li = document.createElement("li");
                    let h3 = document.createElement("h3");
                    let p1 = document.createElement("p");
                    let p2 = document.createElement("p");
                    let b1 = document.createElement("br");
                    h3.setAttribute("id", person.personId);
                    h3.appendChild(document.createTextNode(person.personName));
                    li.appendChild(h3);
                    ul.appendChild(li);
                }
            }

            function changePageLook(personId, personName)
            {
                let body = document.getElementById("bodyId");
                body.innerHTML = `<header class="navBar">
                        <div class="container">
                            <h1>Scheduler</h1>
                            <ul>
                                <li><a href="ViewSchedules">View Schedules</a></li>
                                <li><a href="EditTimeFrame">Edit Time Frame</a></li>
                                <li><a href="AddPerson">Add People</a></li>
                                <li><a class="selected" href="EditPerson">Edit People</a></li>
                            </ul>
                        </div>
                    </header>

                    <br></br>
                    <form id="schedule-form">
                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name" value="`+personName+`"><br><br>
                        <label for="manager">Manager:</label>
                        <input type="radio" id="manager-yes" name="manager" value="yes"> Yes
                        <input type="radio" id="manager-no" name="manager" value="no"> No
                        <br><br>
                        <label for="desired-hours">Desired Hours:</label>
                        <input type="number" id="desired-hours" name="desired-hours"><br><br>
                        <table id="schedule-table">
                            <thead>
                              <tr>
                                <td>Day</td>
                                <td>Date</td>
                                <td>Description</td>
                                <td>Free Hours</td>
                              </tr>
                            </thead>
                            <tbody>
                            </tbody>
                          </table>
                      <input type="button" value="Submit" onclick="submitForm()">
                    </form>`;

                generateTable();
            }

            function generateTable(){
                // Add the input fields for each day
                for (let i = 0; i < 14; i++) {
                  let date = new Date();
                  date.setDate(date.getDate() + i);
                  let day = date.toLocaleDateString('en-US', {weekday: 'long'});
                  // console.log(day);
                  let row = `
                    <tr>
                      <td>`+day+`</td>
                      <td>`+date.toLocaleDateString('en-US')+`</td>
                      <td><input type="text" name="description"></td>
                      <td>
                        <input type="time" name="start-time"> to
                        <input type="time" name="end-time">
                      </td>
                    </tr>
                  `;
                  document.querySelector('#schedule-table').innerHTML += row;
                }
            }

            function getPeople(keywords) {
                let data = {};
                    let contextPath = "${pageContext.request.contextPath}";
                    let url = contextPath+ "/getPeople";
                    //console.log(url);
                    fetch(url, {
                                    method: "POST",
                                    body: JSON.stringify(keywords),
                                    headers:{
                                        "Content-Type": "application/json"
                                    }
                                })
                    .then(httpresponseservlet => {
                        if (httpresponseservlet.ok) {
                            return httpresponseservlet.json();
                        } else {
                            //alert("NO!!!!!!!! Bad Http Status: " + httpresponseservlet.status);
                        }
                    }).then(answer => {
                       console.log(answer);
                       fileArray = answer;
                       populateData();
                    }).catch(error => {
                        //alert("NO!!!!!!! Error = " + error);
                    }).finally(() => {
                    });
            }
        </script>
        <style>
            #resultContainer {
                width: 100%;
                margin-top: 50px;
            }

            .leftContainer {
                display: block;
                width: 100%;
                height: 400px;
                text-align: center;
            }

            .leftContainer::after {
                clear: left;
            }

            .rightContainer {
                position: relative;
                display: block;
                width: 50%;
                height: 400px;
                box-sizing: border-box;
                padding: 20px;
                float: right;
                background: var(--light-purple);
                overflow: scroll;
            }

            .rightContainer::after {
                clear: right;
            }

            .rightContainer pre {
                font-size: 22px;
                color: white;
                font-style: monospace !important;
            }

            .downloadBtn {
                display: block;
                justify-content: flex-end;
                display: flex;
                float: right;
                width: 40px;
            }

            .downloadBtn:hover {
                cursor: pointer;
            }

            #resultContainer ul {
                width: 100%;
                height: 100%;
                overflow: scroll;
                color: white;
            }

            #resultContainer li {
                list-style: none;
                box-sizing: border-box;
                padding: 10px 50px;
            }

            #resultContainer li:nth-child(even) {
                background: var(--purple);
            }

            #resultContainer li:nth-child(odd) {
                background: var(--dark-purple);
            }

            #resultContainer li:hover {
                cursor: pointer;
            }

            #resultContainer li h3 {
                margin-bottom: 10px;
            }

            .wrapper {
                position: relative;
                display: flex;
                min-width: 100px;
                margin-top: 50px;
            }

            .search {
                border: 2px solid var(--purple);
                color: var(--purple);
                border-radius: 5px;
                height: 50px;
                width: 100%;
                padding: 5px 70px;
                outline: 0;
                background-color: none;
                font-size: 24px;
                transition: .5s;
            }

            .search::placeholder {
                color: var(--purple);
            }

            .search-icon {
                position: absolute;
                top: 8px;
                left: 8px;
                width: 40px;
            }

            .clear-icon {
                position: absolute;
                top: 9px;
                right: 8px;
                width: 40px;
                cursor: pointer;
                visibility: hidden;
            }

            .search:hover,
            .search:focus {
                border: 2px solid var(--purple);
            }
        </style>
</body>
</html>