import 'package:meta/meta.dart';

import '../recipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({@required this.recipeRepository})
      : assert(recipeRepository != null),
        super(RecipeLoading());

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is RecipeLoad) {
      yield RecipeLoading();
      try {
        final recipes = await recipeRepository.getRecipes();
        yield RecipeLoadSuccess(recipes);
      } catch (err) {
        print(err);
        yield RecipeOperationFailure();
      }
    }

    if (event is RecipeCreate) {
      try {
        Recipe recipe = await recipeRepository.createRecipe(event.recipe);
        print(recipe);
        final recipes = await recipeRepository.getRecipes();
        yield RecipeLoadSuccess(recipes);
      } catch (_) {
        yield RecipeOperationFailure();
      }
    }

    // if (event is CourseUpdate) {
    //   try {
    //     await courseRepository.updateCourse(event.course);
    //     final courses = await courseRepository.getCourses();
    //     yield CoursesLoadSuccess(courses);
    //   } catch (_) {
    //     yield CourseOperationFailure();
    //   }
    // }

    // if (event is CourseDelete) {
    //   try {
    //     await courseRepository.deleteCourse(event.course.id);
    //     final courses = await courseRepository.getCourses();
    //     yield CoursesLoadSuccess(courses);
    //   } catch (_) {
    //     yield CourseOperationFailure();
    //   }
    // }
  }
}
