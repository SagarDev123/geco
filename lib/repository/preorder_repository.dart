import 'package:geco/data/model/preorderlistmodel.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/model/addtocartsuccessmodel.dart';
import '../data/model/customer.dart';
import '../data/remote/api_config.dart';

class PreOrderRepository {
  RemoteDataRepository remoteDataRepository = RemoteDataRepository();

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

  Future<dynamic> getPreviiousOrder(
      String? token, String customerId, String brandId) async {
    var requestBody = {
      "utoken": token,
      "customers_id": customerId,
      'brand_id': brandId
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.previousOrder,
      body: requestBody,
    );

    print(response);

    PreOrderListModel resp = PreOrderListModel.fromJson(response);
    return resp;
  }

  Future<dynamic> reOrderSales(String? token, String salesId) async {
    var requestBody = {
      "utoken": token,
      "sales_id": salesId,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.reOrder,
      body: requestBody,
    );
    AddToCartSuccessModel resp = AddToCartSuccessModel.fromJson(response);
    return resp;
  }
}
