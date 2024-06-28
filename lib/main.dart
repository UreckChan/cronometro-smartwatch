import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});
  
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active ? Colors.black : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.play_arrow,
                color: widget.mode == WearMode.active ? Colors.white : Colors.grey,
                size: 30, // Reemplaza WearMode.active por tu condición
                shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: widget.mode == WearMode.active ? Colors.green :Color.fromARGB(0, 0, 0, 0),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  color: widget.mode == WearMode.active ? Colors.white : Colors.grey,
                  fontFamily: 'RobotoMono', // Fuente monoespaciada para un toque futurista
                  fontSize: 40.0, // Tamaño de fuente ajustado para mayor impacto
                  fontWeight: FontWeight.bold, // Texto en negrita para mayor énfasis
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: widget.mode == WearMode.active ? Colors.green : Color.fromARGB(0, 0, 0, 0),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  letterSpacing: 2.0, // Espaciado entre letras para un aspecto más tecnológico
                ),
              ),
            ),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

 Widget _buildWidgetButton() {
  if (widget.mode == WearMode.active) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Color de fondo del botón
            foregroundColor: Colors.white, // Color del texto del botón
            shadowColor: Colors.blue, // Color de la sombra del botón
            elevation: 10, // Altura de la sombra del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordes redondeados del botón
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Espaciado interno del botón
            textStyle: TextStyle(
              fontSize: 18, // Tamaño de la fuente del texto del botón
              fontWeight: FontWeight.bold, // Peso de la fuente del texto del botón
            ),
          ),
          onPressed: () {
            if (_status == "Start") {
              _startTimer();
            } else if (_status == "Stop") {
              _timer.cancel();
              setState(() {
                _status = "Continue";
              });
            } else if (_status == "Continue") {
              _startTimer();
            }
          },
          child: Text(_status),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Color de fondo del botón
            foregroundColor: Colors.white, // Color del texto del botón
            shadowColor: Colors.red, // Color de la sombra del botón
            elevation: 10, // Altura de la sombra del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordes redondeados del botón
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Espaciado interno del botón
            textStyle: TextStyle(
              fontSize: 18, // Tamaño de la fuente del texto del botón
              fontWeight: FontWeight.bold, // Peso de la fuente del texto del botón
            ),
          ),
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (_timer != null) {
              _timer.cancel();
              setState(() {
                _count = 0;
                _strCount = "00:00:00";
                _status = "Start";
              });
            }
          },
          child: const Text("Reset"),
        ),
      ],
    );
  } else {
    return Container();
  }
}


  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}