import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class MaleFemale extends StatefulWidget
{
  String vendorid;

  MaleFemale(this.vendorid);

  _MaleFemale createState() => _MaleFemale(vendorid);
}
class _MaleFemale extends State<MaleFemale>
{
  String vendorid;


  _MaleFemale(this.vendorid);

  double scaleFactor = 0;

  Future<bool> _onWillPop() async{
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BarberDashboard(vendorid)));
    return false;
  }


  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
   return WillPopScope(
     onWillPop: _onWillPop,
     child: SafeArea(
         child: Stack(
           children: [
             getMaleFemale(),

             Container(
               height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   _pointer == 0 ? Container(
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

                           setState(() {
                             _pointer = 1;
                           });
                           FirebaseFirestore.instance.collection("business").doc(vendorid).update({
                             'hairFemaleSeats':  hfemale.toString(),
                             'hairMaleSeats': hmale.toString(),
                             'treatmentFemaleSeats': tfemale.toString(),
                             'treatmentMaleSeats': tmale.toString(),
                             'totalStaff': staff.toString(),
                             'salonTypeInGender': mfu == 0 ? "male" : mfu == 1 ? "female" : "unisex",
                           }).then((value){

                             setState(() {
                               _pointer = 0;
                             });

                             showTopSnackBar(
                                 context,
                                 CustomSnackBar.success(
                                   message: "updated",
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
                         },
                         child: Text(
                           "UPDATE",
                           textScaleFactor: 0.9, style: TextStyle(
                             color: getMateGold(),
                             fontSize: 18/scaleFactor
                         ),
                         ),
                         color: getBlackMate(),
                         elevation: 0,
                       ),
                     ) ,
                   ) : CircularProgressIndicator(),
                 ],
               ),
             ),

           ],
         )
     ),
   );
  }


  Widget getMaleFemale() {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Update Gender",
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

      body: Container(
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

        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 30,),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        getMFU("images/male.png","male",0,setState),
                        getMFU("images/female.png","female",1,setState),
                        getMFU("images/unisex.png","unisex",2,setState),

                      ],
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    mfu == 0 || mfu == 2? Text(
                      "Male Seats",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntur",
                          fontSize: 25
                      ),
                    ) : SizedBox(),

                    mfu == 0 || mfu == 2 ? SizedBox(
                      height: 10,
                    ) : SizedBox(),

                    mfu == 0 || mfu == 2 ? Container(
                      width: MediaQuery.of(context).size.width,


                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            if(hmale > 0) {
                                              --hmale;
                                            }
                                          });
                                        }, icon:Icon(Icons.remove),

                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                      child: Container(
                                          alignment: Alignment.center,

                                          child: Column(
                                            children: [
                                              Text(
                                                "hair",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 13
                                                ),
                                              ),
                                              Text(
                                                "$hmale",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 20
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),


                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            ++hmale;
                                          });
                                        }, icon:Icon(Icons.add),

                                        ),
                                      ),
                                    ),
                                  ),





                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            if(tmale > 0) {
                                              --tmale;
                                            }
                                          });

                                        }, icon:Icon(Icons.remove),

                                        ),
                                      ),
                                    ),
                                  ),



                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                      child: Container(
                                          alignment: Alignment.center,

                                          child: Column(
                                            children: [
                                              Text(
                                                "treatment",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 13
                                                ),
                                              ),
                                              Text(
                                                "$tmale",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 20
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),



                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            ++tmale;
                                          });
                                        }, icon:Icon(Icons.add),

                                        ),
                                      ),
                                    ),
                                  ),



                                ],
                              ),
                            ),
                          ),





                        ],
                      ),

                    ) : SizedBox(),

                    mfu == 0 || mfu == 2 ? SizedBox(height: 20,) : SizedBox(),

                    mfu == 1 || mfu == 2 ? Text(
                      "Female Seats",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntur",
                          fontSize: 25
                      ),
                    ) : SizedBox(),

                    mfu == 1 || mfu == 2 ? SizedBox(
                      height: 10,
                    ) : SizedBox(),

                    mfu == 1 || mfu == 2 ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            if(hfemale > 0) {
                                              --hfemale;
                                            }
                                          });

                                        }, icon:Icon(Icons.remove),

                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                      child: Container(
                                          alignment: Alignment.center,

                                          child: Column(
                                            children: [
                                              Text(
                                                "hair",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 13
                                                ),
                                              ),
                                              Text(
                                                "$hfemale",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 20
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            ++hfemale;
                                          });
                                        }, icon:Icon(Icons.add),

                                        ),
                                      ),
                                    ),
                                  ),




                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 10,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [



                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            if(tfemale > 0) {
                                              --tfemale;
                                            }
                                          });

                                        }, icon:Icon(Icons.remove),

                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                      child: Container(
                                          alignment: Alignment.center,

                                          child: Column(
                                            children: [
                                              Text(
                                                "treatment",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 13
                                                ),
                                              ),
                                              Text(
                                                "$tfemale",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 20
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),




                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            tfemale++;
                                          });
                                        }, icon:Icon(Icons.add),

                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),





                        ],
                      ),

                    ) : SizedBox(),

                    mfu == 1 || mfu == 2 ? SizedBox(height: 20,) : SizedBox(),

                    Text(
                      "Total Staff",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: getBlackMate(),
                          fontFamily: "ubuntur",
                          fontSize: 25
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ) ,

                    Container(

                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [


                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            if(staff > 0) {
                                              --staff;
                                            }
                                          });
                                        }, icon:Icon(Icons.remove),

                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Container(

                                      child: Container(
                                          alignment: Alignment.center,

                                          child: Column(
                                            children: [
                                              Text(
                                                "staff",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 13
                                                ),
                                              ),
                                              Text(
                                                "$staff",
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                    color: getBlackMate(),
                                                    fontFamily: "ubuntur",
                                                    fontSize: 20
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),


                                  Expanded(
                                    child: Container(

                                      child: Container(
                                        width: 20,
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            ++staff;
                                          });
                                        }, icon:Icon(Icons.add),

                                        ),
                                      ),
                                    ),
                                  ),




                                ],
                              ),
                            ),
                          ),





                        ],
                      ),

                    ),

                  ],
                ),




              SizedBox(height: 150,),
            ],
          ),
        ),
      ),
    );
  }


  Widget getMFU(String image,String title,int index,setState)
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          mfu = index;
        });
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: mfu != index ? 1 : 10,
        child: Container(
          width: MediaQuery.of(context).size.width/3-20,


          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mfu != index ? Colors.transparent : getMateGold(),
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          image,
                        ),
                        fit: BoxFit.cover
                    )
                ),
              ),

              SizedBox(height: 8,),

              Text(
                title,
                textScaleFactor: 0.9,
                style: TextStyle(
                    color: getBlackMate(),
                    fontSize: 14,
                    fontFamily: "ubuntur"
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  Future<DocumentSnapshot<Map>> fetchFacilityData() async => await FirebaseFirestore.instance.collection("business").doc(vendorid).get();


  @override
  void initState() {
    fetchFacilityData().then((value){
      Map? data = value.data();
      setState(() {
        hmale = int.parse(data!['hairMaleSeats']);
        tmale = int.parse(data['treatmentMaleSeats']);
        hfemale = int.parse(data['hairFemaleSeats']);
        tfemale = int.parse(data['treatmentFemaleSeats']);
        staff = int.parse(data['totalStaff']);

        if(data['salonTypeInGender'] == "unisex")
        {
          mfu = 2;
        }
        else if(data['salonTypeInGender'] == "male") {
          mfu = 0;
        }
        else {
          mfu = 1;
        }
      });
    });
  }


  int mfu = -1;
  int hmale = 0,tmale = 0,hfemale = 0,tfemale = 0,staff = 0;

  int _pointer = 0;


}