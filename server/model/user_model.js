 module.exports  = class UserModel{
    constructor (data) {
        this.userType = data.userType;
        this.userName = data.userName;
        this.userAddress = data.userAddress;
        this.userSign = data.userSign;
        this.userEmail = data.userEmail;
        this.userPhone = data.userPhone;
    }
}