module.exports  = class TaskModel{
    constructor (data) {
        this.userId = data.user_id;
        this.taskName = data.task_name;
        this.taskPurpose = data.task_purpose;
        this.taskFramework = data.task_framework;
        this.taskContractAddress = data.task_contract_address;
        this.taskDataType = data.task_data_type;
        this.taskMaxTrainer = data.task_max_trainer;
        this.taskPort = data.task_port;
        this.taskStatusCode = data.task_status_code;
    }
}