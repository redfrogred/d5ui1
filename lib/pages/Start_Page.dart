// ignore_for_file: prefer_const_constructors, camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../classes/Utils.dart';
import '../providers/Controller.dart';

//  https://stackoverflow.com/questions/43877288/how-to-hide-android-statusbar-in-flutter

class Start_Page extends StatefulWidget {
  const Start_Page({ super.key });

  @override
  State createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {

  _Start_PageState() {
    Utils.log( 'Start_Page.dart', 'initialized' );
  }

  // (this page) variables
  static const String _filename = 'Start_Page.dart';

  bool _showCurtain = true; // conceal the HTML until it is loaded...
  bool _allow_click = true;

  List<String> question = [
      'About 4.5 billion years old',
      'Less than 1 billion years',
      'As old as your teeth and a bit older than your tongue',
      '6,000 years or so old',
  ];

  List<bool> viz = [
    true,
    true,
    true,
    true,
  ];


  
  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    Utils.log( _filename, 'initState()' );
    WidgetsBinding.instance.addPostFrameCallback((_) => _addPostFrameCallbackTriggered(context));

    //  init the app
    WidgetsBinding.instance.addPostFrameCallback((_) => _init(context));    
  }

  @override
  void dispose() {
    Utils.log( _filename, 'dispose()');
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  // (this page) methods
  void _buildTriggered() {
    Utils.log( _filename, '_buildTriggered()');
  }
  

  void _init( context ) {
    //  this is called from initState in "Start_Page.dart"...
    //  If it is the first time ever, it will do some housekeeping
    //  with Controller.initApp()
    Provider.of<Controller>(context, listen: false).initApp();
  }

  Expanded _question( int num ) {
    double bottomPadding = 7;
    if ( num < 3 ) {
      bottomPadding = 5;
    }
    double fontSize = 20.0;
    if( num == 2 ) {
      fontSize = 16.0;
    }

    return Expanded(
      flex: 1,
      child: Visibility(
        visible: viz[num],
        child: Padding(
          padding: EdgeInsets.fromLTRB(12,10,12,bottomPadding),
          child: Container(
            color: Color(0xFF6C5B7B),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if ( _allow_click == true ) { 
                  _allow_click = false;
                  viz[0] = false;
                  viz[1] = false;
                  viz[2] = false;
                  viz[3] = false;
                  //  viz[num] = true;
                  setState(() {
                    viz[num] = true;
                  });
                  Timer(Duration( milliseconds: 2000 ), () {
                    setupPage();  
                  });     
                }             
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  question[num],
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  void _addPostFrameCallbackTriggered( context ) {
    Utils.log( _filename, '_addPostFrameCallbackTriggered()');
    setupPage();  
  }

  void setupPage() {
    setState(() {
      _showCurtain = true;  
    });  
    Timer(Duration( milliseconds: 1000 ), () {
      viz = [
        true,
        true,
        true,
        true,
      ];       
      _allow_click = true;
      setState(() {
        _showCurtain = false;  
      });  
    }); 
  }

  // (this page) build
  @override
  Widget build(BuildContext context) {

    _buildTriggered();

    return WillPopScope(
      onWillPop: () async {
        return false;  //  true allows the back button to work
      },
      child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,  
            backgroundColor: Colors.black,//AppBar
            // drawer: DrawerWidget(),
            body: AnimatedOpacity(
                opacity: _showCurtain ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Stack(
                children: [
                  Container(
                    color: Color(0xFF6C5B7B),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            color: Color(0xFF333333),
                            child: Center(child: Padding(
                              padding: const EdgeInsets.fromLTRB(55,15,55,15),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Astronomers believe that Jupiter is how old?',
                                    style: TextStyle(fontSize: 28),
                                    textAlign: TextAlign.center
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,4,0,7),
                            child: Container(
                              width: double.infinity,
                              color: Color(0xFF6C5B7B),
                              child: Column(
                                children: [
                                  _question(0),
                                  _question(1),
                                  _question(2),
                                  _question(3),
                                ],
                              )),
                          )
                        ),                  
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.close, 
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        
                      },
                      style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(32, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center),                    
                    ),
                  ),
                ],  
              ),
            ),
          ),
        ),
    );
  }
}