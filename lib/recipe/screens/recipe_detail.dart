import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:minabapp/recipe/screens/add_update_recipe.dart';
import '../recipe.dart';
import '../../config/client.dart';

class RecipeDetail extends StatelessWidget {
  static const routeName = 'recipeDetail';
  final Recipe recipe;

  RecipeDetail({@required this.recipe});
  @override
  Widget build(BuildContext context) {
    const String readIngredients = r'''
  query MyQuery($where: ingredients_bool_exp) {
  ingredients(where:$where){
    id
    name
    recipe_id
  }
}
''';

    final int recipe_id = recipe.id;
    print(recipe_id);
    final QueryOptions options = QueryOptions(
      document: gql(readIngredients),
      variables: {
        "where": {
          "recipe_id": {"_eq": recipe_id}
        }
      },
    );
// final QueryResult result = await client.query(options);

// if (result.hasException) {
//   print(result.exception.toString());
// }

// final List<dynamic> repositories =
//     result.data['viewer']['repositories']['nodes'] as List<dynamic>;

// ...
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              AddUpdateRecipe.routeName,
              arguments: RecipeArgument(recipe: this.recipe, edit: true),
            ),
          ),
          SizedBox(
            width: 32,
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // context.read<CourseBloc>().add(CourseDelete(this.course));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     CoursesList.routeName, (route) => false);
              }),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '${recipe.name}',
                          style: TextStyle(
                            fontSize: 25,
                            // color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            'http://10.6.207.112:3000/${recipe.filePath}' ??
                                'http://placehold.it/100x100'),
                        fit: BoxFit.cover
                        // image: AssetImage('images/Liben.jpg'),
                        ),
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '${recipe.description}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.blueGrey),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 25,
                // color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder(
            // Initialize FlutterFire:
            future: client.query(options),
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                // return 'sad';
                print(snapshot.error);
              }
              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data.data['ingredients']);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var ingredient
                          in snapshot.data.data['ingredients']) ...[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                '- ${ingredient['name']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.blueGrey),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ],
                  ),
                );
              }
              // Otherwise, show something whilst waiting for initialization to complete
              return Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()));
            },
          )
        ],
      ),
    );
  }
}
