import 'package:counter_application_with_bloc/bloc/news_bloc.dart';
import 'package:counter_application_with_bloc/screen/singleNewsPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/news_model.dart';
import 'featuredNewsCarousel.dart';

class NewsListScreen extends StatefulWidget {
  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _newsBloc = NewsBloc();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _newsBloc.newsEventSink.add(NewsAction.Fetch);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                _newsBloc.newsEventSink.add(NewsAction.MarkAllRead);
              },
              child: const Text(
                "Mark all read",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              )),
        ],
      ),
      body: StreamBuilder<NewsModel>(
        stream: _newsBloc.newsStateStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching news data.'),
            );
          } else {
            final newsModel = snapshot.data!;
            final featuredNews = newsModel.articles.take(3).toList();
            final latestNews = newsModel.articles.skip(3).toList();

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  if (notification.scrollDelta! < -20) {
                    setState(() {
                      _isCollapsed = true;
                    });
                  } else if (notification.scrollDelta! > 0) {
                    setState(() {
                      _isCollapsed = false;
                    });
                  }
                }
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        // Set a minimum height for the container to ensure visibility of the carousel
                        height: _isCollapsed ? 1 : 370,

                        child: _isCollapsed
                            ? const SizedBox.shrink()
                            : FeaturedNewsCarousel(featuredNews: featuredNews),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Latest news",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = latestNews[index];

                          DateTime publishedAt =
                              DateTime.parse(article.publishedAt).toLocal();
                          DateTime now = DateTime.now();
                          int daysDifference =
                              now.difference(publishedAt).inDays;

                          return ListTile(
                            leading: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    article.urlToImage,
                                    height: 280, // Set your desired height here
                                  ),
                                ),
                                if (!article
                                    .markedRead) // Show indicator for unread articles
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors
                                            .red, // Replace with your desired color
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      // ignore: prefer_const_constructors
                                      child: Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(article.title),
                            subtitle: Text(
                              daysDifference == 0
                                  ? "Today"
                                  : daysDifference == 1
                                      ? "1 day ago"
                                      : "$daysDifference days ago",
                            ),
                            onTap: () {
                              // Navigate to the single news page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleNewsPage(article: article),
                                ),
                              );
                            },
                          );
                        },
                        childCount: latestNews.length,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
