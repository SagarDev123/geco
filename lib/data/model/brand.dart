class Brand {
  Brand({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<BrandData> data;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<BrandData>.from(
              json["data"]!.map((x) => BrandData.fromJson(x))),
    );
  }
}

class BrandData {
  BrandData({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;

  factory BrandData.fromJson(Map<String, dynamic> json) {
    return BrandData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
    );
  }
}
