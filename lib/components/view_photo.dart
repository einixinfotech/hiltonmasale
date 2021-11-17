import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatelessWidget {

  final String url;
  const ViewPhoto({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: InkWell(
          onTap:()=> Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.close_rounded,color: Colors.black,size: 25,),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: PhotoView(
          imageProvider: NetworkImage(url),
          backgroundDecoration: BoxDecoration(
              color: Colors.white
          ),
          loadingBuilder: (context, event) => Column(
            children: [
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}