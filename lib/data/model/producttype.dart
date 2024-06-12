class ProductListType {
  ProductListType({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<ProductTypeDatum> data;

  factory ProductListType.fromJson(Map<String, dynamic> json) {
    return ProductListType(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<ProductTypeDatum>.from(
              json["data"]!.map((x) => ProductTypeDatum.fromJson(x))),
    );
  }
}

class ProductTypeDatum {
  ProductTypeDatum({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;

  factory ProductTypeDatum.fromJson(Map<String, dynamic> json) {
    return ProductTypeDatum(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
    );
  }
}
