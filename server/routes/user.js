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
    const user = {
        userAddress: data.user_address,
    }
    try{
        await getUser(user,(result)=>{
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