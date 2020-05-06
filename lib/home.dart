










import 'package:flutter/material.dart';

class Home {
  static int homesCount = 0;
 final  int countWindows = 4;
 final  int countDoors = 3;
 String address;
 Color wallColor;
 Home ({this.wallColor, this.address,}) {
   homesCount++;
 }

}

void main () {
  Home home1 = Home();
  Home home2 = Home();
  home1.address = "улица Ленина, дом 45";
  home2.address = "улица Рождественнская, 13";
  home1.wallColor = Colors.greenAccent;
  home2.wallColor = Colors.red;
  Home home3 = Home(address: "Набережная, 13",
      wallColor: Colors.white);



}