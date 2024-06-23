import 'package:geco/data/model/addtocartsuccessmodel.dart';
import 'package:geco/data/model/customer.dart';
import 'package:geco/data/model/product_model.dart';
import 'package:geco/data/model/producttype.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/model/brand.dart';
import '../data/remote/api_config.dart';

class CreateNewOrderRepository {
  final RemoteDataRepository remoteDataRepository;

  CreateNewOrderRepository({required this.remoteDataRepository});

  Future<dynamic> getCustomerList(String? token) async {
    var requestBody = {
      "utoken": token,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.customerList,
      body: requestBody,
    );
    Customers resp = Customers.fromJson(response);
    return resp;
  }

  Future<dynamic> getBrands(utoken, search) async {
    var requestBody = {"utoken": utoken, 'search': search};
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.branchList,
      body: requestBody,
    );

    Brand resp = Brand.fromJson(response);
    return resp;
  }

  getProductTypes(String? utoken) async {
    var requestBody = {
      "utoken": utoken,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.productTypeList,
      body: requestBody,
    );

    ProductListType resp = ProductListType.fromJson(response);
    return resp;
  }

  getProducts(String? token, List<String> brandId, String productTypeId) async {
    var requestBody = {
      "utoken": token,
      'brand_id': brandId.toString(),
      'product_type_id': productTypeId
    };

    // var requestBody = {
    //   "utoken": token,
    //   'brand_id': brandId,
    //   'product_type_id': productTypeId
    // };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.productList,
      body: requestBody,
    );

    ProductModel resp = ProductModel.fromJson(response);
    return resp;
  }

  addToCart(String? token, String productId, String quanity) async {
    var requestBody = {
      "utoken": token,
      'products_id': productId,
      'quantity': quanity
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.addToCart,
      body: requestBody,
    );

    AddToCartSuccessModel resp = AddToCartSuccessModel.fromJson(response);
    return resp;
  }
}
