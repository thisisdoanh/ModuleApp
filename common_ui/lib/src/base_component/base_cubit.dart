import 'package:dependency/dependency.dart';

import 'base_state.dart';

/// Base class for all Cubits in the monorepo.
///
/// Provides [safeEmit] to prevent emitting after the cubit is closed,
/// which avoids the common `Bad state: Cannot emit new states after calling close` error.
abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  BaseCubit(super.initialState);

  bool _isClosed = false;

  /// Emits [state] only if the cubit has not been closed.
  @protected
  void safeEmit(S state) {
    if (!_isClosed) emit(state);
  }

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  @mustBeOverridden
  Future<void> load() async {}
}
