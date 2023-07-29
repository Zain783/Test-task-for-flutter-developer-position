import 'package:flutter/material.dart';
import '../model/news_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingleNewsPage extends StatelessWidget {
  final Article article;

  SingleNewsPage({required this.article});
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
    Color filteredColor = Color(0xffFFFFFF);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        article.urlToImage,
                        height: scHeight * 0.55,
                        width: scWidth,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: scHeight * 0.39,
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
                      ),
                      Positioned(
                          top: 120,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  filteredColor, BlendMode.srcIn),
                              child: SvgPicture.asset(
                                'assets/Button.svg', // Replace with your SVG file path
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      article.description,
                      style: const TextStyle(fontSize: 18),
                      // textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.content,
                      style: const TextStyle(fontSize: 16),
                    ),
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
