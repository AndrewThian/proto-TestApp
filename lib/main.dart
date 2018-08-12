import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                // renderObject will give the Container
                RenderBox object = context.findRenderObject();
                // request position from details of the gesture
                // convert global to local?
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = new List.from(_points)..add(_localPosition);
              });
            },
            // when stopped drawing, empty the points list
            onPanEnd: (DragEndDetails details) => _points.add(null),
            child: new CustomPaint(
                painter: new FingerPainter(points: _points),
                size: Size.infinite)),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.clear),
        onPressed: () => _points.clear(),
      ),
    );
  }
}

class FingerPainter extends CustomPainter {
  // coordinates of the points
  List<Offset> points = <Offset>[];
  // contructor of current class to save points
  FingerPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    /*
      same syntax as
      Paint paint = new Paint();
      paint.color = Colors.black;
      paint.strokeCap = StrokeCap.round;
      paint.strokeWidth = 5.0;
    */
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      // if starting and ending points are not null
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(FingerPainter oldDelegate) => oldDelegate.points != points;
}
