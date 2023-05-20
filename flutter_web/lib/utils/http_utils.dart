const String BASE_URL = 'http://tvstorm-ai.asuscomm.com:12300/flower';

final String SUCCESS = "200";


String statusCodeToString(int statusCode){
  switch(statusCode){
    case 0:
      return 'Preparing';
    case 1:
      return 'Progress';
    case 2:
      return 'Done';
    default:
      return '';
  }
}