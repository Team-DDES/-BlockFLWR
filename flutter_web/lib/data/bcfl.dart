//TODO BCFL 관련 서버 response interface
class BCFL {
  var idx;
  var taskName;
  var owner;
  var participants;
  var intro;
  var email;
  var phone;
  var framework;
  var tokenSupply;
  var dataType;
  var purpose;
  var role;
  BCFL({
    required this.idx,
    required this.taskName,
    required this.owner,
    required this.participants,
    required this.intro,
    required this.email,
    required this.phone,
    required this.framework,
    required this.tokenSupply,
    required this.dataType,
    required this.purpose,
    required this.role,
  });

  bool containKeyword(String keyword) {
    return taskName.contains(keyword) ||
        owner.contains(keyword) ||
        role.contains(keyword);
  }
}

BCFL copyBCFL = BCFL(
  idx: "1",
  taskName: "Cat, dog classification model",
  owner: "ABC inc",
  participants: "12/50",
  intro:
      "Our company wants to make dog and cat classification models into federated learning. Participate in our work to earn tokens and redistribute revenue.",
  email: "abc@gmail.com",
  phone: "+820101234987",
  framework: "Tensorflow",
  tokenSupply: "123145142" + " FLT",
  dataType: "256x256 RGB image(Jpeg only)",
  purpose: "Image classification",
  role: "Trainer",
);

List<BCFL> dummyBCFLList = [
  BCFL(
    idx: "1",
    taskName: "Cat, dog classification model",
    owner: "ABC inc",
    participants: "12/50",
    intro:
        "Our company wants to make dog and cat classification models into federated learning. Participate in our work to earn tokens and redistribute revenue.",
    email: "abc@gmail.com",
    phone: "+820101234987",
    framework: "Tensorflow",
    tokenSupply: "123145142" + " FLT",
    dataType: "256x256 RGB image(Jpeg only)",
    purpose: "Image classification",
    role: "Trainer",
  ),
  BCFL(
    idx: "2",
    taskName: "Handwriting classification model",
    owner: "MNIST",
    participants: "12/50",
    intro:
        "Our company wants to make dog and cat classification models into federated learning. Participate in our work to earn tokens and redistribute revenue.",
    email: "abc@gmail.com",
    phone: "+820101234987",
    framework: "Tensorflow",
    tokenSupply: "123145142" + " FLT",
    dataType: "256x256 RGB image(Jpeg only)",
    purpose: "Image classification",
    role: "Evaluator",
  ),
  BCFL(
    idx: "3",
    taskName: "Create Wallet",
    owner: "D-DES",
    participants: "12/50",
    intro:
        "Our company wants to make dog and cat classification models into federated learning. Participate in our work to earn tokens and redistribute revenue.",
    email: "abc@gmail.com",
    phone: "+820101234987",
    framework: "Tensorflow",
    tokenSupply: "123145142" + " FLT",
    dataType: "256x256 RGB image(Jpeg only)",
    purpose: "Image classification",
    role: "Trainer",
  ),
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
  copyBCFL,
];
