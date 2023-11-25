import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerComment extends StatelessWidget {
  const ShimmerComment({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28.0,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: double.infinity,
                          height: 14.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 100.0, // Adjust the height as needed
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 50.0,
                    height: 14.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
