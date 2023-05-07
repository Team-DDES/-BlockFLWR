function successMessage(data, message, code){
    var body = {};
    var result = {};
    body['data'] = data;
    result['message'] = 'success';
    result['code'] = '200';
    body['result'] = result;

    return body;

}

function failMessage(data, message, code){
    var body = {};
    var result = {};
    body['data'] = data;
    result['message'] = message;
    result['code'] = code;
    body['result'] = result;

    return body;

}

module.exports = {
    successMessage,
    failMessage
}