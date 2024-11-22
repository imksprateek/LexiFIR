import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatefulWidget {
  final List<Color> containerColors;
  final List<String> titles;

  const CustomCarousel({
    super.key,
    required this.containerColors,
    required this.titles,
  });

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.containerColors
              .map(
                (color) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 6.0,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            color: color,
                            width: double.infinity,
                            height: 200, // Adjust height if needed
                          ),
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                '${widget.titles[widget.containerColors.indexOf(color)]}',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.black45,
                                  color: Colors.white,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.containerColors.map((colors) {
            int index = widget.containerColors.indexOf(colors);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.8)
                    : Color.fromRGBO(0, 0, 0, 0.3),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
