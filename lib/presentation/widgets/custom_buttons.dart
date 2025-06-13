// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// MaterialButton loadingButton({
//   required VoidCallback onPressed,
//   required Color color,
// }) {
//   return MaterialButton(
//     onPressed: onPressed,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30), // Capsule shape
//     ),
//     minWidth: 0.9, // Width of the button
//     height: 0.06, // Height of the button
//     color: color,
//     elevation: 6.0, // Slight shadow for a floating effect
//     padding: EdgeInsets.zero, // Remove vertical padding
//     child: Center(
//       child: SizedBox(
//         height: 30, // Fixed height for the loading animation container
//         child: LoadingAnimationWidget.newtonCradle(
//           color: Colors.white,
//           size: 100, // Use sp for sizing the loading animation dots
//         ),
//       ),
//     ),
//   );
// }
