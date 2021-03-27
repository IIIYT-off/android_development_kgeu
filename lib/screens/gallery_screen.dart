import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trp_shut_off/api/gallery_services.dart';
import 'package:trp_shut_off/api/mapper/gallery.dart';
import 'package:trp_shut_off/api/models/api_gallery_models.dart';
import 'package:trp_shut_off/api/request/api_gallery_request.dart';
import 'package:trp_shut_off/data/model.dart';
import 'package:trp_shut_off/screens/widgets/widgets.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Future _futureData;
  List gallery = [];

  @override
  void initState() {
    super.initState();

    // initial load
    _futureData = updateAndGetList();
  }

  void refreshList() {
    // reload
    setState(() {
      _futureData = updateAndGetList();
    });
  }

  Future updateAndGetList() async {
    return await GalleryServices()
        .getGallery();
  }




  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Icon(Icons.image),
          title: Text('Галерея'),
          actions: [
            uploadNewPhoto()
          ],
        ),
        endDrawer: leftDrawer(context),
        bottomNavigationBar: bottomBar(context, _scaffoldKey),
        body: screenBody()
    );
  }

  Widget uploadNewPhoto() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return MyDialog();
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "Загрузить фото",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget screenBody() {
    return FutureBuilder(
        future: _futureData,
        builder: (BuildContext context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            if (snapshot.data.data != 'error') {
              print('Строю экран');
              gallery = (snapshot.data.data['images']).map((data) =>
                  GalleryMapper.fromMap(ApiGetGallery.fromJson(data))).toList();
              child = _buildBody();
            } else {
              print('error');
              child = Center(
                child: ElevatedButton(
                    onPressed: () {
                      refreshList();
                    },
                    child: Text('Обновить')),
              );
            }
          } else {
            child = loading();
          }
          return child;
        });
  }

  Widget loading() {
    return ListView(
      children: [
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildBody() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: gallery.length,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            alignment: Alignment.center,
            child: Image.network(gallery[index].image),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)),
          );
        });
  }

}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  File _pickedImage;
  final picker = ImagePicker();

  Future<void> uploadImage() async{
    
    // var _dio = Dio();

    FormData formData = new FormData.fromMap({
      'image': MultipartFile.fromString(_pickedImage.path)
    });

    // await _dio.post('http://studentapi.myknitu.ru/send/', data: formData);
    
    await GalleryServices().uploadImage(formData);

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: dialogContent()
    );
  }
  getImage(ImageSource type) async {
    final pickedFile = await picker.getImage(source: type);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget dialogContent() {
    if (_pickedImage == null) {
      return Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Сделать снимок'),
                  onPressed: () {
                    setState(() async{
                      await getImage(ImageSource.camera);
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Выбрать из галереи'),
                  onPressed: () async{
                    await getImage(ImageSource.gallery);
                  },
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3.8,
                child: Image.file(_pickedImage)),
            ElevatedButton(
              child: Text('Отправить'),
              onPressed: (){
                uploadImage();
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (context) => new GalleryScreen()),
                //       (Route<dynamic> route) => false,
                // );
              },
            )
          ],
        ),
      );
    }
  }
}
