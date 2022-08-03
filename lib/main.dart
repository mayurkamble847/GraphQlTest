import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final HttpLink httpLink=HttpLink("https://countries.trevorblades.com/");
   final ValueNotifier<GraphQLClient> client=ValueNotifier<GraphQLClient>(
     GraphQLClient(
       link: httpLink ,
       cache: GraphQLCache(
         store: InMemoryStore()
       )
     )
   );
    return GraphQLProvider(
      client: client,
      child: const HomePage(),
    );

  }

}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String query= r"""
  query GetCountries {
    countries{
      name
    }
}
  """;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('List of Countries'),
          elevation: 0,
        ),
        body: Query(
          options: QueryOptions(
              document:gql(query)
          ),
          builder: (
              QueryResult result ,{ VoidCallback? refetch, FetchMore? fetchMore })
          {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            if (result.data == null) {
              return const Text('No repositories');
            }

            return ListView.builder(
                itemCount: result.data!['countries'].length,
                itemBuilder: (context, index) {
                  return SafeArea(child: Card(
                    elevation: 1,
                    child: ListTile(
                        title: Text(result.data!['countries'][index]["name"]?? " ")),
                  ));
                });
          }

        )
      ),
    );
  }
}

