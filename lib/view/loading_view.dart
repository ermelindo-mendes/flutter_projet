import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipssisqy2023/view/resgister_view.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => _MyLoadingState();
}

class _MyLoadingState extends State<MyLoading> {
  //variable
  PageController pageController = PageController();
  @override
  void iniState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.linear);
      if(pageController.page == 2) {
        timer.cancel();
      }

    });

    super.initState();
  }
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: pageController,
        children: [
          Center(
            child: Lottie.asset("assets/01.json"),
          ),
          Center(
            child: Lottie.asset("assets/02.json"),
          ),
          Center(
            child: Lottie.asset("assets/03.json"),
          ),
          const MyRegisterView(),

        ],
      ),
    );
  }
}


