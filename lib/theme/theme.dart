import 'package:flutter/material.dart';

// Light Theme (Brown & White)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.brown[500],
  scaffoldBackgroundColor: Colors.brown[50],
  appBarTheme: AppBarTheme(
    color: Colors.brown[500],
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white),
    toolbarHeight: 40,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[900]),
    bodyMedium: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.brown[600]),
    bodySmall: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.brown[400]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[400],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.brown[500],
    foregroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[400],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    iconColor: Colors.brown[600],
    textColor: Colors.brown[900],
  ),
  dividerTheme: DividerThemeData(
    color: Colors.brown[200],
    thickness: 1,
  ),

);

// Dark Theme (Dark Browns & Black)
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.brown[900],
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    color: Colors.brown[900],
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white70),
    bodySmall: TextStyle(fontSize: 16, color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[800],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.brown[700],
    foregroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown[800],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.brown[800],
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.brown[800],
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    iconColor: Colors.brown[100],
    textColor: Colors.white,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.brown[700],
    thickness: 1,
  ),



);
