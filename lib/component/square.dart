import 'package:chess/component/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget{
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context){
    Color? squareColor;

    if(isSelected){
      squareColor = Colors.green;
    }
    else if (isValidMove){
      squareColor = Colors.green[300];
    }
    else{
      squareColor = isWhite ? foreground : background;
    }


    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isWhite ? foreground : background,
        child: piece != null
            ? Image.asset(
          piece!.imagePath,
          color: piece!.isWhite ? Colors.white : Colors.black,
        ) : null,
      ),
    );
  }
}