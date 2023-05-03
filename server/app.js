
const mysql   = require('mysql');
const connection = mysql.createConnection({
    host     : '',
    user     : '',
    password : '',
    database : ''
  }); 
const express = require('express')
const app = express()
const port = 3000

connection.connect();
connection.query('SELECT * from user', (error, rows, fields) => {
    if (error) throw error;
    console.log('User info is: ', rows);
  });
  
  connection.end();
app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})