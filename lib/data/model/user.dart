class User {
  bool? status;
  String? message;
  Data? data;

  User({this.status, this.message, this.data});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? address;
  String? phone;
  String? email;
  String? access;
  String? imageUrl;
  String? utoken;

  Data(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.email,
      this.access,
      this.imageUrl,
      this.utoken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    access = json['access'];
    imageUrl = json['image_url'];
    utoken = json['utoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['access'] = this.access;
    data['image_url'] = this.imageUrl;
    data['utoken'] = this.utoken;
    return data;
  }
}
