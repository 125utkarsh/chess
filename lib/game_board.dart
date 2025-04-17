import 'package:chess/helper/helper_method.dart';
import 'package:chess/component/piece.dart';
import 'package:chess/component/square.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget{
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;
  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  List<List<int>> validMoves = [];

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //place pawn
    for(int i=0; i< 8; i++){
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imagePath: 'images/pawn2.png'
      );
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: true,
          imagePath: 'images/pawn2.png'
      );
    }

    //place rook
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'images/rook2.png'
    );
    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'images/rook2.png'
    );
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'images/rook2.png'
    );
    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'images/rook2.png'
    );

    //place knight
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'images/knight2.png'
    );
    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'images/knight2.png'
    );
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'images/knight2.png'
    );
    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'images/knight2.png'
    );

    //place bishop
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'images/bishop2.png'
    );
    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'images/bishop2.png'
    );
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'images/bishop2.png'
    );
    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'images/bishop2.png'
    );

    //place king
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'images/king2.png'
    );
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'images/king2.png'
    );

    //place queen
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'images/queen2.png'
    );
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'images/queen2.png'
    );



    board = newBoard;
  }

  void pieceSelected(int row , int col) {
    setState(() {
      if(board[row][col] != null){
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      validMoves = calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);

    });
  }

  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece){
    List<List<int>> candidateMoves = [];

    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:

        //pawns can move forward if the square is not occupied
        if(isInBoard(row + direction, col) &&
            board[row + direction][col] == null){
          candidateMoves.add([row + direction, col]);
        }

        //pawns can move 2 square forward if they are at their intial positions
        if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        
        //pawns can kill diagonally
        if(isInBoard(row + direction, col -1) &&
            board[row + direction][col -1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col -1]);
        }
        if(isInBoard(row + direction, col +1) &&
            board[row + direction][col +1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col +1]);
        }


        break;
      case ChessPieceType.rook:
        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;
      default:



    }
    return candidateMoves;

  }

  // ChessPiece myPawn = ChessPiece(
  //     type: ChessPieceType.pawn,
  //     isWhite: false,
  //     imagePath: 'images/pawn2.png'
  // );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {

          int row = index ~/ 8;
          int col = index % 8;

          bool isSelected = selectedRow == row && selectedCol == col;

          return Square(
            isWhite: isWhite(index),
            piece: board[row][col],
            isSelected: isSelected,
            onTap: () => pieceSelected(row ,col),
          );
        }
      ),
    );
  }
}



