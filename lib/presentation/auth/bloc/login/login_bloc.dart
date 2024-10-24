import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/auth_remote_data_source.dart';
import 'package:fic12_fe/data/models/request/auth_request_model.dart';
import 'package:fic12_fe/data/models/response/auth_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource dataSource;

  LoginBloc(this.dataSource) : super(const _Initial()) {
    on<_Login>(_doLogin);
  }

  Future<void> _doLogin(
    _Login event,
    Emitter<LoginState> emit,
  ) async {
    emit(const _Loading());
    final result = await dataSource.login(
      authRequestModel: event.authRequestModel,
    );
    result.fold(
      (error) => emit(_Error(message: error)),
      (authResponseModel) => emit(
        _Success(authResponseModel: authResponseModel),
      ),
    );
  }
}
