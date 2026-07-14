import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class BudgetCard extends StatelessWidget {
  final String image;
  final String title;
  final String month;
  final double amount;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final Color iconColor;
  final Color amountColor;
  final VoidCallback onTapExpense;

  const BudgetCard({
    super.key,
    required this.image,
    required this.title,
    required this.month,
    required this.amount,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.iconColor,
    required this.amountColor,
    required this.onTapExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: ResponsiveHelper.all(10),
          height: ResponsiveHelper.height(86),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.employeeCardColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomNetworkImage(
                                imageUrl: image,
                                height: ResponsiveHelper.iconSize(20),
                                width: ResponsiveHelper.iconSize(20),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(8)),
                              Flexible(
                                child: CustomText(
                                  text: title,
                                  fontWeight: FontWeight.w400,
                                  fontSize: ResponsiveHelper.fontSize(16),
                                  color: AppColors.blue800,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(8)),
                              Flexible(
                                child: CustomText(
                                  text: '($month)',
                                  fontWeight: FontWeight.w500,
                                  fontSize: ResponsiveHelper.fontSize(12),
                                  color: AppColors.blue900,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(8)),
                        CustomText(
                          text: "$amount",
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(20),
                          color: amountColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    LinearPercentIndicator(
                      lineHeight: ResponsiveHelper.height(8),
                      percent: progress,
                      backgroundColor: backgroundColor,
                      progressColor: progressColor,
                      barRadius: Radius.circular(ResponsiveHelper.borderRadius(8)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(16)),
              GestureDetector(
                onTap: onTapExpense,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.blue900,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: ResponsiveHelper.iconSize(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),
      ],
    );
  }
}