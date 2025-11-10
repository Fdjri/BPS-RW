part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.username, 
  });

  final LoginStatus status;
  final String? errorMessage;
  final String? username; 

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? username, 
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username, 
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, username]; 
}