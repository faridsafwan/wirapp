// import 'package:flutter/material.dart';
// import 'package:wiprapp/views/eventRecord_list.dart';

// class Organiser extends StatefulWidget {
//   @override
//   _OrganiserState createState() => _OrganiserState();
// }

// class _OrganiserState extends State<Organiser> {
//   bool _isLoading = false;

//   TextEditingController _orgIDController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Organiser')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             SizedBox(
//               width: double.infinity,
//               height: 35,
//               child: TextField(
//                 decoration: InputDecoration(hintText: 'Enter Organizer ID'),
//                 controller: _orgIDController,
//               ),
//             ),
//             SizedBox(height: 50.0),
//             SizedBox(
//               width: double.infinity,
//               height: 35,
//               child: RaisedButton(
//                   onPressed: () async {
//                     Navigator.of(context)
//                         .push(MaterialPageRoute(builder: (_) => EventRecordList()));
//                   },
//                   child: Text(
//                     "Submit",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   color: Theme.of(context).primaryColor),
//             ),
//             Padding(
//                     padding: EdgeInsets.only(top: 50),
//               child: Text("New Organiser ? Register Here"),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
