import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

 class OptionViewBuilder extends StatelessWidget {
   final BoxConstraints constraint;
   final Iterable<String> options;
   final Function onSelected;
   const OptionViewBuilder({this.constraint, this.options, this.onSelected}) ;

   @override
   Widget build(BuildContext context) {
     return Align(
       alignment: Alignment.topLeft,
       child: Material(
         color: Colors.grey.shade50,
         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
         child: Container(
           width: constraint.biggest.width,
           height: 52.0 * options.length,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
             // border: Border.all(color: Colors.black, width: 1)
           ),
           // width: double.infinity,
           child: ListView.builder(
             shrinkWrap: true,
             itemCount: options.length,
             itemBuilder: (BuildContext context, int index) {
               final item = options.elementAt(index);
               return ListTile(
                 onTap: () {
                   onSelected(item);
                 },
                 title: Text(item, style: const TextStyle(color: Colors.black)),
               );
             },
           ),
         ),
       ),
     );
   }
 }
