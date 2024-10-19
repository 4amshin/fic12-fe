import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.dart';
part 'product_state.dart';
part '../bloc/product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(_Initial()) {
    on<ProductEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
