// YOU CAN USE THIS FILE AS REFERENCE FOR SERVER DEVELOPMENT

// include the express module
var express = require("express");

// create an express application
var app = express();

// helps in extracting the body portion of an incoming request stream
var bodyparser = require('body-parser');

// fs module - provides an API for interacting with the file system
var fs = require("fs");

// helps in managing user sessions
var session = require('express-session');

// native js function for hashing messages with the SHA-256 algorithm
var crypto = require('crypto');

// include the mysql module
var mysql = require("mysql");

const qs = require('querystring');


// apply the body-parser middleware to all incoming requests
app.use(bodyparser());

// use express-session
// in mremory session is sufficient for this assignment
app.use(session({
  secret: "csci4131secretkey",
  saveUninitialized: true,
  resave: false}
));

// server listens on port 9007 for incoming connections
app.listen(9270, () => console.log('Listening on port 9270!'));

app.get('/',function(req, res) {
	res.sendFile(__dirname + '/client/welcome.html');
});


// // GET method route for the contact page.
// It serves contact.html present in client folder
app.get('/contact',function(req, res) {
  if(!req.session.value){
    res.sendFile(__dirname + '/client/login.html');
  } else{
    res.sendFile(__dirname + '/client/contact.html');
  }
});

// GET method route for the addContact page.
// It serves addContact.html present in client folder
app.get('/addContact',function(req, res) {
  if(!req.session.value){
    res.sendFile(__dirname + '/client/login.html');
  } else{
    res.sendFile(__dirname + '/client/addContact.html');
  }
});
//GET method for stock page
app.get('/stock', function (req, res) {
  if(!req.session.value){
    res.sendFile(__dirname + '/client/login.html');
  } else{
    res.sendFile(__dirname + '/client/stock.html');
  }
});


// GET method route for the login page.
// It serves login.html present in client folder
app.get('/login',function(req, res) {
  res.sendFile(__dirname + '/client/login.html');
});

app.get('/logoutImg',function(req, res) {
  res.sendFile(__dirname + '/client/logout.png');
});

// GET method to return the list of contacts
// The function queries the tbl_contacts table for the list of contacts and sends the response back to client
app.get('/getListOfContacts', function(req, res) {
  var con = mysql.createConnection({
    host: "cse-larry.cse.umn.edu",
    user: "C4131S20U9", // replace with the database user provided to you
    password: "111", // replace with the database password provided to you
    database: "C4131S20U9", // replace with the database user provided to you
    port: 3306
  });
  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var sql = `SELECT * from tbl_contacts`;
    con.query(sql, function(err, results, fields) {
      if(err) {
        throw err;
      }
      var obj = []
      for(var i = 0; i < results.length; i++){
        var jsonObj = {};
        jsonObj["name"] = results[i].contact_name;
        jsonObj["email"] = results[i].contact_email;
        jsonObj["address"] = results[i].contact_address;
        jsonObj["phoneNumber"] = results[i].contact_phone;
        jsonObj["favoritePlace"] = results[i].contact_favoriteplace;
        jsonObj["favoritePlaceURL"] = results[i].contact_favoriteplaceurl;
        obj.push(jsonObj);
      }
      var obj = JSON.stringify(obj);
      // res.statusCode = 200;
      // res.setHeader('Content-type', 'application/json');
      // res.end(result);
      res.send(obj);
    });
  });


});


// POST method to insert details of a new contact to tbl_contacts table
app.post('/postContact', function(req, res) {
  var con = mysql.createConnection({
    host: "cse-larry.cse.umn.edu",
    user: "C4131S20U9", // replace with the database user provided to you
    password: "111", // replace with the database password provided to you
    database: "C4131S20U9", // replace with the database user provided to you
    port: 3306
  });
  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var rowToBeInserted = {
      contact_name: req.body.contactName,
      contact_email: req.body.email,
      contact_address: req.body.address,
      contact_phone: req.body.phoneNumber,
      contact_favoriteplace: req.body.favoritePlace,
      contact_favoriteplaceurl: req.body.favoritePlaceURL
    };
    con.query('INSERT tbl_contacts SET ?', rowToBeInserted, function(err, result){
      if(err) {
        throw err;
      }
      console.log(req.body.contactName +  " inserted");
      res.sendFile(__dirname + '/client/contact.html');
    });
  });
});

// POST method to validate user login
// upon successful login, user session is created
app.post('/sendLoginDetails', function(req, res) {
    var username = req.body.username;
    var password = req.body.password;
    var found = false;

    var con = mysql.createConnection({
      host: "cse-larry.cse.umn.edu",
      user: "C4131S20U9", // replace with the database user provided to you
      password: "111", // replace with the database password provided to you
      database: "C4131S20U9", // replace with the database user provided to you
      port: 3306
    });
    con.connect(function(err) {
      if (err) {
        throw err;
      };
      var sql = `SELECT * from tbl_accounts`;
      con.query(sql, function(err, results, fields) {
        if(err) {
          throw err;
        }
        for(var i = 0; i < results.length; i++){
          if(username == results[i].acc_login){
            var resPassword = crypto.createHash('sha256').update(password).digest('base64');
            if(resPassword == results[i].acc_password){
              console.log("Successful Login!");
              req.session.value=1;
              found = true;
              fs.readFile(__dirname + '/client/login.html', function(err, data){
                if(err){
                  res.sendStatus(404);
                }
                else{
                  var stringData = data.toString();
                  var ret = stringData.replace("visible", "hidden");
                  fs.writeFile(__dirname + '/client/login.html', ret, function(err){
                    if(err){
                      res.sendStatus(404);
                    } else {
                    }
                  });
                  res.sendFile(__dirname + '/client/contact.html');
                }
              });
            }
          }
        }
        if(!found){
          console.log("Unsuccessful Login!");
          res.redirect('invalidLogin');
        }
      });
    });

});

app.get('/invalidLogin', function(req, res){
  fs.readFile(__dirname + '/client/login.html', function(err, data){
    if(err){
      res.sendStatus(404);
    }
    else{
      var stringData = data.toString();
      var ret = stringData.replace("hidden", "visible");
      fs.writeFile(__dirname + '/client/login.html', ret, function(err){
        if(err){
          res.sendStatus(404);
        } else {
        }
      });
      res.sendFile(__dirname + '/client/login.html');
    }
  });
});


// log out of the application
// destroy user session
app.get('/logout', function(req, res) {
  if(!req.session.value){
    res.sendFile(__dirname + '/client/login.html');
  } else{
    req.session.destroy();
    console.log("Successfully Logged Out")
    res.sendFile(__dirname + '/client/login.html');
  }
});

// middle ware to serve static files
app.use('/client', express.static(__dirname + '/client'));


// function to return the 404 message and error to client
app.get('*', function(req, res) {
  console.log("File: " + req.url + " not found");
  res.sendStatus(404);
});
