import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_newapp/src/blocs/onBoarding/prfil_image_cubit.dart';
import 'package:flutter_newapp/src/presentation/widget/logo.dart';

import '../../../../core/app_color.dart';
import '../../../../core/app_theme.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String username = '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(context),
            const Spacer(),
            Container(
              height: 126.0,
              width: 126.0,
              child: Material(
                color: isLightTheme(context)
                    ? const Color(0xFFF2F2F2)
                    : const Color(0xFF211E1E),
                borderRadius: BorderRadius.circular(126.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(126.0),
                  onTap: () async {
                    await context.read<ProfileImageCubit>().getImage();
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: BlocBuilder<ProfileImageCubit, File?>(
                          builder: (context, state) {
                            return state == null
                                ? Icon(Icons.person_outline_rounded,
                                size: 126.0,
                                color: isLightTheme(context)
                                    ? kIconLight
                                    : Colors.black)
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(126.0),
                              child: Image.file(state,
                                  width: 126,
                                  height: 126,
                                  fit: BoxFit.fill),
                            );
                          },
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.add_circle_rounded,
                          color: kPrimary,
                          size: 38.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Row logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chat',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8.0),
        const Logo(),
        const SizedBox(width: 8.0),
        Text(
          'App',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
