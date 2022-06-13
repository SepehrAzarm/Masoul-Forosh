import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';
import 'package:masoukharid/Constants/text_styles.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.onTap,
    required this.title,
    required this.availableAmount,
    required this.image,
  }) : super(key: key);

  final Function()? onTap;
  final String title;
  final String availableAmount;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Content Picture
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                  ),
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(image),
                    ),
                  ),
                ),
                //Content Text
                SizedBox(
                  height: 100,
                  width: 230,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          title,
                          style: kNewsCardHeaderTextStyle,
                        ),
                      ),
                      //Content Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'تعداد موجود: $availableAmount عدد',
                          style: kNewsCardContentTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                //Left Arrow
                const SizedBox(
                  height: 100,
                  width: 20,
                  // color: Colors.red,
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: kGreyTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
