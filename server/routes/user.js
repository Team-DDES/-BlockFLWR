const express = require('express');
const router = express.Router();
const { insertUser, getUser } = require('../database/mysql');
const {successMessage, failMessage} = require('../utils/mesage');
const UserModel = require('../model/user_model')
router.post('/join', async(req, res) => {
    var data = req.body;
    var user = new UserModel(data);
    try{
        await insertUser(user,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'user insert fail',404);
                    res.send(body);
                }else{
                    var body = successMessage(result['data']);
                    res.send(body);
                }
            }else{
                var body = failMessage(result['data'],'user insert fail',404);
                res.send(body);
            }
        })
    }catch(err){
        var body = failMessage(err,'user insert fail',404);
        res.status(200);
        res.send(body);
    }
});

router.get('/', async(req, res) => {
    var data = req.query;
    console.log(data);
    const user = {
        userAddress: data.userAddress,
    }
    try{
        await getUser(user,(result)=>{
            if(result['type']){
                var data = result['data'];
                if(data == null){
                    var body = failMessage(result['data'],'user not found',403);
                    res.send(body);
                    res.status(200);
                }else{
                    var body = successMessage(result['data']);
                    res.send(body);
                }
                
            }else{
                var body = failMessage(result['data'],'error',404);
                res.status(200);
                res.send(body);
            }
        })
    }catch(err){
        var body = failMessage(err,'error',404);
        res.status(200);
        res.send(body);
    }
});
module.exports = router;