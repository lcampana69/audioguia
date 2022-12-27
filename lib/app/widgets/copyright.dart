
import 'package:flutter/material.dart';

 class Copyright extends StatelessWidget {
   const Copyright({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Container(
       height: 39,
       width: 60,
       child: Image.asset('assets/images/(c)LCF.png',
         fit: BoxFit.cover,
         color: Colors.white.withOpacity(0.6),
         colorBlendMode: BlendMode.modulate,
         filterQuality: FilterQuality.high,
       ),

     );
   }
 }


