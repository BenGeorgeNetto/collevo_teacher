import 'package:collevo_teacher/models/request.dart';
import 'package:flutter/material.dart';

class PreviousRequestCard extends StatelessWidget {
  final Request request;
  const PreviousRequestCard({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageMaxSize = 800;
    double preferredSize = MediaQuery.of(context).size.width * 0.5;
    double sizedBoxSize = MediaQuery.of(context).size.height * 0.05 / 4;
    double imageSize =
        preferredSize > imageMaxSize ? imageMaxSize : preferredSize;
    preferredSize > imageMaxSize ? imageMaxSize : preferredSize;
    double screenWidth = MediaQuery.of(context).size.width;
    double desiredWidth = screenWidth * 0.8;
    double maxWidth = 1400;
    double containerWidth = desiredWidth > maxWidth ? maxWidth : desiredWidth;
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: containerWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Request Date: ${request.createdAt.day.toString().padLeft(2, '0')}-${request.createdAt.month.toString().padLeft(2, '0')}-${request.createdAt.year}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: sizedBoxSize),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: imageSize,
                        child: Image.network(
                          request.imageUrl,
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
