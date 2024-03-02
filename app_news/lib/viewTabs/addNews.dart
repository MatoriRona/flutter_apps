import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AddNews extends StatefulWidget {
  const AddNews({Key? key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  File? _imageFile;
  String? title, content, description, id_user;

  final _key = GlobalKey<FormState>();

  _pilihGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1920,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream = http.ByteStream(_imageFile!.openRead());
      var length = await _imageFile!.length();
      var uri = Uri.parse("http://192.168.1.11/appnews/addNews.php"); // Perbaikan URL
      var request = http.MultipartRequest("POST", uri);
      request.files.add(http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(_imageFile!.path),
      ));

      request.fields['title'] = title!;
      request.fields['content'] = content!;
      request.fields['description'] = description!;
      request.fields['id_user'] = id_user!;

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image Uploaded");
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print("Image Failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString("id_user");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Image.asset('./image/placeholder.jpg'),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  _pilihGallery();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile!,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              onSaved: (e) => title = e,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              onSaved: (e) => content = e,
              decoration: InputDecoration(
                labelText: 'Content',
              ),
            ),
            TextFormField(
              onSaved: (e) => description = e,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
