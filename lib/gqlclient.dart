import 'package:graphql/client.dart';
import 'constants.dart';

Future<GraphQLClient> getGraphQLClient() async {
  final Link _link = HttpLink(
    "http://localhost:4000/",
    defaultHeaders: {
      // ignore: undefined_identifier
      //'Authorization': 'Bearer ${Constants.p_a_t}',
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InRva2VuIjoiMWYxNTkyOTA0N2U4YTAxNDZiNzY4ZTE3NjY1NTA3YTYyYjMwNDBjZGY4YjI5NjQ2YjdhYmU2M2ZhODhjMjIwZWE1ZTRmZGVjYjJlODk5NTZhNzc4YmYiLCJpc0ltcGVyc29uYXRlZCI6ZmFsc2UsInVzZXJJZCI6IjYwNzcwMmRjMjgwYjMwMTNmYTFiODU5YyJ9LCJpYXQiOjE2MTg0MTIyNTIsImV4cCI6MTYxODQxNzY1Mn0.X9QPj-4SpaT1C-Dj9IjlljCO-ugvaglLdBvV87EU4G8"
    },
  );
  final store = await HiveStore.open(path: './ta3awon');
  return GraphQLClient(
    cache: GraphQLCache(store: store),
    link: _link,
  );
}

GraphQLClient getClient() {
  GraphQLClient lclient;
  getGraphQLClient().then((value) {
    lclient = value;
  });
  return lclient;
}

class GqlClient {
  static GraphQLClient client;

  Future<dynamic> getHarvestByOwner() async {
    client = await getGraphQLClient();
    if (client == null) {
      print(" null");
    } else {
      print("not null ccccccccclient");
    }
    ;
    print("helloooooooooooooooo world1");
    QueryOptions options = QueryOptions(document: gql(r'''query 
    {getHarvestByOwner(ownerId:"60baa02add964433341b421a")
    {startDate
     harvestDate
     harvestQuantity
     harvestDetail{title}
     farmHarvest {title}}}'''));

    QueryResult result = await client.query(options);
    print("helloooooooooooooooo world");
    dynamic l = result.data['getHarvestByOwner'];

    print(l[0]);
    return l;
  }
}
