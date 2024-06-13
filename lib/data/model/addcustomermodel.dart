class AddCustomerModel {
  AddCustomerModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final AddCustomerData? data;

  factory AddCustomerModel.fromJson(Map<String, dynamic> json) {
    return AddCustomerModel(
      message: json["message"],
      status: json["status"],
      data:
          json["data"] == null ? null : AddCustomerData.fromJson(json["data"]),
    );
  }
}

class AddCustomerData {
  AddCustomerData({
    required this.id,
  });

  final int? id;

  factory AddCustomerData.fromJson(Map<String, dynamic> json) {
    return AddCustomerData(
      id: json["id"],
    );
  }
}
