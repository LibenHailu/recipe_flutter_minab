import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _httpLink = HttpLink(
  'http://10.6.207.112:8080/v1/graphql',
);

final _authLink = AuthLink(
  getToken: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
    return 'Bearer ${token}';
  },
);

Link _link = _authLink.concat(_httpLink);

final GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: _link,
);
