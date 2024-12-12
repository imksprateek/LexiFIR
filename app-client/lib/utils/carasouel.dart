import 'package:app_client/services/functions/NewsApi.dart';
import 'package:app_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hyperlink/hyperlink.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> linkUrls;
  final List<String> TitleUrls;

  const CustomCarousel(
      {super.key,
        required this.imageUrls,
        required this.linkUrls,
        required this.TitleUrls});

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url); // Convert the string URL to a Uri object
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url); // Use launchUrl with Uri
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle tap event here, for example navigate to the link
            print("Launching URL: ${widget.linkUrls[_currentIndex]}");

            _launchURL(widget.linkUrls[_currentIndex]);

            // You can use Navigator.push or any other logic to handle the tap event
          },
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.imageUrls
                .map(
                  (imageUrl) => Padding(
                padding: const EdgeInsets.all(0),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  elevation: 10.0,
                  shadowColor: AppBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: <Widget>[
                        // Network image
                        Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 200, // Adjust height as needed
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        // Title overlay
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              widget.TitleUrls[
                              widget.imageUrls.indexOf(imageUrl)],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                backgroundColor:
                                const Color.fromARGB(104, 54, 54, 54),
                                color: const Color.fromARGB(
                                    255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.map((url) {
            int index = widget.imageUrls.indexOf(url);
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? const Color.fromRGBO(0, 0, 0, 0.8)
                    : const Color.fromRGBO(0, 0, 0, 0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}