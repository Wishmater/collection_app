import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnyRef {
  final Ref? ref;
  final WidgetRef? widgetRef;

  AnyRef({this.ref, this.widgetRef}) {
    assert(ref != null || widgetRef != null);
  }

  T read<T>(ProviderBase<T> provider) {
    if (ref != null) return ref!.read(provider);
    return widgetRef!.read(provider);
  }

  T watch<T>(AlwaysAliveProviderListenable<T> provider) {
    if (ref != null) return ref!.watch(provider);
    return widgetRef!.watch(provider);
  }

  State refresh<State>(ProviderBase<State> provider) {
    if (ref != null) return ref!.refresh(provider);
    return widgetRef!.refresh(provider);
  }

  void invalidate(ProviderBase<Object?> provider) {
    if (ref != null) return ref!.invalidate(provider);
    return widgetRef!.invalidate(provider);
  }
}
