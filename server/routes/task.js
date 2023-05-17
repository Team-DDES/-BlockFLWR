const express = require('express');
const router = express.Router();
const { insertTask, getTask, insertTaskParticipate } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const TaskModel = require('../model/task_model');
const {createTaskContract} = require('../web3/alchemy-sdk');
const path = require("path")
// 1. child-process모듈의 spawn 취득
const spawn = require('child_process').spawn;

//기관 테스크 등록
router.post('/', async(req, res) => {
    
    var data = req.body;
    var task = new TaskModel(data);
    //TODO 빈포트 찾고 smartcontact 생성 시작
    //현재는 1개로 고정 컨트랙트 미생성
    //task.taskContractAddress = "0x1234";
    //task.taskPort="8081";
    task.taskStatusCode=0;
    try{
       
        await insertTask(task,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    createTaskContract(data.insertId);
                    res.send(body);
                }
                
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
        // // 2. spawn을 통해 "python 파이썬파일.py" 명령어 실행
        // const result = spawn('python', [path.join(__dirname, '..', '..', '/examples/quickstart_pytorch_ethereum/server.py'),8081, 2]);
        // // 3. stdout의 'data'이벤트리스너로 실행결과를 받는다.
        // result.stdout.on('data', function(data) {
        //     console.log("get Data");
        //     console.log(data.toString());
        // });

        // // 4. 에러 발생 시, stderr의 'data'이벤트리스너로 실행결과를 받는다.
        // result.stderr.on('data', function(data) {
        //     console.log("get error");
        //     console.log(data.toString());
        // });

    }catch(err){
        res.send(err);
    }
});

//트레이너 task 참가
router.post('/participate', async(req, res) => {
    
    var data = req.body;
    var task = new TaskModel(data);
    try{
       
        await insertTaskParticipate(task,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    res.send(body);
                }
                
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
        // 2. spawn을 통해 "python 파이썬파일.py" 명령어 실행
        const result = spawn('python', [path.join(__dirname, '..', '..', '/examples/quickstart_pytorch_ethereum/client.py')]);
        // 3. stdout의 'data'이벤트리스너로 실행결과를 받는다.
        result.stdout.on('data', function(data) {
            console.log("get Data");
            console.log(data.toString());
        });

        // 4. 에러 발생 시, stderr의 'data'이벤트리스너로 실행결과를 받는다.
        result.stderr.on('data', function(data) {
            console.log("get error");
            console.log(data.toString());
        });

    }catch(err){
        res.send(err);
    }
});

router.get('/', async(req, res) => {
    var data = req.body;
    const search = {
        searchText: data.searchText==undefined?null:data.searchText,
        organizationUserId:data.organizationUserId==undefined?null:data.organizationUserId,
        taskStatusCode:data.taskStatusCode==undefined?null:data.taskStatusCode,
        trainerUserId:data.trainerUserId==undefined?null:data.trainerUserId,
        taskId:data.taskId==undefined?null:data.taskId,
    }
    console.log(search);
    try{
        await getTask(search,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'task not found',404);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    res.send(body);
                }
                
            }else{
                res.status(404);
                res.send(result['data']);
            }
        })
    }catch(err){
        res.send(err);
    }
});
module.exports = router;
