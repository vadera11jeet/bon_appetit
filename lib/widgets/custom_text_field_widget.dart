import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final String hintText,image;
  final int maxLine;
  final Function onChange;
  final Function validator;
  CustomTextField({this.hintText,this.image,this.maxLine,this.onChange,this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: Container(
        child: Card(
          child: ListTile(
            leading: SvgPicture.asset("images/$image",color: Colors.teal[400]),
            title: TextFormField(
              validator: validator,
              cursorColor: Colors.teal[400],
              maxLines: maxLine,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey,fontSize: 18.0),
                hintText: hintText,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: onChange,
            ),
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 7.0,
              color: Colors.grey.withOpacity(.1),
              offset: Offset(1.5, 2.0),
            ),
          ],
        ),
      ),
    );
  }
}