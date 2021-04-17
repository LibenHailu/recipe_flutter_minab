import 'package:graphql/client.dart';
import './shared_preferences_service.dart';

final _httpLink =
    HttpLink('http://10.6.207.112:8080/v1/graphql', defaultHeaders: {
  "content-type": "application/json",
  "x-hasura-admin-secret": "myadminsecretkey",
});

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _httpLink,
);

class HasuraAuth {
  Future<bool> signup(String email, String password) async {
    const addUser = r'''
    mutation MyMutation($email:String!,$password:String!){
      signup(email: $email, password: $password) {
        email
        id
        password
        token
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(addUser),
      variables: <String, dynamic>{'email': email, 'password': password},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }

    String token = result.data['signup']['token'];
    print(token);
    if (token.isNotEmpty) {
      await sharedPreferenceService.setToken(result.data['signup']['token']);
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    const loginUser = r'''
    mutation MyMutation($email:String!,$password:String!){
      login(email: $email, password: $password) {
        email
        id
        password
        token
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(loginUser),
      variables: <String, dynamic>{'email': email, 'password': password},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }

    String token = result.data['login']['token'];
    print(token);
    if (token.isNotEmpty) {
      await sharedPreferenceService.setToken(result.data['login']['token']);
    }

    return true;
  }
}

HasuraAuth hasuraAuth = new HasuraAuth();
