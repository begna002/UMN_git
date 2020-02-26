const input = document.querySelector('input');
const result = document.getElementById('result');
var meter = document.getElementById('meter');
var first = false;
var second = false;
var third = false;
var fourth = false;
var fifth = false;

input.addEventListener('input', updateValue);
function updateValue(e){
  var strength = 0
  var val = e.target.value;
  if (val.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/) && !first){
    strength += 1;
    first = true;
  }
//   // If it has numbers and characters, increase strength value.
  if (val.match(/([a-zA-Z])/) && val.match(/([0-9])/) && !second){
    strength += 1;
    second = true;
  }
//   // If it has one special character, increase strength value.
  if (val.match(/([!,%,&,@,#,$,^,*,?,_,~])/) && !third){
    strength += 1;
    third = true;
  }
//   // If it has two special characters, increase strength value.
  if (val.match(/(.*[!,%,&,@,#,$,^,*,?,_,~].*[!,%,&,@,#,$,^,*,?,_,~])/) && !fourth){
     strength += 1;
     fourth = true;
  }

  if(val.length > 7 && !fifth){
    strength+=1;
    fifth = true;
  }
  if (val.length == 0) {
    strength = 0;
    meter.classList.remove("short");
    meter.classList.remove("weak");
    meter.classList.remove("good");
    meter.classList.remove("strong");
    var first = false;
    var second = false;
    var third = false;
    var fourth = false;
    var fifth = false;
  }
  else if(val.length < 6){
      result.textContent = "Too Short";
      meter.classList.remove("weak");
      meter.classList.remove("good");
      meter.classList.remove("strong");
      meter.classList.add("short");
  } else {
    if (strength < 2) {
      result.textContent = "Weak";
      meter.classList.remove("short");
      meter.classList.remove("strong");
      meter.classList.remove("good");
      meter.classList.add("weak");
    }
    if (strength == 2){
       result.textContent = "Good";
       meter.classList.remove("weak");
       meter.classList.remove("strong");
       meter.classList.remove("short");
       meter.classList.add("good");
     }
    if  (strength > 2) {
      result.textContent = "Strong";
      meter.classList.remove("good");
      meter.classList.remove("weak");
      meter.classList.remove("short");
      meter.classList.add("strong");
    }
  }
}
