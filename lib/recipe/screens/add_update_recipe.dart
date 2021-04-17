import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../recipe.dart';
import 'package:image_picker/image_picker.dart';

class AddUpdateRecipe extends StatefulWidget {
  static const routeName = 'recipeAddUpdate';

  final RecipeArgument args;

  AddUpdateRecipe({this.args});

  @override
  _AddUpdateRecipeState createState() => _AddUpdateRecipeState();
}

class _AddUpdateRecipeState extends State<AddUpdateRecipe> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _recipe = {};
  File _image;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.args.edit ? "Edit Recipe" : "Add New Recipe"}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    // initialValue: widget.args.edit ? widget.args.course.code : '',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter recipe name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'recipe name'),
                    onSaved: (value) {
                      setState(() {
                        this._recipe["recipeName"] = value;
                      });
                    }),
                TextFormField(
                    // initialValue:
                    //     widget.args.edit ? widget.args.recipe.title : '',
                    minLines: 3,
                    maxLines: null,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter recipe description';
                      }
                      return null;
                    },
                    decoration:
                        InputDecoration(labelText: 'Recipe Description'),
                    onSaved: (value) {
                      this._recipe["recipeDescription"] = value;
                    }),
                SizedBox(
                  height: 20,
                ),
                Container(
//                              alignment: Align,
//                              width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withAlpha(100)),
                  child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await getImage();

                        this._recipe["asset"] = _image;
                      }),
                ),
                Container(
                  child:
                      // widget.args.edit && _image == null? Container(
                      //     height: 100, width: 100, child: Image.network(
                      //   'http://$Host/assets/attachedfiles/${widget.args.house.asset}',
                      // )):
                      _image == null
                          ? Text('No image selected.')
                          : Container(
                              height: 100,
                              width: 100,
                              child: Image.file(_image)),
                ),
                TextFormField(
                    // initialValue: widget.args.edit
                    //     ? widget.args.course.ects.toString()
                    //     : '',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter comma separated ingredients';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Comma separated ingredients'),
                    onSaved: (value) {
                      setState(() {
                        this._recipe["recipeIngredients"] = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();

                        var myimage = this._recipe['asset'];
                        String base64String =
                            base64Encode(myimage.readAsBytesSync());

                        String name = basename(myimage.path);
                        String type = lookupMimeType(myimage.path);

                        String ingredients = _recipe['recipeIngredients'];
                        List<String> myIngredients = ingredients.split(',');

                        List<Ingredient> finalIngredients = [];
                        for (var x = 0; x < myIngredients.length; x++) {
                          finalIngredients
                              .add(Ingredient(name: myIngredients[x]));
                        }

                        Recipe newRecipe =
                            await RecipeDataProvider.createRecipeFileIngredient(
                                MyFile(
                                    base64str: base64String,
                                    name: name,
                                    type: type),
                                Recipe(
                                    name: _recipe['recipeName'],
                                    description: _recipe['recipeDescription']),
                                finalIngredients);

                        print('Liben');
                        print(newRecipe.runtimeType);

                        RecipeEvent event = RecipeCreate(
                          Recipe(
                              name: newRecipe.name,
                              id: newRecipe.id,
                              description: newRecipe.description,
                              filePath: newRecipe.filePath),
                        );
                        BlocProvider.of<RecipeBloc>(context).add(event);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RecipeList.routeName, (route) => false);
                        // final CourseEvent event = widget.args.edit
                        //     ? CourseUpdate(
                        //         Course(
                        //           id: widget.args.course.id,
                        //           code: this._recipe["code"],
                        //           title: this._recipe["title"],
                        //           ects: this._recipe["ects"],
                        //           description: this._recipe["description"],
                        //         ),
                        //       )
                        //     : CourseCreate(
                        //         Course(
                        //           code: this._recipe["code"],
                        //           title: this._recipe["title"],
                        //           ects: this._recipe["ects"],
                        //           description: this._recipe["description"],
                        //         ),
                        //       );

                        // Navigator.of(context).pushNamed(RecipeList.routeName);
                      }
                    },
                    label: Text('SAVE'),
                    icon: Icon(Icons.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
