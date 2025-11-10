import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (username == 'grogol7' && password == 'User123') {
        emit(state.copyWith(
          status: LoginStatus.success,
          username: username, 
        ));
      } else if (username.isEmpty || password.isEmpty) {
         emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Username dan password tidak boleh kosong',
          username: null, 
        ));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Username atau password salah. Silahkan cek lagi.',
          username: null, 
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Error tidak dikenal: $e',
        username: null, 
      ));
    }
  }
}