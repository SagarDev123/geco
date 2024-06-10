class Customers {
  Customers({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<Datum> data;

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.gstno,
    required this.storeName,
  });

  final String? id;
  final String? name;
  final String? address;
  final String? email;
  final String? phone;
  final String? gstno;
  final String? storeName;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      email: json["email"],
      phone: json["phone"],
      gstno: json["gstno"],
      storeName: json["store_name"],
    );
  }
}
