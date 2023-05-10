const express = require('express');
const router = express.Router();
const { insertTask, getTask } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const TaskModel = require('../model/task_model');
const path = require("path")
// 1. child-process모듈의 spawn 취득
const spawn = require('child_process').spawn;

router.post('/', async(req, res) => {
    
    var data = req.body;
    var user = new TaskModel(data);
    user.taskStatusCode = 0;

    //TODO 빈포트 찾고 smartcontact 생성 시작
    //현재는 1개로 고정 컨트랙트 미생성
    user.taskContractAddress = "0x1234";
    user.taskPort="8081";
    try{
       
        await insertTask(user,(result)=>{
            if(result['type']){
                res.send(result['data']);
            }else{
                res.send(result['data']);
            }
        })
        // 2. spawn을 통해 "python 파이썬파일.py" 명령어 실행
        const result = spawn('python', [path.join(__dirname, '..', '..', '/src/py/flwr/server/server.py')]);
        // 3. stdout의 'data'이벤트리스너로 실행결과를 받는다.
        result.stdout.on('data', function(data) {
            console.log(data.toString());
        });

        // 4. 에러 발생 시, stderr의 'data'이벤트리스너로 실행결과를 받는다.
        result.stderr.on('data', function(data) {
            console.log(data.toString());
        });

    }catch(err){
        res.send(err);
    }
});

router.get('/', async(req, res) => {
    var data = req.body;
    const search = {
        searchText: data.search_text,
        organizationUserId:data.organization_user_id,
        taskStatusCode:data.task_status_code
    }
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