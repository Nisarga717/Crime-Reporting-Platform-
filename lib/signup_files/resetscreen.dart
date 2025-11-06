import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login_files/loginscreen.dart';
import '../../utils/constants/helperfunctions.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';


class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: ()=>Get.back(), icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body:  SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(TextSizes.defaultSpace),
            child: Column(children: [
              Image(
                image: const AssetImage(TImages.resendemail),
                width: THelperFunction.screenWidth(context) * 0.6,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ), Text( email,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                TText.changepw,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text(
                TText.changepwsub,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed:()=>Get.offAll(()=> const LoginScreen()),child: const Text("Done"),),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (){},
                  //onPressed:()=> ForgetPasswordController.instance.resendPasswordResetEmail(email),
                  child: const Text("Re-send Email",style: TextStyle(color: Colors.lightGreen),),
                ),
              ),

            ],),),
        )
    );
  }
}
