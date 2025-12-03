import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallingPage extends StatelessWidget {
  const CallingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/callingbg.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 70),
                const Text(
                  'Pick Me',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFEE4A7),
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.amberAccent,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _RoundAction(
                        color: Colors.red,
                        text: 'Decline',
                      ),
                      _RoundAction(
                        color: Colors.green,
                        text: 'Accept',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  final Color color;
  final String text;
  const _RoundAction({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 85,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 6,
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
