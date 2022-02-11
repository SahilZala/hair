
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hair/colors.dart';

class UserHome extends StatefulWidget{
  _UserHome createState ()=> _UserHome();
}

class _UserHome extends State<UserHome> {
  double scaleFactor = 0;
  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor+0.2;
    _widgetOptions = <Widget>[
      getHomePannelContainer(),
      Container(),
      Container()
    ];
    return SafeArea(

        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            onTap: (index) => setState(() => _current_index = index), items: [
              BottomNavigationBarItem(
                  icon: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/h_icon.png"),
                            fit: BoxFit.cover
                        )
                    ),

                  ),
             //   title: Text(""),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart_outlined,color: _current_index != 1 ? getGrey() : getMateGold()),
                //  title: Text(""),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded, color:  _current_index != 2 ? getGrey() : getMateGold()),
                //  title: Text("")
              ),
            ],

          ),
          backgroundColor: getBlackMate(),
          body: _widgetOptions[_current_index],

          appBar: AppBar(
            backgroundColor: getBlackMate(),
            elevation: 0,
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "images/h_icon.png",
                  )
                )
              ),
            ),
            actions: [
              IconButton(onPressed: () {},
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                icon: Icon(
                  Icons.notifications,
                  color: getMateGold(),
                  size: 30,
                ),
              )
            ],
          ),
        )
    );
  }

  Widget getHomePannelContainer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          getHeaderPannel(),
          getServiceContainer()
        ],
      ),
    );
  }

  Widget getHeaderPannel() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        color: getBlackMate(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "hii, alex !",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "ubuntub"
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Lets make your hair attractive",
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: getMateGold(),
                              fontSize: 12,
                              fontFamily: "ubuntub"
                          ),
                        )
                      ],
                    ),
                  )
              ),

              Container(

                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://i.pinimg.com/736x/5f/40/6a/5f406ab25e8942cbe0da6485afd26b71.jpg"
                        )
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                ),
              ),
            ],
          ),

          SizedBox(height: 15,),

          Row(
            children: [
              Expanded(
                  child: Container(
                      child: Form(
                        key: _form_key,
                        child: TextFormField(


                          controller: _search_bar_controller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            else if (value.length < 8) {
                              return 'please enter password length greater then 8';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: getMateGold(),
                            fontSize: 18/scaleFactor,
                            fontFamily: "ubuntur",
                          ),


                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            hintText: "search salon here",
                            hintStyle: TextStyle(
                                color: getMateGold(),
                                fontSize: 18/scaleFactor
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                print("sasa");
                              },
                              icon: Icon(
                                Icons.search_sharp,
                                color: getMateGold(),
                                size: 30,
                              ),

                            ),
                            enabledBorder: OutlineInputBorder(

                              borderSide: BorderSide(width: 2,
                                  color: getMateGold()),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(width: 2,
                                  color: getMateGold()),
                            ),
                          ),
                        ),
                      )
                  )
              ),

              SizedBox(
                width: 10,
              ),

              Container(

                  decoration: BoxDecoration(
                    color: getMateGold(),
                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: IconButton(
                    padding: EdgeInsets.all(0),

                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.filter_alt,
                      size: 35,
                      color: Colors.white,
                    ),
                  )
              ),
            ],
          ),

          SizedBox(height: 20,),

          getHorizontalCatrgoryContainer(),
          SizedBox(height: 20,),
        ],
      ),
    );
  }


  Widget getHorizontalCatrgoryContainer() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Wrap(

        spacing: MediaQuery
            .of(context)
            .size
            .width / 10,
        children: [
          getHorizontalItem("images/cut.png", "hair cut"),
          getHorizontalItem("images/razor.png", "shaving"),
          getHorizontalItem("images/bottole.png", "treatment"),
          getHorizontalItem("images/more.png", "more")
        ],
      ),
    );
  }


  Widget getHorizontalItem(icon, title) {
    return Container(

      child: Column(

        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 52,
            width: 52,
            decoration: BoxDecoration(

              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Image.asset(icon, fit: BoxFit.cover,),
          ),

          SizedBox(height: 8,),
          Text(
            title,
            textAlign: TextAlign.center,
             textScaleFactor: 0.9, style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "ubuntur"
            ),

          ),
        ],
      ),
    );
  }

  Widget getServiceContainer()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,

    //  height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Salon around you",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "see all",
                    textAlign: TextAlign.right,
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getServicWidget(),
                  getServicWidget(),
                ],
              ),
            ),
          ),


          SizedBox(height: 30,),
          Container(
            width: MediaQuery.of(context).size.width,

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Top category",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getBlackMate(),
                      fontFamily: "ubuntub",
                      fontSize: 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "see all",
                    textAlign: TextAlign.right,
                    textScaleFactor: 0.9,
                    style: TextStyle(
                      color: getMateGold(),
                      fontFamily: "ubuntur",
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getServicWidget(),
                  getServicWidget(),
                ],
              ),
            ),
          )


        ],
      ),
    );
  }

  Widget getServicWidget()
  {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
      width: 225,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: getBlackMate(),
      ),

      child: Column(
        children: [
          Container(
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
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [

              Expanded(
                flex: 5,
                child: Text(
                  "Tunning salon",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                      color : Colors.grey,
                      fontFamily: "ubuntur",
                      fontSize: 18
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 12,
                      color: getMateGold(),
                    ),
                    Text(
                      "4.3",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color : getMateGold(),
                          fontFamily: "ubuntur",
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),


          SizedBox(
            height: 5,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 15,
                    color: getMateGold(),
                  ),

                  SizedBox(width: 2,),

                  Text(
                    "salon full addressm ",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color : getMateGold(),
                        fontFamily: "ubuntur",
                        fontSize: 15
                    ),
                  ),

                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  @override
  void initState() {
    _search_bar_controller = TextEditingController();
  }

  var _form_key = GlobalKey<FormState>();
  var _search_bar_controller;
  int _current_index = 0;
  var _widgetOptions = [];


}