import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors.dart';

class TimeSlotUpdate extends StatefulWidget
{
  String vendorid;

  TimeSlotUpdate(this.vendorid);

  _TimeSlotUpdate createState ()=> _TimeSlotUpdate(vendorid);
}

class _TimeSlotUpdate extends State<TimeSlotUpdate>
{
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
    fetchBusinessData().then((value) {


      timing.add(
        {
          '0': {
            'day':'Monday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );

      timing.add(
        {
          '1' : {
            'day':'Tuesday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );

      timing.add(
        {
          '2': {
            'day':'Wednesday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );

      timing.add(
        {
          '3': {
            'day':'Thursday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );

      timing.add(
        {
          '4': {
            'day':'Friday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );

      timing.add(
        {
          '5': {
            'day':'Saturday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );
      timing.add(
        {
          '6': {
            'day':'Sunday',
            'start':'start',
            'end':'end',
            'activate': 0
          }
        },
      );


      Map? data = value.data();

      setState(() {
        timing = data!['businessTiming'];

        print(timing);
      });


    });
  }

  @override
  Widget build(BuildContext context) {

    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    return WillPopScope(
      onWillPop:  _onWillPop,
      child: SafeArea(
          child: Stack(
            children: [

              getSalonTiming(),

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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius:/ 5,
                          //     blurRadius: 7,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          minWidth: MediaQuery.of(context).size.width,

                          onPressed: () async {

                            setState(() {
                              _pointer = 1;
                            });
                            FirebaseFirestore.instance.collection("business").doc(vendorid).update({
                              'businessTiming' : timing
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



  Widget getSalonTiming()
  {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Update Time Slots",
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

                Column(
                  children: [
                    getDaysWidget("Monday",0),
                    getDaysWidget("Tuesday",1),
                    getDaysWidget("Wednesday",2),
                    getDaysWidget("Thursday",3),
                    getDaysWidget("Friday",4),
                    getDaysWidget("Saturday",5),
                    getDaysWidget("Sunday",6),



                  ],
                ),




              SizedBox(height: 150,),
            ],
          ),
        ),
      ),
    );
  }


  Widget getDaysWidget(String day,int position)
  {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex:1,
              child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.centerLeft,
                child: Checkbox(
                  value: timing.length !=0 && timing[position][position.toString()]['activate'] == 0 ? false : true,
                  activeColor: getMateGold(),
                  onChanged: (bool? value){
                    setState(() {
                      timing.length !=0 && value == true ? timing[position][position.toString()]['activate'] = 1 : timing[position][position.toString()]['activate'] = 0;
                    });
                  },
                ),
              ),
            ),


            Expanded(
              flex:3,
              child: Text(
                "$day",
                textAlign: TextAlign.left,
                textScaleFactor: 0.9,
                style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntur",
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),

              ),
            ),


            Expanded(
              flex: 6,
              child: Container(

                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          _selectTime().then((value) {
                            setState(() {
                              timing[position][position.toString()]['start'] = value;
                            });
                          });
                        },
                        child: Text(
                          timing.length != 0 ? timing[position][position.toString()]['start'] : "start",

                          textScaleFactor: 0.9,
                          style: TextStyle(

                            color: getGrey(),

                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),

                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(
                        "---",
                        textAlign: TextAlign.center,
                        textScaleFactor: 0.9,
                        style: TextStyle(
                            color: getBlackMate()
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 4,
                      child: MaterialButton(

                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _selectTime().then((value) {
                            setState(() {
                              timing[position][position.toString()]['end'] = value;
                            });
                          });
                        },
                        child: Text(
                          timing.length != 0 ? timing[position][position.toString()]['end'] : "end",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                            color: getGrey(),
                            fontFamily: "ubuntur",
                            fontSize: 18,
                          ),

                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),


        SizedBox(
          height: 10,
        ),

        Container(
            height: 2,
            width: MediaQuery.of(context).size.width,
            color: getLightGrey()
        ),

      ],
    );
  }




  Future<String> _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    return "${newTime!.hour < 10 ? "0${newTime.hour}" : "${newTime.hour}"} : ${newTime.minute < 10 ? "0${newTime.minute}" : "${newTime.minute}"}";
  }





  _TimeSlotUpdate(this.vendorid);

  TimeOfDay _time = TimeOfDay(hour: 10, minute: 00);
  int _pointer = 0;
  double scaleFactor = 0;
  String vendorid;
  List timing = [];

  Future<DocumentSnapshot<Map>> fetchBusinessData() async => await FirebaseFirestore.instance.collection("business").doc(vendorid).get();
}