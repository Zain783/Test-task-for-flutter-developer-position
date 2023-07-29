import 'dart:async';

import 'package:counter_application_with_bloc/data/news_api.dart';
import 'package:counter_application_with_bloc/model/news_model.dart';

enum NewsAction { Fetch, Delete, MarkAllRead }

class NewsBloc {
  final _stateStreamController = StreamController<NewsModel>.broadcast();
  StreamSink<NewsModel> get newsStateSink => _stateStreamController.sink;
  Stream<NewsModel> get newsStateStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get newsEventSink => _eventStreamController.sink;
  Stream<NewsAction> get newsEventStream => _eventStreamController.stream;

  NewsBloc() {
    newsEventStream.listen((event) {
      if (event == NewsAction.Fetch) {
        _fetchNews();
      } else if (event == NewsAction.MarkAllRead) {
        _markAllRead();
      }
    }, onError: (e) {
      print('Error in NewsBloc: ${e.toString()}');
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }

  void _fetchNews() async {
    var news = await getNews();
    newsStateSink.add(news);
  }

  void _markAllRead() {
    try {
      print("step 1");
      newsStateStream.toList();
      newsStateStream.first.then((currentState) {
        print("step 112");
        if (currentState != null) {
          print("step 2");
          final List<Article> articles = currentState.articles;

          // Mark all articles as read
          for (var article in articles) {
            article.markedRead = true;
          }

          // Update the state with the modified news model
          newsStateSink.add(currentState);
        }
      }).catchError((e) {
        print('Error in markAllRead: ${e.toString()}');
      });
    } catch (e) {
      print(e.toString());
    }
  }
}