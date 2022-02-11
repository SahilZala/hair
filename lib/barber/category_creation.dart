import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';

class CategoryCreation extends StatefulWidget
{
  String uid;
  _CategoryCreation createState ()=> _CategoryCreation(uid);

  CategoryCreation(this.uid);

}

class _CategoryCreation extends State<CategoryCreation>
{
  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(uid)));
    return false;
  }


  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery
        .of(context)
        .textScaleFactor + 0.2;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: Stack(
            children: [

              Scaffold(
                body: Form(
                  key: _formState,
                  child: SingleChildScrollView(


                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),


                        Container(

                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _category_name,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'please enter category';
                              }
                              return null;

                            },
                            style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20/scaleFactor
                            ),

                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "category name",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: getBlackMate()),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 2,color: getBlackMate())
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _category_desc,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'please enter category description';
                              }
                              return null;

                            },
                            style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20/scaleFactor
                            ),

                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "category description",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color: getBlackMate()),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 2,color: getBlackMate())
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),


                      ],
                    ),
                  ),
                ),

                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Create New Category",
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

              ),


              Container(

                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Container(

                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),

                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: getBlackMate(),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery.of(context).size.width,

                          onPressed: () async {
                            if(_formState.currentState!.validate())
                            {
                              createCategory(_category_name.text.toString(), _category_desc.text.toString()).then((value){
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.success(
                                      message: "category created successfully",
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    )
                                );
                              }).catchError((onError){
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: ""+onError.toString(),
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    )
                                );
                              });
                            }
                          },
                          child: Text(
                            "SAVE",
                            textScaleFactor: 0.9, style: TextStyle(
                              color: getMateGold(),
                              fontSize: 18/scaleFactor
                          ),
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        ),
                      ) ,
                    ) ,
                  ],
                ),
              ) ,

            ],
          )
      ),
    );
  }



  Future<DocumentReference> createCategory(String category,String catdesc)
  {
    String catid = Uuid().v1().toString();

    return FirebaseFirestore.instance.collection("categorys").doc(uid).collection("category").add({
      'catid': catid,
      'category': category,
      'catdesc': catdesc,
      'uid': uid,
      'time': 'time',
      'date': 'date',
      'activation': 'true'
    });
  }


  GlobalKey<FormState> _formState = new GlobalKey();
  double scaleFactor = 0;
  TextEditingController _category_name = new TextEditingController();
  TextEditingController _category_desc = new TextEditingController();
  String uid;

  _CategoryCreation(this.uid);

}