import 'package:graphql/client.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<GraphQLClient> getGraphQLClient() async {
  String hostName;
  String documentDirectory;
  if (kIsWeb) {
    // running on the web!
    hostName = "http://localhost:4000/";
    documentDirectory = '.';
  } else {
    // NOT running on the web! You can check for additional platforms here.
    hostName = "http://10.0.2.2:4000/";
    documentDirectory = (await getApplicationSupportDirectory()).path;
  }
  final Link _link = HttpLink(
    hostName,
    defaultHeaders: {
      // ignore: undefined_identifier
      //'Authorization': 'Bearer ${Constants.p_a_t}',
      "Authorization":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InRva2VuIjoiMWYxNTkyOTA0N2U4YTAxNDZiNzY4ZTE3NjY1NTA3YTYyYjMwNDBjZGY4YjI5NjQ2YjdhYmU2M2ZhODhjMjIwZWE1ZTRmZGVjYjJlODk5NTZhNzc4YmYiLCJpc0ltcGVyc29uYXRlZCI6ZmFsc2UsInVzZXJJZCI6IjYwNzcwMmRjMjgwYjMwMTNmYTFiODU5YyJ9LCJpYXQiOjE2MTg0MTIyNTIsImV4cCI6MTYxODQxNzY1Mn0.X9QPj-4SpaT1C-Dj9IjlljCO-ugvaglLdBvV87EU4G8"
    },
  );
  // final documentDirectory = (Directory.systemTemp).path;

  //final documentDirectory = '.';

  //final documentDirectory = (await getApplicationSupportDirectory()).path;

  //print(documentDirectory);
  // Hive.initFlutter(documentDirectory.path);
  // Hive.initFlutter("/test");
  final store = await HiveStore.open(path: documentDirectory + "/ta3awon");

  //Hive.initHiveForFlutter();

  // (path: pth + '/ta3awon1');
  return GraphQLClient(
    cache: GraphQLCache(store: store),
    link: _link,
  );
}

class GqlClient {
  static GraphQLClient client;

  static Future<dynamic> getHarvestByOwner() async {
    if (client == null) {
      client = await getGraphQLClient();
    }

    QueryOptions options = QueryOptions(document: gql(r'''query 
    {getHarvestByOwner(ownerId:"60baa02add964433341b421a")
    {startDate
     harvestDate
     harvestQuantity
     harvestDetail{title}
     farmHarvest {title}}}'''), fetchPolicy: FetchPolicy.networkOnly);

    QueryResult result = await client.query(options);

    dynamic l = result.data['getHarvestByOwner'];

    print("getHarvestByOwner:${l[0]}");
    return l;
  }

  static Future<dynamic> getFarmByOwner() async {
    if (client == null) {
      client = await getGraphQLClient();
    }

    QueryOptions options = QueryOptions(document: gql(r'''query {
  getFarmByOwner (ownerId:"60baa02add964433341b421a")
  {id
  title
  address
  }
    }'''), fetchPolicy: FetchPolicy.networkOnly);

    QueryResult result = await client.query(options);

    dynamic l = result.data['getFarmByOwner'];

    print("getFarmByOwner:${l[0]}");
    return l;
  }
}
