const mysql   = require('mysql');
const commonMapper = require('mybatis-mapper');  //매핑할 마이바티스
const format = {language: 'sql', indent: '  '};

const connection = mysql.createConnection({
    host     : 'tvstorm-ai.asuscomm.com',
    port     : '12306',
    user     : 'root',
    password : '1324',
    database : 'flower'
  }); 

  commonMapper.createMapper(['./database/mapper/common.xml']);

async function insertUser(data,callback){
    console.log(data);
    let query = commonMapper.getStatement('common', 'insertUser', data, format);
    
    await connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}

async function insertTask(data,callback){
    let query = commonMapper.getStatement('common', 'insertTask', data, format);
    await connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}

async function getUser(data,callback){
    
    let query = commonMapper.getStatement('common', 'getUser', data, format);
    
    await connection.query(query, (err, rows) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            if(rows.length==0){
                callback({'data':null,'type':true});
            }else{
                callback({'data':rows,'type':true});
            }
        }
    });
}

async function getTask(data,callback){
    console.log(data.userAddress)
    var query = '';
    if(data.user_id==null){
        query = ''
    }
    await connection.query(`SELECT * FROM USER WHERE user_address='${data.userAddress}' AND use_yn='Y'`, (err, rows) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            if(rows.length==0){
                callback({'data':null,'type':true});
            }else{
                callback({'data':rows,'type':true});
            }
        }
    });
}
module.exports = {
    insertUser,
    insertTask,
    getUser
}
