import 'package:bloc/bloc.dart';
import 'package:fic12_fe/data/data_resources/product_local_data_source.dart';
import 'package:fic12_fe/data/data_resources/product_remote_data_source.dart';
import 'package:fic12_fe/data/models/response/category_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRemoteDataSource dataSource;
  List<Category> categories = [];
  CategoryBloc(this.dataSource) : super(const _Initial()) {
    on<_GetCategories>(_getCategories);
    on<_GetCategoriesLocal>(_getCategoriesLocal);
  }

  Future<void> _getCategories(
    _GetCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const _Loading());
    final result = await dataSource.getCategories();
    result.fold(
      (error) => emit(_Error(message: error)),
      (success) => emit(
        _Loaded(categories: success.data),
      ),
    );
  }

  Future<void> _getCategoriesLocal(
    _GetCategoriesLocal event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const _Loading());
    categories = await ProductLocalDataSource.instance.getAllCategories();
    emit(_LoadedLocal(categories: categories));
  }
}
