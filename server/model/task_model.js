module.exports  = class TaskModel{
    constructor (data) {
        this.userId = data.userId;
        this.taskName = data.taskName;
        this.taskPurpose = data.taskPurpose;
        this.taskFramework = data.taskFramework;
        this.taskContractAddress = data.taskContractAddress;
        this.taskDataType = data.taskDataType;
        this.taskMaxTrainer = data.taskMaxTrainer;
        this.taskPort = data.taskPort;
        this.taskStatusCode = data.taskStatusCode;
        this.taskId = data.taskId;
        this.dataPath = data.dataPath;
    }
}