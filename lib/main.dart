import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './services/auth.dart';
import './bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './recipe/recipe.dart';

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();

  final RecipeRepository recipeRepository = RecipeRepository(
    dataProvider: RecipeDataProvider(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.get('token');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<RecipeBloc>(
        create: (BuildContext context) =>
            RecipeBloc(recipeRepository: recipeRepository)..add(RecipeLoad()),
      ),
    ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token == null ? SimpleRegisterScreen() : RecipeList(),
      onGenerateRoute: RecipeAppRoute.generateRoute,
    ),
  ));
}

// void onSubmit(String email, String password) {
//   hasuraAuth.signup(email, password);
//   Navigator.push(context, MaterialPageRoute(builder: => Welcome();))
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SimpleRegisterScreen(onSubmitted: (String email, String password) {
//         hasuraAuth.signup(email, password);
//       }),
//     );
//   }
// }
