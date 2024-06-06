part of 'login_bloc_bloc.dart';

@immutable
sealed class LoginBlocEvent {}

class OnUsernameChange extends LoginBlocEvent {
  final String username;
  OnUsernameChange({required this.username});
}

class OnPasswordChange extends LoginBlocEvent {
  final String password;
  OnPasswordChange({required this.password});
}

class OnLoginButtonClick extends LoginBlocEvent {
  final String password;
  final String username;
  OnLoginButtonClick({required this.username, required this.password});
}
