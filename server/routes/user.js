const express = require('express');
const router = express.Router();
const { insertUser } = require('../database/mysql');
router.post('/', async(req, res) => {
    var data = req.body;
    const user = {
        userType: data.user_type,
        userName: data.user_name,
        userAddress: data.user_address,
        userSign: data.user_sign,
        userEmail: data.user_email,
        userPhone: data.user_phone
    }
    try{
        await insertUser(user,(result)=>{
            if(result['type']){
                res.send(result['message']);
            }else{
                res.send(result['message']);
            }
        })
    }catch(err){
        res.send(err);
    }
});

module.exports = router;