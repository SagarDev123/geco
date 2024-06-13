import 'package:geco/data/model/itemsincartmodel.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/model/addtocartsuccessmodel.dart';
import '../data/model/customer.dart';
import '../data/remote/api_config.dart';

class ViewCartRepository {
  RemoteDataRepository remoteDataRepository = RemoteDataRepository();
  Future<dynamic> getItemFromCart(String? token) async {
    var requestBody = {
      "utoken": token,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.cartList,
      body: requestBody,
    );
    ItemsInCartModel resp = ItemsInCartModel.fromJson(response);
    return resp;
  }

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

  Future<dynamic> removeCartItem(
      String? token, String productId, String quanity, String id) async {
    var requestBody = {
      "utoken": token,
      'products_id': productId,
      'quantity': quanity,
      'id': id
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.addToCart,
      body: requestBody,
    );

    AddToCartSuccessModel resp = AddToCartSuccessModel.fromJson(response);
    return resp;
  }

  Future<dynamic> orderNow(String? token, String customersId) async {
    var requestBody = {
      "utoken": token,
      'customers_id': customersId,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.orderNow,
      body: requestBody,
    );

    AddToCartSuccessModel resp = AddToCartSuccessModel.fromJson(response);
    return resp;
  }
}
