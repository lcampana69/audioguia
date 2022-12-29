import 'dart:typed_data';
import 'package:flutter/material.dart';
class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}

class Login extends StatefulWidget {
  final void Function(String user, String email, String password, bool male)
  fncOnSigIn;
  final void Function(String email, String password) fncOnLogin;
  final void Function(String email) fncOnForgotPassword;
  final void Function() fncOnLogoTap;
  final Uint8List image;
  final Uint8List logo;
  final int passwordLen;
  final bool withSigin;
  final Map<String,String> texts;
  final Color color;
  const Login(
      {required this.fncOnSigIn,
        required this.fncOnLogoTap,
        required this.fncOnLogin,
        required this.fncOnForgotPassword,
        required this.image,required this.logo,
        required this.passwordLen,required this.withSigin,required this.texts,required this.color,
        Key? key})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool viewPassword;
  late bool isMale;
  late bool isSignupScreen;
  late TextEditingController userCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;
  late TextEditingController passwordRCtrl;
  late bool editing;
  @override
  void initState() {
    editing=false;
    viewPassword = false;
    isMale = true;
    isSignupScreen = false;
    userCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    passwordRCtrl = TextEditingController();
    super.initState();
  }

//***********************************************************************************
  @override
  void dispose() {
    userCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    passwordRCtrl.dispose();
    super.dispose();
  }

//***********************************************************************************
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double w = screenSize.width;
    final double h = screenSize.height;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: h*.45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: Image.memory(widget.image).image, fit: BoxFit.fill)),
              child: Container(
                padding:  EdgeInsets.only(top: h*.08, left: w*.05),
                color: widget.color.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: widget.texts["welcome"],
                          style:  TextStyle(
                            fontSize: h*.044,
                            letterSpacing: 2,
                            color: Palette.backgroundColor,
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? "${widget.texts["welcome_to"]}," : ",",
                              style:  TextStyle(
                                fontSize: h*.045,
                                fontWeight: FontWeight.bold,
                                color: Palette.backgroundColor,
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: h*.015,
                    ),
                    Text(
                      isSignupScreen
                          ? widget.texts["signup"]!
                          : widget.texts["login"]!,
                      style: const TextStyle(
                        letterSpacing: 1,
                        fontStyle: FontStyle.italic,
                        color: Palette.backgroundColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          _buildBottomHalfContainer(true,h,w),
          Container(
            height: isSignupScreen ? h*.58 : h*.39,
            padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
            width: w - 40,
            margin:  EdgeInsets.only(left: w*.06,right: w*.06,top: h*.30,),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5),
                ]),
            child: SingleChildScrollView(
              physics:BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              widget.texts["login_title"]!,
                              style: TextStyle(
                                  fontSize: h*.025,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1),
                            ),
                            if (!isSignupScreen)
                              Container(
                                margin:  EdgeInsets.only(top: h*.005),
                                height: h*.005,
                                width: w*.33,
                                color: widget.color,
                              )
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if(widget.withSigin) {
                            setState(() {
                              isSignupScreen = true;
                            });
                          }
                        },
                        child: Column(
                          children: [
                            Text(
                              widget.texts["signup_title"]!,
                              style: TextStyle(
                                  fontSize: h*.025,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1),
                            ),
                            if (isSignupScreen)
                              Container(
                                margin:  EdgeInsets.only(top: h*.005),
                                height: h*.005,
                                width: w*.33,
                                color:widget.color,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h*.01,),
                  if (isSignupScreen) _buildSignupSection(h,w),
                  if (!isSignupScreen) _buildSigninSection(h,w),
                ],
              ),
            ),
          ),

          _buildBottomHalfContainer(false,h,w),

          Positioned(
            top: 2,
            right: 2,
            child:InkWell(onTap: (){
              widget.fncOnLogoTap();
            },child: Image(height:h*.1,width:h*.1,image:Image.memory(widget.logo).image, fit: BoxFit.contain)) ,
          ),
        ],
      ),
    );
  }

//***********************************************************************************
  Widget _buildSigninSection(double h, double w) {
    return Column(
      children: [
        _buildTextField(emailCtrl, Icons.mail_outline, "${widget.texts["email"]}", false, true,h,w),
        _buildTextField(passwordCtrl, Icons.lock_outline,
            "${widget.texts["password"]} (>${widget.passwordLen - 1} car)", true, false,h,w),
        Container(
          margin:  EdgeInsets.only(top: h*.01),
          child: TextButton(
            onPressed: () {
              if (_checkEmail(emailCtrl.text)) {
                widget.fncOnForgotPassword(emailCtrl.text);
              } else {
                _error(widget.texts["error_email"]!);
              }
            },
            child:  Text(widget.texts["forgot_password"]!,
                style: TextStyle(fontSize: h*.017, color: Palette.textColor1)),
          ),
        )
      ],
    );
  }

//***********************************************************************************
  Widget _buildSignupSection(double h, double w) {
    return Column(
      children: [
        _buildTextField(userCtrl, Icons.account_circle_outlined,
            widget.texts["user"]!, false, false,h,w),
        _buildTextField(emailCtrl, Icons.email_outlined,
            widget.texts["email"]!, false, true,h,w),
        _buildTextField(passwordCtrl, Icons.lock_outline,
            "${widget.texts["password"]!} (>${widget.passwordLen - 1} car)", true, false,h,w),
        _buildTextField(passwordRCtrl, Icons.lock_open_outlined,
            widget.texts["repeat_password"]!, true, false,h,w),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = true;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: w*.08,
                      height:w*.08,
                      margin: EdgeInsets.only(right: w*.01),
                      decoration: BoxDecoration(
                          color: isMale
                              ? Palette.textColor2
                              : Colors.transparent,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Colors.transparent
                                  : Palette.textColor1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: h*.035,
                        color: isMale ? Colors.white : Palette.iconColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.texts["male"]!,
                        style: TextStyle(color: Palette.textColor1,fontSize: h*.0155),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              flex:1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = false;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: w*.08,
                      height:w*.08,
                      margin:  EdgeInsets.only(right: w*.01),
                      decoration: BoxDecoration(
                          color: isMale
                              ? Colors.transparent
                              : Palette.textColor2,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Palette.textColor1
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: h*.035,
                        color: isMale ? Palette.iconColor : Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.texts["female"]!,
                        style: TextStyle(color: Palette.textColor1,fontSize: h*.0155),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Row(
                children: [
                  SizedBox(
                    height: w*.08,
                    width: w*.08,
                    child: Checkbox(
                        materialTapTargetSize:  MaterialTapTargetSize.shrinkWrap,
                        activeColor: Palette.textColor2,
                        value: viewPassword,
                        onChanged: (value) {
                          setState(() {
                            viewPassword = value!;
                          });
                        }),
                  ),
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size:h*.036,
                    color: Palette.iconColor,
                  )
                ],
              ),
            ),

          ],
        ),

        Container(
          width: w*.7,
          margin:  EdgeInsets.only(top: h*.015,),
          child: RichText(
            textAlign: TextAlign.center,
            text:  TextSpan(
                text: widget.texts["agreement_1"]!,
                style: TextStyle(color: Palette.textColor2,fontSize: h*.023),
                children: [
                  TextSpan(
                    //recognizer: ,
                    text: widget.texts["agreement_2"]!,
                    style: TextStyle(color: Colors.orange),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

//***********************************************************************************
  Widget _buildBottomHalfContainer(bool showShadow,double h, double w) {
    return AnimatedContainer(
      margin: EdgeInsets.only(top:isSignupScreen?h*.82:h*.63,left: w*.36,right: w*.36),
      height: h*.13,
      width: h*.13,
      padding:  EdgeInsets.all(h*.02),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            if (showShadow)
              BoxShadow(
                color: Colors.black.withOpacity(.3),
                spreadRadius: 1.5,
                blurRadius: 10,
              )
          ]),
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutCirc,
      child: !showShadow
          ? Container(
        decoration: BoxDecoration(
            gradient:  LinearGradient(
                colors: [widget.color, widget.color, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: IconButton(
          onPressed: () {
            if (isSignupScreen) {
              if (_checkEmail(emailCtrl.text) &&
                  userCtrl.text.isNotEmpty &&
                  passwordCtrl.text.isNotEmpty && passwordRCtrl.text==passwordCtrl.text &&
                  passwordCtrl.text.length >= widget.passwordLen) {
                widget.fncOnSigIn(userCtrl.text, emailCtrl.text,
                    passwordCtrl.text, isMale);
              } else {
                _errorSelection();
              }
            } else {
              if (_checkEmail(emailCtrl.text) &&
                  passwordCtrl.text.isNotEmpty &&
                  passwordCtrl.text.length >= widget.passwordLen) {
                widget.fncOnLogin(
                    emailCtrl.text, passwordCtrl.text);
              } else {
                _errorSelection();
              }
            }
          },
          icon: const Icon(Icons.arrow_forward),
          color: Colors.white,
        ),
      )
          : const Center(),
    );
  }

//***********************************************************************************
  bool _checkEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  //***********************************************************************************
  void _errorSelection() {
    if (isSignupScreen) {
      if(!_checkEmail(emailCtrl.text)){
        _error(widget.texts["error_email"]!);
        return;
      }
      if(passwordCtrl.text.length<widget.passwordLen) {
        _error(
            'Por favor, revise el tamaño del password (>${widget.passwordLen -
                1})');
        return;
      }
      if(passwordRCtrl.text!=passwordCtrl.text){
        _error(widget.texts["error_eq_password"]!);
        return;
      }
      _error(widget.texts["error_user"]!);

    }else{
      if(!_checkEmail(emailCtrl.text)){
        _error(widget.texts["error_email"]!);
        return;
      }
      if(passwordCtrl.text.length<widget.passwordLen) {
        _error(
            '${widget.texts["error_len_password"]!} (>${widget.passwordLen -
                1})');
      }
    }
  }

//***********************************************************************************
  void _error(String str) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
      Row(
        children: [
          Expanded(flex:1,child: Icon(Icons.error_outline_outlined,color: Colors.red,size: 30,)),
          Expanded(flex:6,child: Text(str)),
        ],
      ),
      backgroundColor: widget.color.withOpacity(0.9),
    ));
  }

//***********************************************************************************
  Widget _buildTextField(TextEditingController ctrl, IconData icon,
      String hintText, bool isPassword, bool isEmail,double h, double w) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        onEditingComplete: (){
          editing=false;
        },
        onTap: (){
          editing=true;
        },
        style: TextStyle(fontSize: h*.02),
        controller: ctrl,
        obscureText: isPassword && !viewPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding:  EdgeInsets.all(h*.002),
          hintText: hintText,
          hintStyle:  TextStyle(fontSize: h*.02, color: Palette.textColor1),
        ),
      ),
    );
  }
}
