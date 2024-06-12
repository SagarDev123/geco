class ProductModel {
  ProductModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<ProductModelData> data;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<ProductModelData>.from(
              json["data"]!.map((x) => ProductModelData.fromJson(x))),
    );
  }
}

class ProductModelData {
  ProductModelData({
    required this.id,
    required this.brandId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.brandIdName,
    required this.price,
    required this.tax,
  });

  final String? id;
  final String? brandId;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? brandIdName;
  final String? price;
  final String? tax;

  factory ProductModelData.fromJson(Map<String, dynamic> json) {
    return ProductModelData(
      id: json["id"],
      brandId: json["brand_id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
      brandIdName: json["brand_id_name"],
      price: json["price"],
      tax: json["tax"],
    );
  }
}
