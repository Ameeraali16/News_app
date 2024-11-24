import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), 
          ()=>Navigator.pushReplacement(context, 
                                        MaterialPageRoute(builder: 
                                                          (context) =>  
                                                          HomePage() 
                                                         ) 
                                       ) 
         ); 
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset( 
        "lib/world-news.png",
        height: 10, 
        width: 10,
        
          ),
        ),
      )
    );
  }
}