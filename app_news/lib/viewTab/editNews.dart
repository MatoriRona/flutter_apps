import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:app_news/constant/constantsFile.dart';
import 'package:app_news/constant/newsModel.dart';

class EditNews extends StatefulWidget {
  final NewsModel model;
  final VoidCallback reload;

  EditNews(this.model, this.reload,);

  @override
  State<EditNews> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late File _imageFile;
  String? title, content, description, id_user;

  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtContent = TextEditingController();
  TextEditingController txtDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    setup();
  }

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString('id_users');
      txtTitle.text = widget.model.title;
      txtContent.text = widget.model.content;
      txtDescription.text = widget.model.description;
    });
  }

  void check() {
    final form = _key.currentState;
    if (form != null && form.validate()) {
      form.save();
      submit();
    }
  }

  void submit() async {
    try {
      var uri = Uri.parse(BaseUrl.editNews);
      var request = http.MultipartRequest("POST", uri);

      request.fields['title'] = title!;
      request.fields['content'] = content!;
      request.fields['description'] = description!;
      request.fields['id_users'] = id_user!;
      request.fields['id_news'] = widget.model.id_news;

      if (_imageFile != null) {
        var stream = http.ByteStream(_imageFile.openRead());
        var length = await _imageFile.length();

        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: path.basename(_imageFile.path),
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        // Handle success
        print('News updated successfully');
      } else {
        // Handle error
        print('Failed to update news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while updating news: $e');
    }
  }

  Future<void> _pilihGallery() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pilihGallery,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _imageFile == null
                        ? Image.network(
                            BaseUrl.insertImage + widget.model.image,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _imageFile,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: txtTitle,
                  onSaved: (value) => title = value,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: txtContent,
                  onSaved: (value) => content = value,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: txtDescription,
                  onSaved: (value) => description = value,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: check,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
