import 'package:geco/data/model/brand.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/remote/api_config.dart';

class DashboardRepository {
  RemoteDataRepository remoteDataRepository = RemoteDataRepository();
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
