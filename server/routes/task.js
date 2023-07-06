const express = require('express');
const router = express.Router();
const { insertTask, getTask, insertTaskParticipate, getTaskUserCount,getTaskDetail} = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const TaskModel = require('../model/task_model');
const {createTaskContract} = require('../web3/alchemy-sdk');
const path = require("path");
const spawn = require('child_process').spawn;

const nftContractAddress = '0xe62F3C05D076ddd787A68a903DdAa0B65FAe5e58';
const pythonPath = '/usr/bin/python3';
const clientPyPath = 'examples/quickstart_pytorch_ethereum/client.py';

router.post('/', async(req, res) => {
    var data = req.body;
    var task = new TaskModel(data);
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
    }catch(err){
        res.send(err);
    }
});

router.post('/participate', async(req, res) => {
    
    var data = req.body;
    var task = new TaskModel(data);
    try{
        var data = await getTaskDetail(task,async(result)=>{
            var _taskData = result['data'][0];
            var _task = task;

            await getTaskUserCount(_task, async(result)=>{
                var count = result['data'][0]['count'];
                var __task = _task;
                var __taskData = _taskData;
                var __nftContractAddress = nftContractAddress;
                runClient(_taskData['taskContractAddress'], __nftContractAddress, count, __taskData['taskPort']);

                await insertTaskParticipate(__task,(result)=>{
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

            });   
        });

    }catch(err){
        res.send(err);
    }
});

function runClient(taskContractAddress, nftContractAddress, count, port){

    const result = spawn(pythonPath, [path.join(__dirname, '..', '..', clientPyPath),'0.0.0.0:'+port,Number(count),taskContractAddress,nftContractAddress,"Mnist"]);

    result.stdout.on('data', function(data) {
        console.log("get Data");
        console.log(data.toString());
    });

    result.stderr.on('data', function(data) {
        console.log("get error");
        console.log(data.toString());
    });
}

router.get('/', async(req, res) => {
    var data = req.query;
    console.log(data);
    const search = {
        searchText: data.searchText==undefined?null:data.searchText,
        organizationUserId:data.organizationUserId==undefined?null:data.organizationUserId,
        taskStatusCode:data.taskStatusCode==undefined?null:data.taskStatusCode,
        trainerUserId:data.trainerUserId==undefined?null:data.trainerUserId,
        taskId:data.taskId==undefined?null:data.taskId,
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
                res.status(200);
                res.send(result['data']);
            }
        })
    }catch(err){
        res.send(err);
    }
});
module.exports = router;
