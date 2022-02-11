import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/firebase/create_business.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';

class GalleryUpdate extends StatefulWidget
{
  String vendorid;

  GalleryUpdate(this.vendorid);

  _GalleryUpdate createState ()=> _GalleryUpdate(vendorid);
}
class _GalleryUpdate extends State<GalleryUpdate>
{
  String vendorid;
  _GalleryUpdate(this.vendorid);

  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(vendorid)));
    return false;
  }

  @override
  void initState() {

    // fetchGalleryData().then((value){
    //   List<DocumentSnapshot> data = value.docs;
    //
    //   print(data[0].data());
    //
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    return WillPopScope(
      onWillPop:  _onWillPop,
      child: SafeArea(
          child: Stack(
            children: [
              getProfileSection(),
              _pointer == 1 ? Center(child: CircularProgressIndicator()) : Container()
            ],
          )
      ),
    );
  }



  Widget getProfileSection()
  {

    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            color: Colors.white
        ),

        child: Stack(
            children: [
              Scaffold(

                key: _scaffold_key,

                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Update Gallery",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                    ),
                  ),

                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: getBlackMate(),
                    ),
                    onPressed: () {
                      _onWillPop();
                    },
                  ),
                  actions: [
                    Container(

                      height: 25,
                      width: 25,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "images/hicon3.png"
                              )
                          )
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // SizedBox(height: 20,),
                          //
                          // getProfileImage(),
                          //
                          // SizedBox(height: 20,),

                          createGallery(),

                          SizedBox(height: 120,),
                        ]
                    )
                ),
              ),]
        )
    );
  }


  Widget createGallery()
  {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Gallery",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 25,
                    ),
                  ),
                ),

                Expanded(
                  child: IconButton(onPressed: (){
                    _showPickOptionsDialog(1);
                  },
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.add,
                        color: getBlackMate(),
                        size: 25,
                      )
                  ),
                )
              ],
            )
        ),

        SizedBox(
          height: 10,
        ),


        StreamBuilder(
            stream: FirebaseFirestore.instance.collection("gallery").doc(vendorid).collection("gallery").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData) {
                return SingleChildScrollView(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 3.0,
                    runSpacing: 3.0,
                    children: snapshot.data!.docs.map((e){
                      return GestureDetector(
                        onDoubleTap: (){
                          // setState(() {
                          //   _pointer = 1;
                          // });
                          // FirebaseStorage.instance.ref(vendorid).child(e['name']).delete().whenComplete((){
                          //   FirebaseFirestore.instance.collection("gallery").doc(vendorid).collection("gallery").doc(e['name']).delete().whenComplete((){
                          //     setState(() {
                          //       _pointer = 0;
                          //     });
                          //   });
                          // });
                          //
                        },
                        child: Stack(
                          children: [
                            Container(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: MediaQuery.of(context).size.width / 3.5,
                            decoration: BoxDecoration(
                                color: getLightGrey(),
                                 image: DecorationImage(
                                  image: NetworkImage(
                                    e['url']
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                  borderRadius: BorderRadius.circular(2)
                            ),
                      ),


                            Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: MediaQuery.of(context).size.width / 3.5,
                              padding: EdgeInsets.all(5),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _pointer = 1;
                                      });
                                      FirebaseStorage.instance.ref(vendorid).child(e['name']).delete().whenComplete((){
                                        FirebaseFirestore.instance.collection("gallery").doc(vendorid).collection("gallery").doc(e['name']).delete().whenComplete((){
                                          setState(() {
                                            _pointer = 0;
                                          });
                                        });
                                      });

                                    },
                                    child: Container(

                                      decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.delete,
                                        color: getBlackMate(),
                                        size: 15,)
                                      ,padding: EdgeInsets.all(5),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                    );
                  }).toList(),
                )
              );
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
        }),
      ],
    );
  }


  _loadPicker(ImageSource source,int comes) async {
    PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _pointer = 1;
      });
      CreateBusiness cb = new CreateBusiness.fetch();
      String imageid = Uuid().v1();
      cb.uploadSalonImage(File(picked.path), vendorid, imageid).then((
          value) {
        value.ref.getDownloadURL().then((value) {
          FirebaseFirestore.instance.collection("gallery")
              .doc(vendorid)
              .collection("gallery")
              .doc(imageid)
              .set({
            "url": value,
            "name": imageid,
            "activation": "true"
          });
        });
      }).whenComplete((){
        setState(() {
          _pointer = 0;
        });
      }).catchError((onError){
        setState(() {
          _pointer =0;
        });
        print(onError);
      });
    }
  }

  void _showPickOptionsDialog(int comesFrom) {


    _scaffold_key.currentState!.showBottomSheet((context){
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        color: getLightGrey(),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      _loadPicker(ImageSource.gallery,comesFrom);
                      Navigator.pop(context);
                    },
                    child: Text(
                        "gallery",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20
                        )
                    ),
                  )
              ),

              comesFrom == 0 ? Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    padding: EdgeInsets.all(20),
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      _loadPicker(ImageSource.camera,comesFrom);
                      Navigator.pop(context);
                    },
                    child: Text(
                        "camera",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate(),
                            fontSize: 20
                        )
                    ),
                  )
              ) : SizedBox(),

            ],
          ),
        ),

      );
    });


    //
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (_) => CupertinoActionSheet(
    //     actions: [
    //       CupertinoActionSheetAction(
    //           onPressed: (){
    //
    //             _loadPicker(ImageSource.gallery,comesFrom);
    //
    //             Navigator.pop(context);
    //           },
    //           child: Text("gallery")
    //       ),
    //       CupertinoActionSheetAction(
    //           onPressed: (){
    //             _loadPicker(ImageSource.camera,comesFrom);
    //             Navigator.pop(context);
    //           },
    //           child: Text("camera")
    //       ),
    //
    //     ],
    //
    //     cancelButton: CupertinoActionSheetAction(
    //       child: Text("cancel"),
    //       onPressed: (){
    //         Navigator.pop(context);
    //
    //       },
    //     ),
    //   ),
    // );

  }







  File _pickedImage = File("");

  int _pointer = 0;
  double scaleFactor = 0;

  GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();
  //Future<QuerySnapshot<Map>> fetchGalleryData() async => await FirebaseFirestore.instance.collection("gallery").doc(vendorid).collection("gallery").get();
}