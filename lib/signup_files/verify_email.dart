

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_crime_reporter/signup_files/successscreen.dart';

import '../../login_files/loginscreen.dart';
import '../../utils/constants/helperfunctions.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';



class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key, this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: ()=>Get.offAll(()=>const LoginScreen()),
            //onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TextSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(TImages.verifyemail),
                width: THelperFunction.screenWidth(context) * 0.6,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              //Title subtitle
              Text(
                TText.confirmemail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text("vrukshamsupport@gmail.com",
                //email??"",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text(
                "Congratulations Your Account Awaits!: Verify your Account and Start Snapping the Plants you desire",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              //Buttons
              const SizedBox(height: TextSizes.spacebtwSections,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()=>Get.to(()=> SuccessScreen(image: TImages.success, title:TText.youraccountcreatedtitle, subtitle:TText.youraccountcreatedsubtitle, onPressed:()=>Get.to(const LoginScreen())))
                  //onPressed: ()=> controller.checkEmailVerificationstatus(),
                  ,child: const Text("Continue"),
                ),
              ),
              const SizedBox(
                height: TextSizes.spaceBtwItems,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (){},
                  //onPressed: ()=> controller.sendEmailVerfication(),
                  child: const Text("Resend-Email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
