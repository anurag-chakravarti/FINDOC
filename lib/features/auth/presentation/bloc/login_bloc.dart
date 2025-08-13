import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/prefs.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.loading));
      // Simulate latency; plug real API here later if needed.
      await Future.delayed(const Duration(milliseconds: 650));
      await Prefs.saveToken('token_${DateTime.now().millisecondsSinceEpoch}');
      emit(state.copyWith(status: LoginStatus.success));
    });
  }
}