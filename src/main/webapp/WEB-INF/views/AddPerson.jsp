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

    <title>BeHomePage | Scheduler</title>
</head>

<body>
    <header class="navBar">
        <div class="container">
            <h1>Scheduler</h1>
            <ul>
                <li><a href="ViewSchedules">View Schedules</a></li>
                <li><a href="EditTimeFrame">Edit Time Frame</a></li>
                <li><a class="selected" href="AddPerson">Add People</a></li>
                <li><a href="EditPerson">Remove People</a></li>
            </ul>
        </div>
    </header>

    <br></br>
    <form id="schedule-form">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name"><br><br>
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
      <input type="button" value="Submit" onclick="sendData()">
    </form>
    <script>
    document.addEventListener("DOMContentLoaded", () => {
            generateTable();
            getAllPeople();

            })

    function generateTable(){
        // Add the input fields for each day
        for (let i = 0; i < 7; i++) {
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

    function sendData(keywords) {
        let data = {};

            let name = document.getElementById("name").value;
            let desiredHours = document.getElementById("desired-hours").value;
            let manager = document.getElementById('manager-yes').checked;

            data = {
              id: name,
              isManager: manager,
              hoursDesired: desiredHours,
            };

            console.log(name);
            let freeTimes = [];
            let timeAvailable = {};
            let dayOfWeek = "";
            let from = "";
            let to = "";
            let shifts = "morning";
            let table = document.getElementById("schedule-table");
            for (var i = 1, row; row = table.rows[i]; i++) {
                freeTimes = [];
               for (var j = 0, col; col = row.cells[j]; j++) {
                    if (j==0)
                    {
                        dayOfWeek = col.innerHTML;
                    }
                    if(j==3)
                    {
                        from = col.getElementsByTagName('input')[0].value;
                        to = col.getElementsByTagName('input')[1].value;

                        timeAvailable = {
                            shifts: shifts,
                            from: from,
                            to: to
                        };

                        freeTimes.push(timeAvailable);
                        data[dayOfWeek] = {freeTimes: freeTimes};
                    }
               }
            }

            let contextPath = "${pageContext.request.contextPath}";
            let url = contextPath+ "/savePerson";
            console.log(url);
            fetch(url, {
                            method: "POST",
                            body: JSON.stringify(data),
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
            }).catch(error => {
                //alert("NO!!!!!!! Error = " + error);
            }).finally(() => {

            });
    }

        function getAllPeople() {
            let data = {};
                let contextPath = "${pageContext.request.contextPath}";
                let url = contextPath+ "/getAllPeople";
                // console.log(url);
                fetch(url, {
                                method: "POST",
                                body: JSON.stringify("String"),
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

                }).catch(error => {
                    //alert("NO!!!!!!! Error = " + error);
                }).finally(() => {

                });
        }



  // Handle the form submit button click
  function submitForm() {
    let name = $('input[name="name"]').val();
    let manager = $('input[name="manager"]:checked').val();
    let desiredHours = $('input[name="desired-hours"]').val();
    console.log(name);
    let tableData = [];
    let table = document.getElementById("schedule-table");
    for (var i = 0, row; row = table.rows[i]; i++) {
      for (var j = 0, col; col = row.cells[j]; j++) {
        var inputs = col.querySelectorAll("input");

      }
    }
    $('#schedule-table tr').each(function() {
      // let startTime= $(this).find('td:nth-child(4)').querySelectorAll("input");
      console.log($(this).find('td:nth-child(4)'));
      let rowData = {
        day: $(this).find('td:nth-child(1)').text(),
        endTime: $(this).find('td:nth-child(4)').find('.input[name="start-time"]').text(),
      };
      tableData.push(rowData);
    });
    let data = {
      name: name,
      manager: manager,
      desiredHours: desiredHours,
      tableData: tableData
    };
  }
    </script>
  </body>
</html>

<style>
    #schedule-table {
  border-collapse: collapse;
  width: 100%;
}

#schedule-table th, #schedule-table td {
  border: 1px solid black;
  padding: 8px;
  text-align: left;
}

#schedule-table th {
  background-color: lightgray;
}

</style>

</body>
</html>