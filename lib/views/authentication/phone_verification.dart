
import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/views/authentication/otp_form.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, top: 60.0, right: 10.0),
                  child: SizedBox(
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify your mobile number',
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Enter 4-digit code sent to your mobile number',
                            style: kTextStyle.copyWith(
                              color: white,
                            ),
                          ),
                          Text(
                            '+8801855671615',
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Expanded(
                  child: Container(
                    width: context.width(),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        const OtpForm(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Try again in 28 seconds',
                          style: kTextStyle.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ButtonGlobal(
                          buttontext: 'Verify',
                          buttonDecoration:
                          kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: (){
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
