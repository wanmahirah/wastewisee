import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  final List<String> bannerImages = [
    'assets/banner_image1.jpg',
    'assets/banner_image2.jpg',
    'assets/banner_image3.jpg',
  ];

  final List<Map<String, String>> features = [
    {
      'title': 'IoT Integration',
      'description':
      'Integrate Internet of Things to enable efficient waste management solutions.',
    },
    {
      'title': 'Real-time Monitoring',
      'description':
      'Monitor waste collection and management processes in real-time for better control.',
    },
    {
      'title': 'Waste Analytics',
      'description':
      'Analyze collected data to derive insights and optimize waste management strategies.',
    },
    {
      'title': 'Automated Collection',
      'description':
      'Implement automated collection methods to streamline waste pickup processes.',
    },
    // Add more features and descriptions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile screen
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              // Navigate to Route Overview screen
            },
          ),
          IconButton(
            icon: Icon(Icons.checklist_rtl),
            onPressed: () {
              // Navigate to Collection Status screen
            },
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // Navigate to Help Center screen
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to Settings screen
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Navigate to About Us screen
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 350, // Adjust the height as needed
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      viewportFraction: 1.0,
                    ),
                    items: bannerImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20), // Adjust spacing between carousel and features

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Features Overview',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // Placeholder for feature list
                        SingleChildScrollView(
                          child: Column(
                            children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: features.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    features[index]['title'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    features[index]['description'] ?? '',
                                  ),
                                  leading: Icon(Icons.check_circle), // Replace with your icon
                                );
                              },
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(
              '© 2024 Waste Wise',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
