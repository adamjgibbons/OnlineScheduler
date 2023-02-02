document.addEventListener("DOMContentLoaded", () => {

});

function displayCard(messageType, text) {
    var card = document.getElementById("card");
    card.className = "show";
    card.getElementsByTagName("p")[0].innerHTML = text;
    let img = card.getElementsByTagName("img")[0];
    if (messageType == "error") {
        img.src = "/imgs/cross.png";
    } else {
        img.src = "/imgs/check.png";
    }
    setTimeout(function() {
        card.className = card.className.replace("show", "");
    }, 5000);
}
