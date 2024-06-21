import 'package:geco/data/model/user.dart';
import 'package:geco/repository/remotedatarepository.dart';

import '../data/remote/api_config.dart';

class LoginRepository {
  final RemoteDataRepository remoteDataRepository;

  LoginRepository({required this.remoteDataRepository});

  Future<dynamic> loginUser(username, password) async {
    var requestBody = {
      "username": username,
      "password": password,
      "device_id": "5645gfhfdfs"
    };
    Map<String, dynamic> response =
        await remoteDataRepository.requestRemotePost(
      endpoint: Config.login,
      body: requestBody,
    );

    User resp = User.fromJson(response);
    return resp;
  }
}
