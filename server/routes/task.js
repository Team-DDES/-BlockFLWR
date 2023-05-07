const express = require('express');
const router = express.Router();
const { insertTask, getUser } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const TaskModel = require('../model/task_model');
router.post('/', async(req, res) => {
    var data = req.body;
    var user = new TaskModel(data);
    user.taskStatusCode = 0;

    //TODO 빈포트 찾고 smartcontact 생성 시작
    user.taskContractAddress = "0x1234";
    user.taskPort="8824";
    try{
        await insertTask(user,(result)=>{
            if(result['type']){
                res.send(result['data']);
            }else{
                res.send(result['data']);
            }
        })
    }catch(err){
        res.send(err);
    }
});

router.get('/', async(req, res) => {
    var data = req.body;
    const search = {
        searchText: data.search_text,
        userId:data.user_id,
        taskStatusCode:data.task_status_code
    }
    try{
        await getTask(search,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'user not found',404);
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