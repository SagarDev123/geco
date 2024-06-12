class AddToCartSuccessModel {
  AddToCartSuccessModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<dynamic> data;

  factory AddToCartSuccessModel.fromJson(Map<String, dynamic> json) {
    return AddToCartSuccessModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<dynamic>.from(json["data"]!.map((x) => x)),
    );
  }
}
