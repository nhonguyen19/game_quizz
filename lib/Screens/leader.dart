// import 'package:flutter/material.dart';
// import 'package:game_quizz/screens/leaderboard_screen.dart';
// import 'package:game_quizz/screens/nextpage.dart';

// class Leader extends StatelessWidget {
//   const Leader({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         nextpage(context, LeaderboardScreen);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         width: double.infinity,
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(23),
//         ),
//         child: Row(
//           children: <Widget>[
//             SizedBox(
//               width: 100,
//               child: Stack(
//                 children: const [
//                   Positioned(
//                     left: 40,
//                     child: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/114290880/original/4f68e1da26a2753e500f527f986f65f47dd1fd26/draw-bighead-cartoon-caricature-in-48-hours.png'),
//                       radius: 25,
//                     ),
//                   ),
//                   Positioned(
//                     left: 20,
//                     child: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           'https://vi.seaicons.com/wp-content/uploads/2017/03/blue-user-icon.png'),
//                       radius: 25,
//                     ),
//                   ),
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(
//                         'https://hocviendigital.com/wp-content/uploads/2017/01/Model-RACE-Icon-1.png'),
//                     radius: 25,
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'Bảng xếp hạng',
//                   style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'xem hạng người chơi',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff767070)),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
