import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_strings.dart' as gql_string;

Future<List> getAllUsers() async {
  HttpLink link = HttpLink("http://10.0.2.2:4000/graphql"); // this is api call for getting all users
  GraphQLClient qlClient = GraphQLClient( // same client create
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );
  QueryResult queryResult = await qlClient.query( // here it's get type so using query method 
    QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(
        gql_string.getAllUsersQuery, // let's see query string
      ),
    ),
  );

return queryResult.data?['getUsers'] ?? []; // here i am getting list in getUsers field which i am return 
}
