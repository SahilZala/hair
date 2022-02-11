import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocode/geocode.dart';
import 'package:hair/api/pdf_api.dart';
import 'package:hair/api/pdf_invoice_api.dart';
import 'package:hair/checkout/Order.dart';
import 'package:hair/colors.dart';
import 'package:hair/firebase/get_near_by_salon.dart';
import 'package:hair/getScaleFactor.dart';
import 'package:hair/home/new_new_user_home.dart';
import 'package:hair/model/customer.dart';
import 'package:hair/model/invoice.dart';
import 'package:hair/model/supplier.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CompleteOrder extends StatefulWidget
{
  OrderClass oc;

  _CompleteOrder createState ()=> _CompleteOrder(oc);

  CompleteOrder(this.oc);
}

class _CompleteOrder extends State<CompleteOrder>
{



  Future<bool> _onWillPop() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => NewUserHome()));

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSliderWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    getSalonData(),


                    SizedBox(
                        height: 15
                    ),

                    Container(
                      child: Text(
                          "Orderid",
                          style: TextStyle(
                            color: getBlackMate(),
                            fontFamily: "ubuntur",
                            fontSize: 18
                          )
                      ),

                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Container(
                      child: Text(
                          oc.orderid,
                          style: TextStyle(
                            color: getMateGold(),
                            fontFamily: "ubuntur",
                          )
                      ),

                    ),

                    //706763

                    SizedBox(
                        height: 15
                    ),

                    oc.servicetype == "service" ? getSelectedServiceList() : StreamBuilder(
                      stream: FirebaseFirestore
                          .instance
                          .collection("packages")
                          .doc(oc.vendorid).collection("package").doc(oc.serviceid[0]).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.hasData){
                          if(snapshot.data != null)
                          {
                            List pdata = snapshot.data['service'];

                            print("pdata =  ${pdata}");

                            return Column(
                              children: pdata.map((e){
                                return getPackageListWidget(e);
                              }).toList(),
                            );

                          }
                          else{
                            return Container();
                          }
                        }
                        else{
                          return Container();
                        }

                      },
                    ),

                    SizedBox(height: 20),



                    _showReviewBox == 0 ? getRatingContainer() : Container(),


                    SizedBox(
                      height: 30,
                    ),


                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: getBlackMate(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${oc.servicestatus}",
                        style: TextStyle(
                            color: getMateGold(),
                            fontFamily: "ubuntur",
                            fontSize: 18
                        ),
                      ),
                    )
                  ],
                )
            ),

            appBar: AppBar(
              backgroundColor: getBlackMate(),
              elevation: 0,
              title: Text(
                "My Order",
                style: TextStyle(
                  color: getMateGold(),
                  fontFamily: "ubuntur",
                ),
              ),

              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: getMateGold(),
                ),
                onPressed: () {
                  _onWillPop();
                },
              ),

              actions: [
                IconButton(
                  onPressed: () async {
                    generatePdf();
                  },
                  icon: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: getMateGold(),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }


  Widget getSliderWidget()
  {
    return StreamBuilder(
      stream: getSalonGallaryImage(oc.vendorid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
        if(snapshot.hasData){

          if(snapshot.data?.docs.toList().isNotEmpty == true) {

            var imgList = snapshot.data?.docs.toList();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16 / 8,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, s) {
                      // setState(() {
                      //   _current = index;
                      // });
                    }
                ),
                items: imgList!.map((item) => getSliderItem(item['url'])).toList(),

              ),
            );

            // return Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 125,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Colors.grey,
            //       image: DecorationImage(
            //           image: NetworkImage(
            //             snapshot.data?.docs.toList()[0]['url'],
            //           ),
            //           fit: BoxFit.fill
            //       )
            //   ),
            // );
          }
          else{
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                      ),
                      fit: BoxFit.cover
                  )
              ),
            );
          }


        }
        else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHNhbG9ufGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
                    ),
                    fit: BoxFit.cover
                )
            ),
          );
        }
      },
    );
  }

  Widget getSliderItem(String url) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                url
            ),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }


  Widget getSalonData()
  {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("business").doc(oc.vendorid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          if(snapshot.data != null)
          {
            salondata = snapshot.data?.data() as Map;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${snapshot.data!.data()!['businessName']}",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 25

                  ),
                ),


                SizedBox(height: 10,),

                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemSize: 20,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: getMateGold(),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),

                    Text(
                      "0.0",
                      style: TextStyle(
                        color: getMateGold(),
                        fontSize: 20,
                        fontFamily: "ubuntub",

                      ),
                    ),
                  ],
                ),

                SizedBox(height:10,),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: getMateGold(),
                      size: 15,
                    ),

                    SizedBox(
                      width: 5,
                    ),

                    Text(
                      "${snapshot.data!.data()!['address']}",
                      style: TextStyle(
                          color: getMateGold(),
                          fontSize: 15,
                          fontFamily: "ubuntur"
                      ),
                    )

                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: getLightGrey1(),
                ),

                SizedBox(
                  height: 15,
                ),

                Text(
                  "Service time & date",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: getBlackMate(),
                    fontFamily: "ubuntub",
                    fontSize: 22,
                  ),
                ),

                SizedBox(height: 10,),

                // Text(
                //   "give otp to vendor",
                //   style: TextStyle(
                //     color: getBlackMate(),
                //     fontFamily: "ubuntur",
                //     fontSize: 15,
                //   ),
                // ),
                //
                // SizedBox(height: 15,),
                //
                // Text(
                //   "$code",
                //   style: TextStyle(
                //     color: getMateGold(),
                //     fontFamily: "ubuntub",
                //     fontSize: 25,
                //   ),
                // ),
                //
                // SizedBox(height: 15,),

                Text(
                  "start time - ${DateFormat("HH : mm").parse(oc.starttime).hour} : "
        "${DateFormat("HH : mm").parse(oc.starttime ).minute == 0 ? "00" : DateFormat("HH : mm").parse(oc.starttime).minute}",
                  style: TextStyle(
                      color: getMateGold(),
                      fontSize: 15,
                      fontFamily: "ubuntur"
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Text(
                  "servcie date - ${oc.selecteddate}",
                  style: TextStyle(
                      color: getMateGold(),
                      fontSize: 15,
                      fontFamily: "ubuntur"
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: getLightGrey1(),
                ),

                SizedBox(
                  height: 15,
                ),

              ],
            );
          }
          else{
            return Container();
          }
        }
        else{
          return Container();
        }
      },
    );
  }


  Widget getPackageListWidget(String serviceid)
  {
     return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").doc(serviceid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData)
        {
          if(snapshot.data != null)
          {
            //  return getProductListTiles(snapshot.data!.data() as Map);
            return Container(
              margin: EdgeInsets.fromLTRB(0,5,0,5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),

              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: getBlackMate(),
                  child: Text(
                    "${snapshot.data!['servicename'][0].toString().toUpperCase()}",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Text(
                    "₹ ${snapshot.data!['price']}  /-",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: getMateGold(),
                        fontFamily: "ubuntub",
                        fontSize: 20
                    ),
                  ),
                ) ,

                title: Text("${snapshot.data!['servicename'].toString().toUpperCase()}",
                  textScaleFactor: 0.9,
                  style: TextStyle(color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                  ),),
                subtitle: Text(
                  "${snapshot.data!['serviceduration']} Minutes",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      fontFamily: "ubuntur",
                      fontSize: 13
                  ),
                ),
              ),
            );
          }
          else{
            return Container();
          }
        }
        else{
          return Container();
        }
      },
    );

  }



  Widget getSelectedServiceList()
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "services",
                style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 20,
                ),
              ),
            ),

            Text(
              "price",
              style: TextStyle(
                color: getBlackMate(),
                fontFamily: "ubuntur",
                fontSize: 20,
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        Column(
          children: oc.serviceid.map((e){

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  .doc(oc.vendorid)
                  .collection("service")
                  .doc(e).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.hasData)
                {


                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,0,5),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              "${snapshot.data?.data()!['servicename']}",
                              style: TextStyle(
                                  color: getBlackMate(),
                                  fontFamily: "ubuntur",
                                  fontSize: 15
                              ),
                            )
                        ),
                        Text(
                          "Rs ${snapshot.data?.data()!['price']} /-",
                          style: TextStyle(
                              color: getBlackMate(),
                              fontFamily: "ubuntur",
                              fontSize: 15
                          ),
                        )
                      ],
                    ),
                  );
                }
                else{
                  return Container();
                }
              },
            );
            return Container();
          }).toList(),
        ),

        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "tax",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "+ Rs ${oc.tax} /-",
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 15
              ),
            )
          ],
        ),

        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "discount",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "- Rs ${oc.disount} /-",
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntur",
                  fontSize: 15
              ),
            )
          ],
        ),





        SizedBox(height: 20,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 2,
          color: getGrey(),
        ),

        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "final total",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntur",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "Rs ${oc.finaltotal} /-",
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 15
              ),
            )
          ],
        ),



        SizedBox(
            height: 15
        ),

        Row(
          children: [
            Expanded(
                child: Text(
                  "total duration",
                  style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 15
                  ),
                )
            ),
            Text(
              "${oc.totalduration} Minutes",
              style: TextStyle(
                  color: getBlackMate(),
                  fontFamily: "ubuntub",
                  fontSize: 15
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget getRatingContainer()
  {
    return Container(
      width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: getLightGrey(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Rate service",
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 20
                    )
                  ),
                ),

                IconButton(
                  icon: Icon(
                      Icons.send,
                      color: getMateGold(),
                    size: 20,
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      postReview(_review_comment.text,rate.toString());
                    }
                  },

                ),
              ],
            ),

            SizedBox(height: 15,),

            Row(
              children: [
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  itemSize: 20,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: getMateGold(),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                ),


                Text(
                  "  $rate",
                  style: TextStyle(
                    color: getMateGold(),
                    fontSize: 20,
                    fontFamily: "ubuntub",

                  ),
                ),
              ],
            ),

            SizedBox(height:10,),

            Form(
                key: _formKey,
                child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextFormField(
                          controller: _review_comment,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your business name';
                            }
                            // else if(!isEmail(value!)){
                            //   return 'please enter valid email';
                            // }

                            return null;
                          },
                          style: TextStyle(
                              color: getBlackMate(),
                              fontSize: 20/getScaleFactor(context),
                              fontFamily: "ubuntur",
                              fontWeight: FontWeight.bold
                          ),

                          keyboardType: TextInputType.emailAddress,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "comment....",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2,
                                    color: getBlackMate()),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2,
                                    color: getBlackMate())
                            ),
                          ),
                        ),
                      ),
                    ]
                )
            )
          ],
        )
    );
  }

  postReview(String comment,String rate){

    print("suserid  = ${oc.userid}");
    print("vendorid  = ${oc.vendorid}");
    print("orderid  = ${oc.orderid}");

    oc.postReview(oc.userid,oc.vendorid,oc.orderid,comment,rate).then((value){
      showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "review submited",
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


  Future<void> generatePdf()
  async {

    print("lcenv;ndvm ${listService.length}");
    if(salondata.isNotEmpty) {
      final date = DateTime.now();
      final dueDate = date.add(Duration(days: 7));

      final invoice = Invoice(
        supplier: Supplier(
          name: '${salondata['businessName']}',
          address: '${salondata['address']}',
          paymentInfo: 'non',
        ),
        customer: Customer(
          name: '${userdata['firstname']} ${userdata['lastname']}',
          address: '$useraddress',
        ),
        info: InvoiceInfo(
          date: date,
          dueDate: dueDate,
          description: 'My description...',
          number: '${DateTime
              .now()
              .year}-9999',
          orderid: "",
        ),
        // items: [
        //   InvoiceItem(
        //       description: 'Service name1',
        //       date: DateTime.now(),
        //       starttime: DateTime.now(),
        //       unitPrice: 10.99,
        //       discount: 5,
        //       serviceid: ""
        //   ),
        //
        //   InvoiceItem(
        //       description: 'Service name2',
        //       date: DateTime.now(),
        //       starttime: DateTime.now(),
        //       unitPrice: 25.00,
        //       discount: 3,
        //       serviceid: ""
        //   ),
        // ],

        items: listService.map((e) => InvoiceItem(
                description: '${e['servicename']}',
                date: DateFormat("dd - mm - yyyy").parse(oc.selecteddate),
                starttime: DateFormat("HH : mm").parse(oc.starttime),
                unitPrice: double.parse(e['price']),
                discount: e['discountavailable'] == "true" ? double.parse(e['discount'].toString()) : 0.0,
                serviceid: "${e['serviceid']}"
            ),).toList(),
      );

      final pdfFile = await PdfInvoiceApi.generate(invoice);

      PdfApi.openFile(pdfFile);
    }
  }


  void getUserData()
  {
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((value){
      setState((){
        userdata = value.data()!;
      });
    });
  }

  @override
  void initState() {
    listService = [];
    print("init state");
    getUserData();
    getServiceData();
    checkIsReviewPresent();


    GeoCode().reverseGeocoding(latitude: double.parse(oc.lat), longitude: double.parse(oc.log)).then((value){
      setState(() {
        useraddress = "${value.streetNumber}, ${value.city}, ${value.postal}";
      });
    });
    super.initState();
  }

  void getServiceData()
  {
    oc.serviceid.forEach((element) {
      FirebaseFirestore.instance.collection("services").doc(oc.vendorid).collection("service").doc(element).get().then((value){
        setState((){
          listService.add(value.data());
        });
      });  
    });
  }
  
  void checkIsReviewPresent()
  {
    FirebaseFirestore.instance.collection("business")
        .doc(oc.vendorid)
        .collection("review")
        .where("orderid",isEqualTo: oc.orderid)
        .get().then((value){

          if(!value.docs.isEmpty)
          {
            setState(() {
              _showReviewBox = 1;
            });
          }
    });
        
  }


  _CompleteOrder(this.oc);

  OrderClass oc;

  double rate = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _review_comment = TextEditingController();
  Map salondata = new Map();
  Map userdata = new Map();

  String useraddress = "";

  var listService = [];

  int _showReviewBox = 0;

  
  
}