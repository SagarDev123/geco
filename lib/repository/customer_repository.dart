import 'package:geco/data/model/customer.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/remote/api_config.dart';

class CustomerRepository {
  RemoteDataRepository remoteDataRepository = RemoteDataRepository();
  getCustomerList(String? token) async {
    var requestBody = {
      "utoken": token,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.customerList,
      body: requestBody,
    );
    print(response);
    Customers resp = Customers.fromJson(response);
    return resp;
  }
}
