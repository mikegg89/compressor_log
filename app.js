var express = require('express');
var app = express();
var mysql = require('mysql');
var bodyParser = require('body-parser');

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + '/public'));

var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  database: 'compressor_log',
  password: '...'
});

app.get("/", function(req, res) {
  var q = "SELECT first_name, location_name, comp_name, DATE_FORMAT(created_at, '%b-%D-%Y') as created, cyl_1, cyl_2, cyl_3, cyl_4, CASE WHEN cyl_1 >= cyl_3 + 11 AND cyl_2 >= cyl_4 + 11 THEN 'all valves could be hot valves' WHEN cyl_1 >= cyl_3 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot valves' WHEN cyl_3 >= cyl_1 + 15 AND cyl_2 >= cyl_4 + 15 THEN 'all valves could be hot valves' WHEN cyl_3 >= cyl_1 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'and all valves could be hot' WHEN cyl_1 >= cyl_3 + 15  THEN 'cyl 1 or 3 might have hot valves' WHEN cyl_3 >= cyl_1 + 15 THEN 'cyl 1 or 3 might have hot valves' WHEN cyl_2 >= cyl_4 + 15 THEN 'cyl 2 or 4 might have hot valves' WHEN cyl_4 >= cyl_2 + 15 THEN 'cyl 2 or 4 might have hot valves' ELSE 'valves are ok' END AS 'valves' FROM comp_log JOIN compressors ON compressors.id = comp_log.comp_id JOIN locations ON locations.id = compressors.location_id JOIN operators ON operators.location_id = locations.id WHERE operators.id = comp_log.operator_id ORDER BY created_at DESC;";
  connection.query(q, function(error, results) {
    if (error) console.log(error.message);
      var created_at = results[0].created;
      var first_name = results[0].first_name;
      var location_name = results[0].location_name;
      var comp_name = results[0].comp_name;
      var cyl_1 = results[0].cyl_1;
      var cyl_2 = results[0].cyl_2;
      var cyl_3 = results[0].cyl_3;
      var cyl_4 = results[0].cyl_4;
      var valves = results[0].valves;
    res.render('home', {
      created_at: created_at,
      first_name: first_name,
      location_name: location_name,
      comp_name: comp_name,
      cyl_1: cyl_1,
      cyl_2: cyl_2,
      cyl_3: cyl_3,
      cyl_4: cyl_4,
      valves: valves
    });
  });
});

app.post("/register", function(req, res) {
  var person = {
    suction: req.body.suction,
    discharge: req.body.discharge,
    rpm: req.body.rpm,
    comp_load: req.body.comp_load,
    hours: req.body.hours,
    eng_temp: req.body.eng_temp,
    eng_psi: req.body.eng_psi,
    cyl_1: req.body.cyl_1,
    cyl_2: req.body.cyl_2,
    cyl_3: req.body.cyl_3,
    cyl_4: req.body.cyl_4,
    catalyst_temp: req.body.catalyst_temp,
    comp_id: req.body.comp_id,
    operator_id: req.body.operator_id
  };
  connection.query('INSERT INTO comp_log SET ?', person, function(error, results) {
    if (error) console.log(error.message);
    console.log(results);
  });

  var q = "SELECT first_name, location_name, comp_name, DATE_FORMAT(created_at, '%b-%D-%Y') as created, cyl_1, cyl_2, cyl_3, cyl_4, CASE WHEN cyl_1 >= cyl_3 + 11 AND cyl_2 >= cyl_4 + 11 THEN 'all valves could be hot valves' WHEN cyl_1 >= cyl_3 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'all valves could be hot valves' WHEN cyl_3 >= cyl_1 + 15 AND cyl_2 >= cyl_4 + 15 THEN 'all valves could be hot valves' WHEN cyl_3 >= cyl_1 + 15 AND cyl_4 >= cyl_2 + 15 THEN 'and all valves could be hot' WHEN cyl_1 >= cyl_3 + 15  THEN 'cyl 1 or 3 might have hot valves' WHEN cyl_3 >= cyl_1 + 15 THEN 'cyl 1 or 3 might have hot valves' WHEN cyl_2 >= cyl_4 + 15 THEN 'cyl 2 or 4 might have hot valves' WHEN cyl_4 >= cyl_2 + 15 THEN 'cyl 2 or 4 might have hot valves' ELSE 'valves are ok' END AS 'valves' FROM comp_log JOIN compressors ON compressors.id = comp_log.comp_id JOIN locations ON locations.id = compressors.location_id JOIN operators ON operators.location_id = locations.id WHERE operators.id = comp_log.operator_id ORDER BY created_at DESC;";
  connection.query(q, function(error, results) {
    if (error) console.log(error.message);
    var created_at = results[0].created;
    var first_name = results[0].first_name;
    var location_name = results[0].location_name;
    var comp_name = results[0].comp_name;
    var cyl_1 = results[0].cyl_1;
    var cyl_2 = results[0].cyl_2;
    var cyl_3 = results[0].cyl_3;
    var cyl_4 = results[0].cyl_4;
    var valves = results[0].valves;

    res.render('home', {
      created_at: created_at,
      first_name: first_name,
      location_name: location_name,
      comp_name: comp_name,
      cyl_1: cyl_1,
      cyl_2: cyl_2,
      cyl_3: cyl_3,
      cyl_4: cyl_4,
      valves: valves
    });
  });
});

app.listen(8080, function() {
  console.log('App listening on port 8080!');
});
