import 'package:geco/data/model/user.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/remote/api_config.dart';

class LoginRepository {
  RemoteDataRepository remoteDataRepository = RemoteDataRepository();

  Future<dynamic> loginUser(username, password) async {
    var apiQuerymap = Map<String, dynamic>();
    apiQuerymap.putIfAbsent("phone", () => username);
    apiQuerymap.putIfAbsent("time", () => password);
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.login,
      param: apiQuerymap,
    );
    User resp = User.fromJson(response);
    return resp;
  }
}
