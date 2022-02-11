
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/barber/barber_dashboard.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/create_business.dart';
import 'package:hair/firebase/services.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

class NewService extends StatefulWidget
{
  String vendorid;
  String businessid;

  NewService(this.vendorid, this.businessid);

  _NewService createState ()=> _NewService(vendorid,businessid);

}

class _NewService extends State<NewService>
{
  double scaleFactor = 0;
  GlobalKey<ScaffoldState> _scaffold_state = GlobalKey();

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
            Scaffold(
              key: _scaffold_state,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    getTitle(),
                    getFormWidget()

                  ],
                ),
              ),

              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  "Create New Service",
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
                          if(_service_form.currentState!.validate()) {

                            setState(() {
                              _progress = 1;
                            });

                            if(_discount_on == true && (int.parse(_discount.text) > 0 && int.parse(_discount.text) < int.parse(_price.text)))
                            {
                              Services data = new Services.create(
                                  _service_name.text,
                                  dropdownValue,
                                  _service_description.text,
                                  categoryValue,
                                  genderSelection,
                                  _online_booking.toString(),
                                  duartionValue,
                                  pricingValue,
                                  _price.text,
                                  _discount_on.toString(),
                                  _discount.text,
                                  _home_appointment.toString(),
                                  _seat_distribution == 1 ? "salon" : "treatment") ;

                              //   _services.add(data);

                              CreateBusiness cb = new CreateBusiness.service(vendorid, businessid, "time", "date");
                              cb.createServices(data, Uuid().v1()).whenComplete((){
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.success(
                                      message: "Service created succesfully",
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15/getScaleFactor(context)
                                      ),
                                    )
                                );
                                setState(() {
                                  _progress = 0;
                                });
                              }).catchError((onerror){

                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: "Some thing went wrong try latter",
                                      textStyle: TextStyle(
                                          fontFamily: "ubuntub",
                                          color: Colors.white,
                                          fontSize: 15/getScaleFactor(context)
                                      ),
                                    )
                                );
                                setState(() {
                                  _progress = 0;
                                });
                              });


                              _service_name.text = "";
                              _service_description.text = "";
                              _price.text = "";
                              _discount.text = "";

                            }
                            else{
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                  message: "Please enter proper discount value",
                                  textStyle: TextStyle(
                                  fontFamily: "ubuntub",
                                  color: Colors.white,
                                  fontSize: 15/getScaleFactor(context)
                          ),
                          ));
                            }
                          }
                        },
                        child: Text(
                          "SAVE",
                          textScaleFactor: 0.9,
                          style: TextStyle(
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

            _progress == 1 ? Center(child: CircularProgressIndicator()) : Container()

          ],
        ),
      ),
    );
  }

  Widget getTitle()
  {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(
        "Add a new service",
        textScaleFactor: 0.9,
style: TextStyle(
          color: getBlackMate(),
          fontFamily: "ubuntub",
          fontSize: 25

        ),
      ),
    );
  }

  Widget getFormWidget()
  {
    return Form(
      key: _service_form,
        child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),


              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                    border: Border.all(color: getLightGrey(),width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: getLightGrey()
                ),
                child: DropdownButton<String>(
                  value: categoryValue,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
                    alignment: Alignment.centerRight,)),
                  iconSize: 24,
                  elevation: 16,
  style: TextStyle(
                      color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                  underline: Container(
                    height: 2,
                    color: getLightGrey(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      categoryValue = val!;
                    });
                  },
                  items: categorySpinnerItems.map<
                      DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),



              SizedBox(height: 20,),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                    border: Border.all(color: getLightGrey(),width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: getLightGrey()
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
                    alignment: Alignment.centerRight,)),
                  iconSize: 24,
                  elevation: 16,

style: TextStyle(
                      color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (val) {
                    setState(() {
                      dropdownValue = val!;
                    });
                  },
                  items: spinnerItems.map<
                      DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
                  controller: _service_name,
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
                    hintText: "service name",
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
                  controller: _service_description,
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
                    hintText: "service description",

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
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                    border: Border.all(color: getLightGrey(),width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: getLightGrey()
                ),
                child: DropdownButton<String>(
                  value: genderSelection,
                  icon: Expanded(child: Container(
                    child: Icon(Icons.arrow_drop_down,),
                    alignment: Alignment.centerRight,)),
                  iconSize: 24,
                  elevation: 16,

style: TextStyle(
                      color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                  underline: Container(
                    height: 2,
                    color: getLightGrey(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      genderSelection = val!;
                    });
                  },
                  items: genderSpinner.map<
                      DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20,),

              // Container(
              //   height: 20,
              //   color: getLightGrey(),
              //   width: MediaQuery.of(context).size.width,
              // ),
              //
              // SizedBox(height: 20,),
              //
              // Container(
              //   margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //           "Online booking",
              //         textScaleFactor: 0.9,

              //           color: getBlackMate(),
              //           fontFamily: "ubuntub",
              //           fontSize: 20,
              //         ),
              //       ),
              //
              //       SizedBox(
              //         height: 10,
              //       ),
              //
              //       Text(
              //         "Enable online bookings choose who the service is available for and add a short description",
              //         textAlign: TextAlign.justify,
              //         textScaleFactor: 0.9,
              //         textScaleFactor: 0.9,
//style: TextStyle(
              //           color: getGrey(),
              //           fontFamily: "ubuntur",
              //           fontSize: 14
              //         ),
              //
              //       )
              //     ],
              //   ),
              // ),
              //
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              //       child: SwitcherButton(
              //         value: true,
              //         offColor: getBlackMate(),
              //         onColor: getMateGold(),
              //         onChange: (value) {
              //           print(value);
              //         },
              //       ),
              //     ),
              //
              //     Text(
              //       "Enable online bookings",
              //       textScaleFactor: 0.9,
//style: TextStyle(
              //         color: getBlackMate(),
              //         fontFamily: "ubuntur",
              //         fontSize: 15,
              //
              //       ),
              //     ),
              //   ],
              // ),
              //
              // SizedBox(
              //   height: 20,
              // ),

              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

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
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: getLightGrey(),width: 2),
                                borderRadius: BorderRadius.circular(10),
                                color: getLightGrey()
                            ),
                            child: DropdownButton<String>(
                              value: duartionValue,
                              icon: Expanded(child: Container(
                                child: Icon(Icons.arrow_drop_down,),
                                alignment: Alignment.centerRight,)),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: getBlackMate(), fontSize: 18/getScaleFactor(context)),
                              underline: Container(
                                height: 2,
                                color: getLightGrey(),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  duartionValue = val!;
                                });
                              },
                              items: duartionValueSpinnerItems.map<
                                  DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: value == "duration" ?
                                  Text("duration",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(color: getBlackMate(),
                                        fontFamily: "ubuntur"),)
                                      : Text("$value Minutes",
                                    textScaleFactor:0.9,
                                      style: TextStyle(color: getBlackMate(),
                                        fontFamily: "ubuntur"),
                                  ),
                                );
                              }).toList(),
                            ),
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
                        //       textScaleFactor: 0.9,
                        //style: TextStyle(
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

                    Container(

                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextFormField(
                        controller: _price,
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
                          hintText: "price",
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
                      value: _discount_on,
                      offColor: getBlackMate(),
                      onColor: getMateGold(),
                      onChange: (value) {
                        setState(() {
                          setState(() {
                            _discount_on = value;
                          });
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

              _discount_on == true ? Container(
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
                    hintText: "discount in amount",
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
              ) : Container(),

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
                      "Home Service",
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
                      "Enable home service to give service to your client at home.",
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
                      value: _home_appointment,
                      offColor: getBlackMate(),
                      onColor: getMateGold(),
                      onChange: (value) {
                        print(value);
                        setState(() {
                          _home_appointment = value;
                        });
                      },
                    ),
                  ),

                  Text(
                    "Enable home service",
                    textScaleFactor: 0.9,
style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15,

                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),


              Container(
                height: 20,
                color: getLightGrey(),
                width: MediaQuery.of(context).size.width,
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select seat type",
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
                      "Select seat type from given.",
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
                  GestureDetector(
                    onTap: (){
                      setState((){
                        _seat_distribution = 1;
                        print("s");
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: _seat_distribution == 0 ? 1 : 10,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width/3-50,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:_seat_distribution == 0 ? Colors.transparent : getMateGold(),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "images/chair.png",
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),

                              SizedBox(height: 8,),

                              Text(
                                "salon seat",
                                textAlign: TextAlign.center,
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
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: _seat_distribution == 0 ? 10 : 1,
                      child: GestureDetector(
                        onTap: (){
                          setState((){
                            _seat_distribution = 0;
                          });
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width/3-30,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _seat_distribution == 0 ? getMateGold() : Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "images/treatment_chair.png",
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),

                              SizedBox(height: 8,),

                              Text(
                                "treatment seat",
                                textAlign: TextAlign.center,
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
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(height: 100,),
            ],
          ),
        )
    );
  }

  String vendorid,businessid;

  int _progress = 0;

  _NewService(this.vendorid, this.businessid); //service controllers ;

  TextEditingController _service_name = new TextEditingController(),
      _service_description = new TextEditingController(),
      _price = new TextEditingController(),
      _discount  = new TextEditingController();


  GlobalKey<FormState> _service_form = new GlobalKey();
  bool _online_booking = true,_discount_on = false,_home_appointment = false;

  String dropdownValue = 'select service type';




  List <String> spinnerItems = [
    'select service type',
  ];

  String categoryValue = 'select category type';

  List <String> categorySpinnerItems = [
    'select category type',
    'hair cut',
    'hair color',
    'shaving'
  ];


  String duartionValue = 'duration';
  int _seat_distribution = 0;

  List <String> duartionValueSpinnerItems = [
    'duration',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '110'
  ];

  String pricingValue = 'pricing type';

  List <String> pricingCalueSpinner = [
    'pricing type',
    'fixed'
  ];

  String genderSelection = "service for ?";

  List <String> genderSpinner = [
    'service for ?',
    'male',
    'female',
    'unisex'
  ];

  List category = [];

  @override
  void initState() {

    
    
    print(vendorid);
    print(businessid);

    
    FirebaseFirestore.instance.collection("business").doc(vendorid).get().then((value){
      Map<String, dynamic>? data = value.data();

      setState(() {
        category = data!['businessTypeList'];

        print(category[0]['0']);

          if(category[0]['0'] == '1')
          {
            spinnerItems.add('salon');
          }
          if(category[1]['1'] == '1')
          {
            spinnerItems.add('frelancing');
          }
          if(category[2]['2'] == '1')
          {
            spinnerItems.add('groom');
          }
          if(category[3]['3'] == '1')
          {
            spinnerItems.add('bridal');
          }
          if(category[4]['4'] == '1')
          {
            spinnerItems.add('massage/spa');
          }

          print(spinnerItems);

      });

    }).catchError((onError){
      print(onError);
    });



    FirebaseFirestore.instance.collection("categorys").doc(vendorid).collection("category").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        setState(() {
          categorySpinnerItems.add(element.data()['category']);
        });
      });
    });
    //.collection("businessTypeList")
  }
  
  
}