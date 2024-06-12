class ItemsInCartModel {
  ItemsInCartModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final CardItemData? data;

  factory ItemsInCartModel.fromJson(Map<String, dynamic> json) {
    return ItemsInCartModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? null : CardItemData.fromJson(json["data"]),
    );
  }
}

class CardItemData {
  CardItemData({
    required this.cartList,
    required this.cartData,
  });

  final List<CartList> cartList;
  final CartData? cartData;

  factory CardItemData.fromJson(Map<String, dynamic> json) {
    return CardItemData(
      cartList: json["cart_list"] == null
          ? []
          : List<CartList>.from(
              json["cart_list"]!.map((x) => CartList.fromJson(x))),
      cartData: json["cart_data"] == null
          ? null
          : CartData.fromJson(json["cart_data"]),
    );
  }
}

class CartData {
  CartData({
    required this.total,
    required this.taxable,
    required this.gstamount,
  });

  final double? total;
  final int? taxable;
  final int? gstamount;

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      total: json["total"],
      taxable: json["taxable"],
      gstamount: json["gstamount"],
    );
  }
}

class CartList {
  CartList({
    required this.id,
    required this.productsId,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.brandId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.brandIdName,
  });

  final String? id;
  final String? productsId;
  final String? quantity;
  final String? price;
  final String? tax;
  final String? brandId;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? brandIdName;

  factory CartList.fromJson(Map<String, dynamic> json) {
    return CartList(
      id: json["id"],
      productsId: json["products_id"],
      quantity: json["quantity"],
      price: json["price"],
      tax: json["tax"],
      brandId: json["brand_id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
      brandIdName: json["brand_id_name"],
    );
  }
}
