 module.exports  = class UserModel{
    constructor (data) {
        this.userType = data.user_type;
        this.userName = data.user_name;
        this.userAddress = data.user_address;
        this.userSign = data.user_sign;
        this.userEmail = data.user_email;
        this.userPhone = data.user_phone;
    }
}