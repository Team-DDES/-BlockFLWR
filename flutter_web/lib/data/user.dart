class User {
  var userName = "@ID";
  var userType = "part";
  var isConnect = true;

  User(
      {required this.userName,
      required this.userType,
      required this.isConnect});
}

User dummyUser = User(
  userName: "@ID",
  userType: "part",
  isConnect: true,
);

User dummyOrgUser = User(
  userName: "@ID",
  userType: "org",
  isConnect: true,
);
