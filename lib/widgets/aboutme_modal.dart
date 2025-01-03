import 'package:entryflow/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:entryflow/theme/colors.dart'; // theme specific colors

class AboutMeModal extends StatelessWidget {
  const AboutMeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 20,
        color: AppColors.aboutMeBackgroundColor(Theme.of(context).brightness),
        shadowColor: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            children: [
              Text('About',
                  style: TextStyle(
                      color: AppColors.aboutMeTextColor(
                          Theme.of(context).brightness),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('ICT Group Task',
                  style: TextStyle(
                    color: AppColors.aboutMeTextColor(
                        Theme.of(context).brightness),
                  )),
              Text('by Dashnyam Batbayar',
                  style: TextStyle(
                    color: AppColors.aboutMeTextColor(
                        Theme.of(context).brightness),
                  )),
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          overlayColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          BaseController.to
                              .linkNeeh('https://github.com/xicko');
                        },
                        icon: Icon(
                          FontAwesomeIcons.github,
                          color: AppColors.aboutMeTextColor(
                              Theme.of(context).brightness),
                          size: 24,
                        )),
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          overlayColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          BaseController.to
                              .linkNeeh('https://linkedin.com/in/dashnyam');
                        },
                        icon: Icon(
                          FontAwesomeIcons.linkedin,
                          color: AppColors.aboutMeTextColor(
                              Theme.of(context).brightness),
                          size: 24,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
