import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_strings.dart' as gql_string;

Future<bool> createUser({String? name, String? email, String? job}) async {
  HttpLink link = HttpLink("http://10.0.2.2:4000/graphql"); // it's my url
  GraphQLClient qlClient = GraphQLClient( // craete a graphql client
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  ); // ignore , just for cacheing
  QueryResult queryResult = await qlClient.mutate( // use mutate method for mutation
    MutationOptions( // we use mutation options
        fetchPolicy: FetchPolicy.networkOnly,// you can use different policy as per your need
        document: gql(
          gql_string.createUserMutation, // as tou graphql need query string 
        ),
        variables: {
          'name': name, // this is have you pass value for varible
          'email': email,
          'job_title': job, 
        }),
  );

  return queryResult.data?['createUser'] ?? false; // queryResult.data contains response data here after creation my api return true
  //  and if it's null then i am return false 
}
