import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part '../bloc/checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(_Initial()) {
    on<CheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
