import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:and_cut/models/movies.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MovieTransaction extends StatefulWidget {
  late final Movies? movie;
  late final Function(String name, String director, String path) onclickDone;
  MovieTransaction({Key? key, this.movie, required this.onclickDone})
      : super(key: key);

  @override
  _MovieTransactionState createState() => _MovieTransactionState();
}

class _MovieTransactionState extends State<MovieTransaction> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final pathController = TextEditingController();

  File? image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    // final imagetemp = File(image!.path);
    print(image.path);
    final imagesave = await saveImage(image.path);

    this.image = imagesave;
  }

  Future<File> saveImage(String imagepath) async {
    final directiry = await getApplicationDocumentsDirectory();
    final name = p.basename(imagepath);
    final image = File('${directiry.path}/$name');

    print(image.path);
    pathController.text = image.path;
    return File(imagepath).copy(image.path);
    //  image.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.movie != null) {
      final movie = widget.movie;
      nameController.text = movie!.name; //null check
      directorController.text =
          movie.director; //cant be null there should be some value
      pathController.text = movie.path;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    directorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 8),
              buildPath(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Movie Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a movie Name' : null,
      );

  Widget buildDirector() => TextFormField(
        controller: directorController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Director Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a Director Name' : null,
      );

  Widget buildPath() =>
      ElevatedButton(onPressed: () => pickImage(), child: Text('Select Image'));

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final director = directorController.text;
          final path = pathController.text;
          print(name + director + path);
          widget.onclickDone(name, director, path);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
