import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/Api.dart';
import 'package:news_app/model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
   final NewsRepository repository;
   
  NewsBloc(this.repository) : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {emit(NewsLoading());
      try {
        final articles = await repository.fetchTopHeadlines();
        emit(NewsLoaded(articles));
      }  catch (e, stackTrace) {
        // Log the exact error and stack trace
        print("Error in NewsBloc: $e");
        print("Stack Trace: $stackTrace");
        emit(NewsError("Failed to fetch news"));
      }
    
    });
  }
}
