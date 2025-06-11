window.setInterval(function() { check_status() }, 0);

var show;
var car;
var fuel;
var range;
var heart;
var hunger;
var thirst;
var drunk;
var money;
var useheartbar;
var speed;
var usemilage;
var milage;

$(function(){
    window.addEventListener('message', function(event) {
    var item = event.data;

    show = item.show;
    car = item.car;
    fuel = item.fuel;
    range = item.range;
    heart = item.heart;
    useheartbar = item.useheartbar;
    hunger = item.hunger;
    thirst = item.thirst;
    drunk = item.drunk;
    money = item.money;
    speed = item.speed;
    usemilage = item.usemilage;
    milage = item.milage;
    
    })
});

function check_status() {
    document.getElementById("money").innerHTML = money;
    document.getElementById("speed").innerHTML = speed;
    document.getElementById("rangekm").innerHTML = milage;

    document.getElementById("filler_fuel").style.width = fuel + "%";
    document.getElementById("filler_health").style.width = heart + "%";
    document.getElementById("filler_range").style.width = range + "%";
    document.getElementById("filler_food").style.width = hunger + "%";
    document.getElementById("filler_thirst").style.width = thirst + "%";

    document.getElementById("filler_health_low").style.opacity = 1 - heart / 100;
    document.getElementById("filler_food_low").style.opacity = 1 - hunger / 100;
    document.getElementById("filler_thirst_low").style.opacity = 1 - thirst / 100;
    document.getElementById("filler_fuel_low").style.opacity = 1 - fuel / 100;
    document.getElementById("filler_drunk_low").style.opacity = 1 - drunk / 100;


    if(show == true) {
        document.getElementById("hud").style.display = "block";
    }
    else {
        document.getElementById("hud").style.display = "none";
    }

    if(car == true) {
        document.getElementById("car").style.display = "block";
    }
    else {
        document.getElementById("car").style.display = "none";
    }

    if(drunk == 0) {
        document.getElementById("drunk").style.display = "none";
    }
    else {
        document.getElementById("drunk").style.display = "flex";
        document.getElementById("filler_drunk").style.width = drunk + "%";
    }

    if(useheartbar == true) {
        document.getElementById("health").style.display = "flex";
    }
    else {
        document.getElementById("health").style.display = "none";
    }

    if(usemilage == true) {
        document.getElementById("range").style.display = "flex";
    }
    else {
        document.getElementById("range").style.display = "none";
    }
}



