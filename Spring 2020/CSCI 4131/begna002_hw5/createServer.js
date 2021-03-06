const http = require('http');
const url = require('url');
const fs = require('fs');
const qs = require('querystring');

http.createServer(function (req, res) {
  var q = url.parse(req.url, true);
  var filename = "." + q.pathname;
  if(req.url === '/'){
    indexPage(req,res);
  }
  else if(req.url === '/index.html'){
    indexPage(req,res);
  }
  else if(req.url === '/contact.html'){
    contactPage(req,res);
  }
  else if(req.url === '/addContact.html'){
    addContact(req,res);
  }
  else if(req.url === '/contact.json'){
    getContact(req, res);
  }
  else if(req.url === '/postContactEntry'){
    var reqBody = '';
    req.on('data', function(data) {
      reqBody+= data;
    });
    req.on('end', function() {
      postContactEntry(reqBody, req, res);
    });
  }
  else{
    res.writeHead(404, {'Content-Type': 'text/html'});
    return res.end("404 Not Found");
  }
}).listen(9001);


function indexPage(req, res) {
  fs.readFile('client/index.html', function(err, html) {
    if(err) {
      throw err;
    }
    res.statusCode = 200;
    res.setHeader('Content-type', 'text/html');
    res.write(html);
    res.end();
  });
}
function contactPage(req, res) {
  fs.readFile('client/contact.html', function(err, html) {
    if(err) {
      throw err;
    }
    res.statusCode = 200;
    res.setHeader('Content-type', 'text/html');
    res.write(html);
    res.end();
  });
}
function addContact(req, res) {
  fs.readFile('client/addContact.html', function(err, html) {
    if(err) {
      throw err;
    }
    res.statusCode = 200;
    res.setHeader('Content-type', 'text/html');
    res.write(html);
    res.end();
  });
}

function getContact(req, res){
  var obj;
  fs.readFile('contact.json', function(err, data) {
    if(err) {
      throw err;
    }
    res.statusCode = 200;
    res.setHeader('Content-type', 'application/json');
    res.end(data);
    // res.end();
  });
}

function postContactEntry(reqBody, req, res){
  var postObj = qs.parse(reqBody);
  var jsonObj = {};
  jsonObj["name"] = postObj.contactName;
  jsonObj["email"] = postObj.email;
  jsonObj["address"] = postObj.address;
  jsonObj["phoneNumber"] = postObj.phoneNumber;
  jsonObj["favoritePlace"] = postObj.favoritePlace;
  jsonObj["favoritePlaceURL"] = postObj.favoritePlaceURL;

  fs.readFile('contact.json', function(err, fileJsonString) {
    if(err) {
      throw err;
    }
    var fileJson = JSON.parse(fileJsonString);
    fileJson["contact"].push(jsonObj);
    fileJsonString = JSON.stringify(fileJson);
    // fs.writeFile("./contact.json", fileJsonString, (err) => {
    //   if (err) {
    //       console.error(err);
    //       return;
    //   };
    //   console.log("File has been created");
    // }); 
    fs.writeFile("contact.json", fileJsonString, function(err, fileJsonString) {
      if(err) {
        throw err;
      };
    });
    res.writeHead(302, {'Location': '/contact.html'});
    res.end();
  });

}
