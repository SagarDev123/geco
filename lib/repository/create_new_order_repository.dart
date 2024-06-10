import 'package:geco/data/model/customer.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/model/brand.dart';
import '../data/remote/api_config.dart';

class CreateNewOrderRepository {
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

  Future<dynamic> getBrands(utoken) async {
    var requestBody = {
      "utoken": utoken,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.branchList,
      body: requestBody,
    );
    print(response);
    Brand resp = Brand.fromJson(response);
    return resp;
  }
}
