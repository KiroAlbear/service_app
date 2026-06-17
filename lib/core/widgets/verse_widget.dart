import 'package:flutter/material.dart';

class VerseWidget extends StatelessWidget {
  final String verse;
  final String verseLocation;
  const VerseWidget({
    required this.verse,
    required this.verseLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xfffdfcf9),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xfff7ead2), width: 0.7),
      ),
      child: Column(
        children: [
          Text(
            verse,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff111C2A),
              fontSize: 18,
              height: 1.65,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
          ),

          SizedBox(height: 12),

          Text(
            verseLocation,
            style: TextStyle(
              color: Color(0xff6D541D),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
