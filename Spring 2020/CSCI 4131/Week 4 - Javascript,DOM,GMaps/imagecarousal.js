var iconImg;
var pictures = {"Moti.jpg", "Brandon.jpg", "Benny.jpg"};
var descriptions = {"1", "2", "3"};
var index = 0;
function showImage(){
  iconImg.setAttribute("src", pictures[index]);
  iconImg.setAttribute("src", descriptions[index]);
  index = (index + 1)%pictures.length;
}
function start(){
  iconImg = document.getElementById("image");
  id = setInterval(function(){showImage()}, 100)
}
