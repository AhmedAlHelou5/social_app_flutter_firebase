// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class NativeCodeScreen extends StatefulWidget {
//   const NativeCodeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NativeCodeScreen> createState() => _NativeCodeScreenState();
// }
//
// class _NativeCodeScreenState extends State<NativeCodeScreen> {
//   static const platform = MethodChannel('samples.flutter.dev/battery');
//   String batteryLevel = 'Unknown battery level.';
//   void _getBatteryLevel()  {
//     platform.invokeMethod('getBatteryLevel').then((value) {
//       setState(() {
//         batteryLevel = value;
//       });
//     }).catchError((e) {
//       setState(() {
//         batteryLevel = 'Failed to get battery level: ${e.message.toString()}';
//       });
//
//       print(e);
//     });
//     // String batteryLevel;
//     // try {
//     //   final int result = await platform.invokeMethod('getBatteryLevel');
//     //   batteryLevel = 'Battery level at $result % .';
//     // } on PlatformException catch (e) {
//     //   batteryLevel = "Failed to get battery level: '${e.message}'.";
//     // }
//
//     setState(() {
//       batteryLevel = batteryLevel;
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _getBatteryLevel,
//               child: const Text('Get Battery Level'),
//             ),
//             Text(batteryLevel),
//           ],
//         ),
//       ),
//     );
//   }
// }
