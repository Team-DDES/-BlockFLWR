const mysql   = require('mysql');

const connection = mysql.createConnection({
    host     : 'tvstorm-ai.asuscomm.com',
    port     : '12306',
    user     : 'root',
    password : '1324',
    database : 'flower'
  }); 

 async function insertUser(data,callback){
    await connection.query(`INSERT INTO USER (user_type, user_name, user_address, user_sign, user_email, user_phone) VALUES ('${data.userType}','${data.userName}','${data.userAddress}','${data.userSign}','${data.userEmail}','${data.userPhone}')`, (err, result) =>{
        if (err){
            callback({'message':err,'type':false});
        }else{
            callback({'message':result,'type':true});
        }
    });
}


module.exports = {
    insertUser
}
