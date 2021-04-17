import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minabapp/recipe/screens/add_update_recipe.dart';
import '../recipe.dart';

class RecipeList extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(
          'Recipes',
          // style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AddUpdateRecipe.routeName,
              arguments: RecipeArgument(edit: false),
            ),
            icon: Icon(
              CupertinoIcons.plus_rectangle_fill,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (_, state) {
          if (state is RecipeOperationFailure) {
            return Text('Could not do recipe operation');
          }

          if (state is RecipeLoadSuccess) {
            final recipes = state.recipes;

            return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (_, idx) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                        RecipeDetail.routeName,
                        arguments: recipes[idx]),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'http://10.6.207.112:3000/${recipes[idx].filePath}' ??
                                          'http://placehold.it/100x100'),
                                  fit: BoxFit.cover
                                  // image: AssetImage('images/Liben.jpg'),
                                  ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${recipes[idx].name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${recipes[idx].description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                          SizedBox(height: 5),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
