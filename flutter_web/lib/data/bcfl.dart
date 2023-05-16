//TODO BCFL 관련 서버 response interface
import 'package:json_annotation/json_annotation.dart';

part 'bcfl.g.dart';

@JsonSerializable()
class BCFL {
  final String idx;
  final String taskName;
  final String owner;
  final String participants;
  final String intro;
  final String email;
  final String phone;
  final String framework;
  final String tokenSupply;
  final String dataType;
  final String purpose;
  final String role;
  final String status;
  final String address;

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
    required this.status,
    required this.address,
  });

  bool containKeyword(String keyword) {
    return taskName.contains(keyword) ||
        owner.contains(keyword) ||
        role.contains(keyword);
  }

  factory BCFL.fromJson(Map<String, dynamic> json) => _$BCFLFromJson(json);
  Map<String, dynamic> toJson() => _$BCFLToJson(this);
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
  status: "Training",
  address: "0x123456789",
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
    status: "Training",
    address: "0x123456789",
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
    status: "Training",
    address: "0x123456789",
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
    status: "Training",
    address: "0x123456789",
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
