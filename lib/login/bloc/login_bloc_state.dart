part of 'login_bloc_bloc.dart';

@immutable
sealed class LoginBlocState {}

final class LoginBlocInitial extends LoginBlocState {}

class LoginCredentialValidationState extends LoginBlocState {
  final bool isValid;
  final String message;
  LoginCredentialValidationState(
      {required this.isValid, required this.message});
}

class LoginApiLoading extends LoginBlocState {}

class LoginApiFailure extends LoginBlocState {
  final String error;
  LoginApiFailure({required this.error});
}

class LoginSuccessState extends LoginBlocState {
  final String message;
  LoginSuccessState({required this.message});
}
