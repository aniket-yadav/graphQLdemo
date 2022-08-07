import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_strings.dart' as gql_string;

Future<bool> updateUser(
    {String? id, String? name, String? email, String? job}) async {
  HttpLink link = HttpLink("http://10.0.2.2:4000/graphql"); // same link 
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );
  QueryResult queryResult = await qlClient.mutate( // mutate method , as we are mutating value
    MutationOptions( // mutation options
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.updateUserMutation,
        ),
        variables: {
          "id": int.tryParse(id ?? ''), // it takes int so converting
          'name': name,
          'email': email,
          'job_title': job,
        }),
  );

  return queryResult.data?['updateUserInfo'] ?? false; // here i get response in updateUserInfo as true or false
}
