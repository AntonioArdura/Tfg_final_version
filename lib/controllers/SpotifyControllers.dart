import 'package:rxdart/rxdart.dart';
import 'package:tfg_v1/models/AuthorizationModel.dart';
import 'package:tfg_v1/repository/repository.dart';

class AuthorizationBloc {
  final _repository = RepositoryAuthorization();

  final PublishSubject<AuthorizationModel> _authorizationTokenFetcher =
      PublishSubject<AuthorizationModel>();
  final PublishSubject<String> _authorizationCodeFetcher =
      PublishSubject<String>();

  Stream<String> get authorizationCode => _authorizationCodeFetcher.stream;
  Stream<AuthorizationModel> get authorizationToken =>
      _authorizationTokenFetcher.stream;

  fetchAuthorizationCode() async {
    String? code = await _repository.fetchAuthorizationCode();
    _authorizationCodeFetcher.sink.add(code!);
  }

  fetchAuthorizationToken(String code) async {
    AuthorizationModel authorizationModel =
        await _repository.fetchAuthorizationToken(code);
    _authorizationTokenFetcher.sink.add(authorizationModel);
  }

  disposeCode() {
    _authorizationCodeFetcher.close();
  }

  disposeToken() {
    _authorizationTokenFetcher.close();
  }
}

final AuthorizationBloc authorizationBloc = AuthorizationBloc();
