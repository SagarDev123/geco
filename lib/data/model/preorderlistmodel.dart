class PreOrderListModel {
  PreOrderListModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final PreOrderListData? data;

  factory PreOrderListModel.fromJson(Map<String, dynamic> json) {
    return PreOrderListModel(
      message: json["message"],
      status: json["status"],
      data: (json["data"] == null || json['status'] == false)
          ? null
          : PreOrderListData.fromJson(json["data"]),
    );
  }
}

class PreOrderListData {
  PreOrderListData({
    required this.salesData,
    required this.productList,
  });

  final SalesData? salesData;
  final List<ProductList> productList;

  factory PreOrderListData.fromJson(Map<String, dynamic> json) {
    return PreOrderListData(
      salesData: json["sales_data"] == null
          ? null
          : SalesData.fromJson(json["sales_data"]),
      productList: json["product_list"] == null
          ? []
          : List<ProductList>.from(
              json["product_list"]!.map((x) => ProductList.fromJson(x))),
    );
  }
}

class ProductList {
  ProductList({
    required this.soldListId,
    required this.productsId,
    required this.quantity,
    required this.brandId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.brandIdName,
    required this.price,
    required this.tax,
  });

  final String? soldListId;
  final String? productsId;
  final String? quantity;
  final String? brandId;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? brandIdName;
  final String? price;
  final String? tax;

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      soldListId: json["sold_list_id"],
      productsId: json["products_id"],
      quantity: json["quantity"],
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

class SalesData {
  SalesData({
    required this.id,
    required this.billNo,
    required this.date,
    required this.customersId,
    required this.customerName,
  });

  final String? id;
  final String? billNo;
  final String? date;
  final String? customersId;
  final String? customerName;

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      id: json["id"],
      billNo: json["bill_no"],
      date: json["date"],
      customersId: json["customers_id"],
      customerName: json["customer_name"],
    );
  }
}
