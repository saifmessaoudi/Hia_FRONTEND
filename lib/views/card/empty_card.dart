import 'package:gap/gap.dart';
import 'package:hia/constant.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/widgets/smart_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
      backgroundColor: kMainColor,
      body: Consumer<UserViewModel>(
        builder: (context, controller, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(120),
              Image.asset(
                "images/emptyCard.png",
                width: 264,
                height: 277,
              ),
              const Gap(20),
             const Text("Your Card is Empty",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold)),
              const Gap(30),
              const Text(
                "Start Shopping and Fill it with Amazing Finds!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              ),
              const Gap(40),
                ButtonGlobal(
                  buttonTextColor: kMainColor,
                    buttontext: 'Go Shopping',
                    buttonDecoration: kButtonDecoration.copyWith(
                     color: Colors.white,
                    ),
                    onPressed: () {
                    Home.of(context)?.updateSelectedIndex(0);
                  },
                ),  
                const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
