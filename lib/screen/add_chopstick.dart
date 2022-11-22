// import 'package:flutter/material.dart';

// enum FlutterLogoColor { red, blue }

// class AddChopstick extends StatefulWidget {
//   const AddChopstick({Key? key}) : super(key: key);
//   @override
//   _AddChopstickState createState() => _AddChopstickState();
// }

// class _AddChopstickState extends State<AddChopstick> {
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text('START'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               child: DragTarget(
//                 builder: (context, List<FlutterLogoColor> candidateData,
//                     rejectedData) {
//                   return Container(
//                     height: 50.0,
//                     width: 50.0,
//                     decoration: BoxDecoration(
//                         color: Colors.yellow[600], shape: BoxShape.circle),
//                     child: Icon(
//                       Icons.delete,
//                       size: 40,
//                       color: Colors.white70,
//                     ),
//                   );
//                 },
//                 onWillAccept: (data) {
//                   if (data == FlutterLogoColor.red) {
//                     return true;
//                   } else {
//                     _scaffoldKey.currentState.showSnackBar(SnackBar(
//                       content: Text("Not Allowed!"),
//                       duration: Duration(seconds: 1),
//                     ));
//                     return false;
//                   }
//                 },
//                 onAccept: (data) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(
//                     content: Text("Deleted!"),
//                     duration: Duration(seconds: 1),
//                     backgroundColor: Colors.red,
//                   ));
//                 },
//               ),
//             ),
//             Container(
//               height: 100.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Draggable(
//                   child: FlutterLogo(
//                     size: 50.0,
//                     // colors: Colors.red,
//                   ),
//                   feedback: FlutterLogo(
//                     size: 50.0,
//                     // colors: Colors.red,
//                   ),
//                   childWhenDragging: FlutterLogo(
//                     // colors: Colors.blueGrey,
//                     size: 50.0,
//                   ),
//                   data: FlutterLogoColor.red,
//                 ),
//                 Draggable(
//                   child: FlutterLogo(
//                     size: 50.0,
//                   ),
//                   feedback: FlutterLogo(
//                     size: 50.0,
//                   ),
//                   childWhenDragging: FlutterLogo(
//                     // colors: Colors.blueGrey,
//                     size: 50.0,
//                   ),
//                   data: FlutterLogoColor.blue,
//                 ),
//               ],
//             ),
//             Container(
//               height: 100.0,
//             ),
//             Container(
//               child: DragTarget(
//                 builder: (context, List<FlutterLogoColor> candidateData,
//                     rejectedData) {
//                   return Container(
//                     height: 50.0,
//                     width: 50.0,
//                     decoration: BoxDecoration(
//                         color: Colors.yellow[600], shape: BoxShape.circle),
//                     child: Icon(
//                       Icons.move_to_inbox,
//                       size: 40,
//                       color: Colors.white70,
//                     ),
//                   );
//                 },
//                 onWillAccept: (data) {
//                   return true;
//                 },
//                 onAccept: (data) {
//                   _scaffoldKey.currentState.showSnackBar(SnackBar(
//                     content: Text("Archived!"),
//                     duration: Duration(seconds: 1),
//                     backgroundColor: data == FlutterLogoColor.blue
//                         ? Colors.lightBlue
//                         : Colors.red,
//                   ));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
