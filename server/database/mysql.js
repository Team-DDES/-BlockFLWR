const mysql   = require('mysql');
const commonMapper = require('mybatis-mapper');
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
    let query = commonMapper.getStatement('common', 'insertUser', data, format);
    
    connection.query(query, (err, result) => {
        if (err) {
            callback({ 'data': err, 'type': false });
        } else {
            callback({ 'data': result, 'type': true });
        }
    });
}

async function insertTask(data,callback){
    let query = commonMapper.getStatement('common', 'insertTask', data, format);
    connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}


async function insertTaskParticipate(data,callback){
    let query = commonMapper.getStatement('common', 'insertTaskParticipate', data, format);
    connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}

async function insertMarketNft(data,callback){
    let query = commonMapper.getStatement('common', 'insertMarketNft', data, format);
    connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}

async function updateTask(data,callback){
    console.log(data);
    let query = commonMapper.getStatement('common', 'updateTask', data, format);
    connection.query(query, (err, result) =>{
        if (err){
            callback({'data':err,'type':false});
        }else{
            callback({'data':result,'type':true});
        }
    });
}

async function getTaskUserCount(data,callback){
    let query = commonMapper.getStatement('common', 'getTaskUserCount', data, format);
    connection.query(query, (err, rows) =>{
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

async function getUser(data,callback){
    let query = commonMapper.getStatement('common', 'getUser', data, format);
    connection.query(query, (err, rows) =>{
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
   
    let query = commonMapper.getStatement('common', 'getTask', data);
    console.log(query);
    connection.query(query, (err, rows) =>{
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

async function getTaskDetail(data,callback){
   
    let query = commonMapper.getStatement('common', 'getTaskDetail', data);
    console.log(query);
    connection.query(query, (err, rows) =>{
        if (err){
            console.log(err)
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
    insertTaskParticipate,
    updateTask,
    getTaskUserCount,
    getTaskDetail,
    getUser,
    getTask,
    insertMarketNft
}
