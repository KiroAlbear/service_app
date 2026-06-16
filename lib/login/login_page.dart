import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f8fe),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  const SizedBox(height: 38),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.church_outlined,
                        size: 25,
                        color: Color(0xff001B3A),
                      ),
                      SizedBox(width: 9),
                      Text(
                        'كنيسة مارمرقس جزيرة الوراق ',
                        style: TextStyle(
                          color: Color(0xff001B3A),
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 21),
                    decoration: BoxDecoration(
                      color: const Color(0xfffafeff),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffe0e9f2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اسم المستخدم',
                          style: TextStyle(
                            color: Color(0xff363A3E),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _InputBox(
                          icon: Icons.person_outline,
                          hintText: 'ادخل اسم المستخدم',
                          obscureText: false,
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'كلمة السر',
                          style: TextStyle(
                            color: Color(0xff363A3E),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _InputBox(
                          icon: Icons.lock_outline,
                          hintText: '••••••••',
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xff747C83),
                              size: 22,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff001126),
                              foregroundColor: Colors.white,
                              elevation: 7,
                              shadowColor: Colors.black.withOpacity(0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, size: 19),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 44),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xfffdfcf9),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: const Color(0xfff7ead2),
                        width: 0.7,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -10,
                          top: -19,
                          child: Text(
                            '“',
                            style: TextStyle(
                              fontSize: 88,
                              color: Colors.white.withOpacity(0.13),
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),

                        Column(
                          children: const [
                            Text(
                              '"تَعَالَوْا إِلَيَّ يَا جَمِيعَ الْمُتْعَبِينَ وَالثَّقِيلِي الأَحْمَالِ، وَأَنَا أُرِيحُكُمْ."',
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
                              'متى 28:11',
                              style: TextStyle(
                                color: Color(0xff6D541D),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputBox({
    required this.icon,
    required this.hintText,
    required this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: const Color(0xffe6eff8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        obscureText: obscureText,
        cursorColor: const Color(0xff001126),
        style: const TextStyle(
          color: Color(0xff2E3338),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 10),
          prefixIcon: Icon(icon, color: const Color(0xff83909C), size: 22),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xff87919B),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
