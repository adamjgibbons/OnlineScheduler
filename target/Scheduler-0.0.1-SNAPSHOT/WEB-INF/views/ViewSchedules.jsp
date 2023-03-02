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
                <li><a class="selected" href="ViewSchedules">View Schedules</a></li>
                <li><a href="EditTimeFrame">Edit Time Frame</a></li>
                <li><a href="AddPerson">Add People</a></li>
                <li><a href="EditPerson">Edit People</a></li>
            </ul>
        </div>
    </header>
    <div class="container">
        <div class="wrapper">
            <img class="search-icon" src="/imgs/search.png">
            <input class="search" placeholder="Enter keywords or requirements..." type="text" onkeydown="search(this)">
            <img class="clear-icon" src="/imgs/exit.png">
        </div>
    </div>
    <div id="resultContainer" class="container">
        <div class="leftContainer">
            <ul id="results"></ul>
        </div>
        <div class="rightContainer">
            <pre id="preTagId"></pre>
            <img src="/imgs/download.png" alt="Download" class="downloadBtn" id="downloader" >
        </div>
    </div>
    <div id="card">
        <img src="/imgs/cross.png">
        <p>Error: something went wrong</p>
    </div>

</body>
<script>
        document.addEventListener("DOMContentLoaded", () => {
            // populate results
            // search bar
            const clearIcon = document.querySelector(".clear-icon");
            const searchBar = document.querySelector(".search");
            document.querySelector(".search").addEventListener("keyup", () => {
                if (searchBar.value && clearIcon.style.visibility != "visible") {
                    clearIcon.style.visibility = "visible";
                } else if (!searchBar.value) {
                    clearIcon.style.visibility = "hidden";
                }
            });
        })

        // search bar event listener
        function search(e) {
            if (event.key === 'Enter') {
                if (e.value.length > 0) {
                    sendData(e.value);
                    document.getElementById("resultContainer").classList.remove("hidden");
                } else {
                    displayCard("error", "Error: input cannot be blank");
                }
            }
        }

        function sendData(keywords) {
            let data = {};
                let contextPath = "${pageContext.request.contextPath}";
                let url = contextPath+ "/getDataFromBar";
                // console.log(url);
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
                   // fileArray = answer;
                   // populateData();
                }).catch(error => {
                    //alert("NO!!!!!!! Error = " + error);
                }).finally(() => {

                });
        }
</script>
</html>

<style>
    #resultContainer {
        width: 100%;
        margin-top: 50px;
    }

    .leftContainer {
        display: block;
        width: 50%;
        height: 400px;
        float: left;
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