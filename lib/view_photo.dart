import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotos extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<dynamic> imageList;
  ViewPhotos({this.imageIndex, this.imageList, this.heroTitle = "img"});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  PageController pageController;
  int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "${currentIndex + 1} out of ${widget.imageList.length}",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.black,
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    if (widget.imageList.length > 0) {
      return Center(
        child: _futurePages(widget.imageList),
      );
    } else {
      return Container();
    }
  }

  Future<List<CachedNetworkImageProvider>> _loadAllImages(List<String> imageUrlList) async {
    List<CachedNetworkImageProvider> cachedImages = [];

    if (imageUrlList == null) {
      return cachedImages;
    }

    for(int i=0;i<imageUrlList.length;i++) {
      var configuration = createLocalImageConfiguration(context);
      cachedImages.add(new CachedNetworkImageProvider(imageUrlList[i])..resolve(configuration));
    }
    return cachedImages;
  }

  FutureBuilder<List<CachedNetworkImageProvider>> _futurePages(List<String> imageUrlList) {
    return new FutureBuilder(
      future: _loadAllImages(imageUrlList),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData) {
          return Container(
            child: PhotoViewGallery.builder(
              itemCount: imageUrlList.length,
              pageController: pageController,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                    imageProvider: snapshot.data[index],
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    onTapDown: (value1,value2,value3){
                      setState(() {

                      });
                    }
                );
              },
              onPageChanged: onPageChanged,
              scrollPhysics: ClampingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),

            ),
          );
        } else {
          return new Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
