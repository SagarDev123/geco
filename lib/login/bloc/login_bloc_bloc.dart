import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geco/data/model/user.dart';
import 'package:geco/repository/login_repository.dart';
import 'package:geco/utils/sharedpreferencehelper.dart';
import 'package:meta/meta.dart';

import '../../data/remote/exceptions.dart';
import '../../utils/constants.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBlocBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginRepository loginRepository;
  LoginBlocBloc({required this.loginRepository}) : super(LoginBlocInitial()) {
    on<LoginBlocEvent>((event, emit) {});
    on<OnUsernameChange>(
      (event, emit) {
        emit(LoginCredentialValidationState(isValid: true, message: ""));
      },
    );
    on<OnPasswordChange>(
      (event, emit) {
        emit(LoginCredentialValidationState(isValid: true, message: ""));
      },
    );
    on<OnLoginButtonClick>(
      (event, emit) async {
        try {
          emit(LoginApiLoading());
          User user =
              await loginRepository.loginUser(event.username, event.password);
          if (user.status != null && user.status == true) {
            emit(LoginSuccessState(message: Constants.loginSuccessMessage));
            SharedPreferenceHelper.saveContent(user);
          } else {
            emit(LoginApiFailure(error: user.message!));
          }
        } on SocketException catch (error) {
          emit(LoginApiFailure(error: Constants.NO_CONNECTION));
        } on ApiErrorException catch (error) {
          emit(LoginApiFailure(error: error.message.toString()));
        } catch (error) {
          emit(LoginApiFailure(error: 'Something went wrong'));
        }
      },
    );
  }
}
