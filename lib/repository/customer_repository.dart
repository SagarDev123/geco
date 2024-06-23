import 'package:geco/data/model/customer.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/model/addcustomermodel.dart';
import '../data/model/addtocartsuccessmodel.dart';
import '../data/remote/api_config.dart';

class CustomerRepository {
  final RemoteDataRepository remoteDataRepository;

  CustomerRepository({required this.remoteDataRepository});
  getCustomerList(String? token, String name) async {
    var requestBody = {
      "utoken": token,
      "search": name,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.customerList,
      body: requestBody,
    );

    Customers resp = Customers.fromJson(response);
    return resp;
  }

  addCustomer(String? token, String name, String storeName, String mobileNumber,
      String gstNumber, String address) async {
    var requestBody = {
      "utoken": token,
      "name": name,
      "store_name": storeName,
      "phone": mobileNumber,
      "gstno": gstNumber,
      "address": address,
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.saveCustomer,
      body: requestBody,
    );
    AddCustomerModel resp = AddCustomerModel.fromJson(response);
    return resp;
  }
}
