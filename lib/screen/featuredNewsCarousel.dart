import 'package:counter_application_with_bloc/model/news_model.dart';
import 'package:counter_application_with_bloc/screen/singleNewsPage.dart';
import 'package:flutter/material.dart';

class FeaturedNewsCarousel extends StatelessWidget {
  final List<Article> featuredNews;

  FeaturedNewsCarousel({required this.featuredNews});
  String splitTitle(String title, int maxLineLength, int numLines) {
    if (title.length <= maxLineLength * numLines) {
      return title;
    }

    String firstLines = "";
    String lastLine = title;

    for (int i = 0; i < numLines - 1; i++) {
      int index = title.indexOf(' ', maxLineLength * (i + 1));
      if (index == -1) {
        index = title.indexOf(' ', maxLineLength * (i + 1) - 1);
      }

      if (index != -1) {
        firstLines += title.substring(maxLineLength * i, index) + '\n';
        lastLine = title.substring(index + 1);
      } else {
        break;
      }
    }

    return "$firstLines$lastLine...";
  }

  @override
  Widget build(BuildContext context) {
    var scWidth = MediaQuery.of(context).size.width;
    var scHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Featured",
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            Spacer()
          ],
        ),
        Container(
          height: scHeight * 0.42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredNews.length,
            itemBuilder: (context, index) {
              final article = featuredNews[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the single news page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleNewsPage(article: article),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            article.urlToImage,
                            height: scHeight * 0.42,
                            width: scWidth * 0.89,
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            top: 150,
                            child: Container(
                              // color: Colors.black54,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                splitTitle(article.title, 15,
                                    2), // Customize maxLineLength and numLines here
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
