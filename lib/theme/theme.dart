import 'package:flutter/material.dart';

// Light Theme (Brown & White)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.brown[500],
  scaffoldBackgroundColor: Colors.brown[100],
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

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 16, color: Colors.brown[800]),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown.shade400, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown.shade700, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade900, width: 2.0),
    ),
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(fontSize: 16, color: Colors.brown[900]),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[500];
      return Colors.brown[300];
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: Colors.brown.shade600, width: 1.5),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[600]!;
      return Colors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[300]!;
      return Colors.grey.shade400;
    }),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.brown,
    selectionColor: Colors.brown.shade200,
    selectionHandleColor: Colors.brown.shade700,
  ),

  dialogTheme: DialogTheme(
    backgroundColor: Colors.brown[100],
    titleTextStyle: TextStyle(color: Colors.brown[900], fontSize: 20, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.brown[800], fontSize: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.brown[100],
    textStyle: TextStyle(color: Colors.brown[900], fontSize: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.brown[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
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
    toolbarHeight: 40,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
    bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
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
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 16, color: Colors.brown[100]),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown.shade800, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown.shade700, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown.shade400, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(fontSize: 16, color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[700];
      return Colors.brown[400]!;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: Colors.brown.shade200, width: 1.5),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[300]!;
      return Colors.grey.shade600;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.brown[700]!;
      return Colors.grey.shade800;
    }),
  ),


  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.brown[300],
    selectionColor: Colors.brown[700],
    selectionHandleColor: Colors.brown[500],
  ),
);

