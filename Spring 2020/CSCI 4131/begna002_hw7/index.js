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

var xml2js = require('xml2js');

var parser = new xml2js.Parser();

var currentUser;

var theinfo;

var userIdCount;

//Grabs database info and sets database connection object
function getDbConfig(){
  fs.readFile(__dirname + '/dbconfig-1.xml', function(err, data){
    if(err) throw err;
    parser.parseString(data, function (err, result){
      if(err) throw err;
      theinfo = result;
    })
  });
}
getDbConfig();

//Returns connection information
function getConnection(){
  var con = mysql.createConnection({
    host: theinfo.dbconfig.host[0],
    user: theinfo.dbconfig.user[0], // replace with the database user provided to you
    password: theinfo.dbconfig.password[0], // replace with the database password provided to you
    database: theinfo.dbconfig.database[0], // replace with the database user provided to you
    port: theinfo.dbconfig.port[0]
  });
  return con;
}

function getUserIdCount(){
  var con = getConnection();

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
          userIdCount = results[i].acc_id;

        }

      });
    });
}

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

app.get('/userLogin',function(req, res) {
	res.send(currentUser);
});

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

app.get('/admin', function (req, res) {
  getUserIdCount();
  if(!req.session.value){
    res.sendFile(__dirname + '/client/login.html');
  } else{
    res.sendFile(__dirname + '/client/adminpage.html');
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
  var con = getConnection();
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

app.get('/getUsers', function(req, res) {
  var con = getConnection();

  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var sql = `SELECT * from tbl_accounts`;
    con.query(sql, function(err, results, fields) {
      if(err) {
        throw err;
      }
      var obj = []
      for(var i = 0; i < results.length; i++){
        var jsonObj = {};
        jsonObj["id"] = results[i].acc_id;
        jsonObj["name"] = results[i].acc_name;
        jsonObj["login"] = results[i].acc_login;
        jsonObj["password"] = results[i].acc_password;
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
  var con = getConnection();

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

app.post('/addUser', function(req, res) {
  getUserIdCount();
  var con = getConnection();

  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var data = {
      flag : true,
      id : 0
    };
    var sql = `SELECT * from tbl_accounts`;
    con.query(sql, function(err, results, fields) {
      if(err) {
        throw err;
      }
      for( var i = 0; i < results.length; i++){
        console.log(data.id);
        if(req.body.login == results[i].acc_login){
          data.flag = false;
          break;
        }
      }
      if(data.flag){
        userIdCount += 1;
        data.id = userIdCount;
          var rowToBeInserted = {
            acc_name: req.body.name,
            acc_login: req.body.login,
            acc_password: crypto.createHash('sha256').update(req.body.password).digest('base64')
          };
          con.query('INSERT tbl_accounts SET ?', rowToBeInserted, function(err, result){
            if(err) {
              throw err;
            }
            console.log("Account: " + req.body.login +  " inserted");

            res.send(data);
          });
      } else {
        res.send(data);
      }
    });
  });

});


app.post('/updateUser', function(req, res) {
  getUserIdCount();
  var con = getConnection();

  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var data = {
      flag : true,
      id : req.body.id
    };
    var sql = `SELECT * from tbl_accounts`;
    con.query(sql, function(err, results, fields) {
      if(err) {
        throw err;
      }
      for( var i = 0; i < results.length; i++){
        if(req.body.login == results[i].acc_login && req.body.id != results[i].acc_id){
          data.flag = false;
          break;
        }
      }
      if(data.flag){
          var insert = {
            name: req.body.name,
            login: req.body.login,
            password: crypto.createHash('sha256').update(req.body.password).digest('base64')
          };
          console.log(req.body.id);
          con.query('Update tbl_accounts SET acc_name=?, acc_login=?, acc_password=? WHERE acc_id=?', [insert.name, insert.login, insert.password, req.body.id], function(err, result){
            if(err) {
              throw err;
            }
            console.log("Account: " + req.body.login +  " Updated");
            res.send(data);
          });
      } else {
        res.send(data);
      }
    });
  });

});


app.post('/deleteUser', function(req, res) {
  getUserIdCount();
  var con = getConnection();

  con.connect(function(err) {
    if (err) {
      throw err;
    };
    var data = {
      flag : true,
      id : 0
    };
    var sql = `SELECT * from tbl_accounts`;
    con.query(sql, function(err, results, fields) {
      if(err) {
        throw err;
      }
      if(req.body.login == currentUser){
        data.flag = false;
      }

      if(data.flag){
        userIdCount -= 1;
        data.id = userIdCount;
          con.query('DELETE FROM tbl_accounts where acc_login=?', req.body.login, function(err, result){
            if(err) {
              throw err;
            }
            console.log("Account: " + req.body.login +  " deleted");
            res.send(data);
          });
      } else {
        res.send(data);
      }
    });
  });

});

// POST method to validate user login
// upon successful login, user session is created
app.post('/sendLoginDetails', function(req, res) {
    var username = req.body.username;
    var password = req.body.password;
    var found = false;
    var con = getConnection();

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
              currentUser = results[i].acc_login;
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
