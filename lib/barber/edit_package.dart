import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/firebase/package_creation.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class EditPackageSelection extends StatefulWidget
{
  Map data;

  EditPackageSelection(this.data);

  _EditPackageSelection createState ()=> _EditPackageSelection(data);
}

class _EditPackageSelection extends State<EditPackageSelection>
{
  double scaleFactor = 0;
  @override


  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(FirebaseAuth.instance.currentUser!.uid)));
    return false;
  }


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
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTitle("Create New Package"),

                        SizedBox(
                          height: 20,
                        ),


                        Container(

                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _package_name,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'please enter username';
                              }
                              return null;

                            },
                            style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20/scaleFactor
                            ),

                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "package name",
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
                            controller: _packge_description,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'please enter description';
                              }
                              return null;

                            },
                            style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20/scaleFactor
                            ),

                            minLines: 2,
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "package description",

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

                        Column(
                          children: _selected_data.map((data) {
                            return ListTile(
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "duration",
                                    textScaleFactor: 0.9,
style: TextStyle(
                                        color: getBlackMate(),
                                        fontSize: 12,
                                        fontFamily: "ubuntur"
                                    ),

                                  ),
                                  Text("${data['serviceduration']} Minute",
                                    textScaleFactor: 0.9,
style: TextStyle(
                                        color: getBlackMate(),
                                        fontSize: 12,
                                        fontFamily: "ubuntub"
                                    ),
                                  )
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: data['homeappointment'] == 'true' ? Text(
                                  "H",
                                  textScaleFactor: 0.9,
style: TextStyle(
                                      color: getMateGold(),
                                      fontFamily: "ubuntub",
                                      fontSize: 20
                                  ),
                                ) : Text(
                                  "O",
                                  textScaleFactor: 0.9,
style: TextStyle(
                                      color: getMateGold(),
                                      fontFamily: "ubuntub",
                                      fontSize: 20
                                  ),
                                ),
                                foregroundColor: getBlackMate(),
                              ),
                              title: Text("${data['servicename']}",
                                textScaleFactor: 0.9,
                                style: TextStyle(color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                ),),
                              subtitle: Text(
                                //val.service_category
                                "${data['servicetype']}",
                                textScaleFactor: 0.9,
style: TextStyle(
                                    fontFamily: "ubuntur",
                                    fontSize: 13
                                ),
                              ),
                            );
                          }).toList(),
                        ),



                        SizedBox(height: 5,),





                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    "Add another service",
                                    textScaleFactor: 0.9,
style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontFamily: "ubuntur"
                                    ),
                                  )
                              ),

                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                        ),
                                        onPressed: (){

                                          showAddDialogBox();
                                        },
                                      )
                                  )
                              )
                            ],
                          ),
                        ),


                        SizedBox(height: 5,),


                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pricing and Duration",
                                textScaleFactor: 0.9,
style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntub",
                                  fontSize: 20,
                                ),

                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Text("Add the pricing options and duration of the service.",
                                textScaleFactor: 0.9,
style: TextStyle(
                                    color: getGrey(),
                                    fontSize: 14,
                                    fontFamily: "ubuntur"
                                ),
                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 7.5, 0),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: getLightGrey(),width: 2),
                                            borderRadius: BorderRadius.circular(10),
                                            color: getLightGrey()
                                        ),
                                        child: Text(
                                          "Total: ₹ $priceValue ($duartionValue Minutes)",
                                          //"Duration - $duartionValue ",
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 0.9,
style: TextStyle(
                                            color: getBlackMate(),
                                            fontFamily: "ubuntur",
                                            fontSize: 18,
                                          ),
                                        )
                                    ),
                                  ),

                                  // Expanded(
                                  //   child: Container(
                                  //     margin: EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                                  //     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(color: getLightGrey(),width: 2),
                                  //         borderRadius: BorderRadius.circular(10),
                                  //         color: getLightGrey()
                                  //     ),
                                  //     child: DropdownButton<String>(
                                  //       value: pricingValue,
                                  //       icon: Expanded(child: Container(
                                  //         child: Icon(Icons.arrow_drop_down,),
                                  //         alignment: Alignment.centerRight,)),
                                  //       iconSize: 24,
                                  //       elevation: 16,
                                  //       style: TextStyle(
                                  //           color: getBlackMate(), fontSize: 18),
                                  //       underline: Container(
                                  //         height: 2,
                                  //         color: getLightGrey(),
                                  //       ),
                                  //       onChanged: (val) {
                                  //         setState(() {
                                  //           pricingValue = val!;
                                  //         });
                                  //       },
                                  //       items: pricingCalueSpinner.map<
                                  //           DropdownMenuItem<String>>((
                                  //           String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           child: Text(value),
                                  //         );
                                  //       }).toList(),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),

                              SizedBox(height: 20,),

                              // Container(
                              //
                              //   margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20)
                              //   ),
                              //   child: TextFormField(
                              //     controller: _price,
                              //     validator: (value) {
                              //       if(value!.isEmpty)
                              //       {
                              //         return 'please enter username';
                              //       }
                              //       return null;
                              //
                              //     },
                              //     style: TextStyle(
                              //         color: getBlackMate(),
                              //         fontSize: 20/scaleFactor
                              //     ),
                              //
                              //     keyboardType: TextInputType.number,
                              //     maxLength: 4,
                              //     decoration: InputDecoration(
                              //       hintText: "price",
                              //       prefixIcon: Container(
                              //         width: 22,
                              //         height: 22,
                              //         alignment: Alignment.center,
                              //         child: Text("₹",
                              //           textAlign: TextAlign.center,
                              //           textScaleFactor: 0.9,
                              //           style: TextStyle(
                              //               color: getBlackMate(),
                              //               fontFamily: "ubuntur",
                              //               fontSize: 22
                              //           ),
                              //         ),
                              //       ),
                              //
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(width: 2,color: getBlackMate()),
                              //           borderRadius: BorderRadius.circular(10)
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(10),
                              //           borderSide: BorderSide(width: 2,color: getBlackMate())
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),


                        Container(
                          height: 20,
                          color: getLightGrey(),
                          width: MediaQuery.of(context).size.width,
                        ),

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Discount",
                                textScaleFactor: 0.9,
style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntub",
                                  fontSize: 20,
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Enable discount service choose to give different advantages to your clients.",
                                textAlign: TextAlign.justify,
                                textScaleFactor: 0.9,
style: TextStyle(
                                    color: getGrey(),
                                    fontFamily: "ubuntur",
                                    fontSize: 14
                                ),

                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: SwitcherButton(
                                value: discount,
                                offColor: getBlackMate(),
                                onColor: getMateGold(),
                                onChange: (value) {
                                  setState(() {
                                    discount = value;
                                  });
                                },
                              ),
                            ),

                            Text(
                              "Enable discount service",
                              textScaleFactor: 0.9,
style: TextStyle(
                                color: getBlackMate(),
                                fontFamily: "ubuntur",
                                fontSize: 15,

                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _discount,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'please enter username';
                              }
                              return null;

                            },
style: TextStyle(
                                color: getBlackMate(),
                                fontSize: 20/scaleFactor
                            ),

                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              hintText: "discount amount",
                              prefixIcon: Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                child: Text("₹",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 0.9,
style: TextStyle(
                                      color: getBlackMate(),
                                      fontFamily: "ubuntur",
                                      fontSize: 22
                                  ),
                                ),
                              ),

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



                        SizedBox(height: 80,),




                      ],
                    ),
                  ),
                ),

                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: getBlackMate(),

                    ),
                    onPressed: () {
                      // print(_selected_data.length);
                      // print(_selected_data);
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Hair",
                    textScaleFactor: 0.9,
style: TextStyle(
                        color: getBlackMate(),
                        fontFamily: "ubuntur",
                        fontSize: 25

                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
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


              _progress == 0 ? Container(

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
                            services.clear();
                            for(int i = 0;i<_selected_data.length;i++)
                            {
                              services.add(_selected_data.elementAt(i)['serviceid']);
                            }
                            if(_formKey.currentState!.validate()) {
                              setState(() {
                                _progress = 1;
                              });
                              PackageCreation pc = new PackageCreation();
                              pc.updateNewPackage(userid,
                                  _package_name.text.toString(),
                                  _packge_description.text,services,
                                  priceValue, duartionValue, discount.toString(), _discount.text.toString(), "time",
                                  "date",data['packageid']).then((value){
                                setState(() {
                                  _progress = 0;
                                });
                                print("done");
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.success(
                                      message: "package updated successfully",
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    )
                                );
                              }).catchError((onError){
                                CustomSnackBar.error(
                                  message: "${onError.toString()}",
                                  textStyle: TextStyle(
                                      fontFamily: "ubuntub",
                                      color: Colors.white,
                                      fontSize: 15
                                  ),
                                );
                                setState(() {
                                  _progress = 0;
                                });
                                print(onError.toString());
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "UPDATE",
                                textScaleFactor: 0.9, style: TextStyle(
                                  color: getMateGold(),
                                  fontSize: 18/scaleFactor
                              ),
                              ),
                            ],
                          ),
                          color: getBlackMate(),
                          elevation: 0,
                        ),
                      ) ,
                    ) ,
                  ],
                ),
              ) : Center(child: CircularProgressIndicator()) ,

              //_progress == 1 ? Center(child: CircularProgressIndicator()) : Container()

            ],
          )
      ),
    );
  }


  Widget getTitle(text)
  {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        text,
        textScaleFactor: 0.9,
style: TextStyle(
            color: getBlackMate(),
            fontFamily: "ubuntur",
            fontSize: 30
        ),
      ),
    );
  }

  void showAddDialogBox()
  {

    _selected_data.clear();

    setState(() {
      duartionValue = "0";
      priceValue = "0";
    });




    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setNewState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.remove,
                            color: getBlackMate(),
                            size: 30,
                          ),
                        ),
                        elevation: 0,
                      ),
                      body: SafeArea(
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(

                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                getTitle("Select service"),

                                //getServiceWidget(setNewState)


                                StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("services")
                                        .doc(userid).collection("service").orderBy('homeappointment',descending: _sort)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        return SingleChildScrollView(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),


                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      child: Text(
                                                        "Sort by home appointment",

                                                        textScaleFactor: 0.9,
style: TextStyle(
                                                          color: getBlackMate(),
                                                          fontFamily: "ubuntur",
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                                  Container(
                                                    alignment: Alignment.centerRight,
                                                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                    child: SwitcherButton(
                                                      value: _sort,
                                                      offColor: getBlackMate(),
                                                      onColor: getMateGold(),
                                                      onChange: (value) {


                                                        setState(() {
                                                          _selected_data.clear();
                                                          duartionValue = "0";
                                                          priceValue = '0';
                                                        });

                                                        setNewState((){
                                                          _sort = value;
                                                        });


                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),


                                              SizedBox(
                                                height: 30,
                                              ),

                                              Column(
                                                children: snapshot.data!.docs.map((e) {
                                                  Map data = e.data() as Map;
                                                  return Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    child: Slidable(
                                                      actionPane: SlidableDrawerActionPane(),
                                                      actionExtentRatio: 0.25,
                                                      child: Container(

                                                        decoration: BoxDecoration(
                                                            color: getLightGrey(),
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),

                                                        child: StatefulBuilder(
                                                            builder: (BuildContext context,
                                                                void Function(void Function()) setSState) {
                                                              return ListTile(
                                                                trailing: Checkbox(onChanged: (bool? value) {


                                                                  setSState(() {
                                                                    if(value == true) {
                                                                      data['activation'] =
                                                                      "false";


                                                                      setState(() {
                                                                        _selected_data.add(data);

                                                                        int temp = 0;
                                                                        int price  = 0;
                                                                        for(int i = 0;i<_selected_data.length;i++)
                                                                        {
                                                                          temp = temp + int.parse(_selected_data.elementAt(i)['serviceduration']);
                                                                          price = price + int.parse(_selected_data.elementAt(i)['price']);
                                                                        }
                                                                        duartionValue = "$temp";
                                                                        priceValue = "$price";

                                                                      });
                                                                    }
                                                                    else {
                                                                      data['activation'] =
                                                                      "true";
                                                                      setState(() {
                                                                        _selected_data.remove(data);
                                                                      });

                                                                    }
                                                                  });



                                                                }, value: data['activation'] == "true" ? false : true,

                                                                ),
                                                                leading: CircleAvatar(
                                                                  backgroundColor: Colors.white,
                                                                  child: data['homeappointment'] == 'true' ? Text(
                                                                    "H",
                                                                    textScaleFactor: 0.9,
style: TextStyle(
                                                                        color: getMateGold(),
                                                                        fontFamily: "ubuntub",
                                                                        fontSize: 20
                                                                    ),
                                                                  ) : Text(
                                                                    "O",
                                                                    textScaleFactor: 0.9,
style: TextStyle(
                                                                        color: getMateGold(),
                                                                        fontFamily: "ubuntub",
                                                                        fontSize: 20
                                                                    ),
                                                                  ),
                                                                  foregroundColor: getBlackMate(),
                                                                ),
                                                                title: Text("${data['servicename']}",
                                                                  textScaleFactor: 0.9,
                                                                  style: TextStyle(color: getBlackMate(),
                                                                    fontFamily: "ubuntur",
                                                                  ),),
                                                                subtitle: Text(
                                                                  //val.service_category
                                                                  "${data['servicetype']}",
                                                                  textScaleFactor: 0.9,
style: TextStyle(
                                                                      fontFamily: "ubuntur",
                                                                      fontSize: 13
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),

                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      else {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    }),



                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }



  //
  //
  // Widget getServiceWidget(setNewState) {
  //   return Container(
  //     padding: EdgeInsets.all(15),
  //     child: StatefulBuilder(
  //         builder: (BuildContext context,
  //             void Function(void Function()) setState) {
  //           return
  //         }),
  //   );
  // }




  Set<Map> _selected_data = new HashSet<Map>();

  Map data;
  String userid = "";
  _EditPackageSelection(this.data);
  TextEditingController _package_name = new TextEditingController();
  TextEditingController _packge_description = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  int _progress = 0;
  bool _sort = false;
  String duartionValue = '0';
  String priceValue = '0';
  TextEditingController _discount  = new TextEditingController();
  bool discount = false;

  List<String> services = [];


  @override
  void initState() {


    _package_name.text = data['packagename'];
    _packge_description.text = data['packagedesc'];
    data['discounton'] == 'true' ? discount = true : discount = false;

    _discount.text = data['discount'];
    priceValue = data['price'];
    duartionValue = data['duration'];




    userid = data['userid'];

    List serviceList = data['service'];


    serviceList.toList().forEach((element) {

      print("hhh $element");

          FirebaseFirestore.instance.collection("services").doc(userid).collection("service").doc(element).get().then((value){
            print(value.data());

            setState(() {


              Map<String, dynamic>? v = value.data();
            _selected_data.add(v!);
          });

        });
    });
  }


}