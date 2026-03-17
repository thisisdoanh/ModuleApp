import 'package:dependency/dependency.dart';

import 'base_cubit.dart';
import 'base_state.dart';

/// Shorthand for [GetIt] lookup — convenience alias for `GetIt.instance<T>()`.
T getIt<T extends Object>() => GetIt.instance<T>();

//-------------- StatefulWidget ---------------------//

/// Tracker log firebase screen display time for StatefulWidget
class _StatefulTrackerElement extends StatefulElement {
  _StatefulTrackerElement(BaseViewStateful super.widget);
}

/// BaseViewStateful:
/// - Hỗ trợ inject cubit từ GetIt hoặc tự tạo thủ công.
/// - Cung cấp onInit, onDispose, onStateChange.
/// - Có thể bật/tắt overlay loading, error.
/// - Lấy được context, cubit, state an toàn.
abstract class BaseViewStateful<T extends BaseCubit<S>, S extends BaseState>
    extends StatefulWidget {
  const BaseViewStateful({super.key});

  /// Nếu true => lấy cubit từ GetIt
  bool get useInjection => false;

  /// Nếu không dùng injection => tạo cubit thủ công
  T createCubit(BuildContext context) => throw UnimplementedError();

  /// Tự inject cubit khi dùng GetIt
  T get injectedCubit => getIt<T>();

  /// UI chính
  Widget buildView(BuildContext context, S state);

  /// UI lỗi (tuỳ chỉnh)
  Widget? get errorView => null;

  /// Khi state thay đổi
  void onStateChange(BuildContext context, S state) {}

  /// Gọi khi widget được khởi tạo
  void initState(T cubit) {}

  /// Gọi sau khi build lần đầu
  void addPostFrameCallback(BuildContext context, T cubit) {}

  /// Gọi khi dispose
  void onDispose(BuildContext context, T cubit) {}

  /// Bật/tắt overlay loading
  bool get enableLoading => true;

  /// Bật/tắt overlay error
  bool get enableError => true;

  /// Tên màn hình (để log analytics)
  String get nameScreen => runtimeType.toString();

  void didChangeDependencies() {}

  @override
  State<BaseViewStateful<T, S>> createState() => _BaseViewStatefulState<T, S>();

  @override
  StatefulElement createElement() {
    return _StatefulTrackerElement(this);
  }
}

class _BaseViewStatefulState<T extends BaseCubit<S>, S extends BaseState>
    extends State<BaseViewStateful<T, S>> {
  late final T cubit;

  BuildContext? _viewContext;
  S? _currentState;

  BuildContext get viewContext => _viewContext ?? context;

  S get currentState => _currentState ?? cubit.state;

  @override
  void initState() {
    super.initState();
    cubit = widget.useInjection ? widget.injectedCubit : widget.createCubit(context);
    widget.initState(cubit);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.addPostFrameCallback(context, cubit);
    });
  }

  @override
  void didChangeDependencies() {
    widget.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.onDispose(context, cubit);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewContext = context;

    return BlocProvider<T>(
      create: (_) => cubit,
      child: BlocConsumer<T, S>(
        listener: (ctx, state) {
          _currentState = state;
          widget.onStateChange(ctx, state);
        },
        builder: (ctx, state) {
          _currentState = state;

          return Stack(
            children: [
              widget.buildView(ctx, state),

              // Loading overlay
              if (widget.enableLoading && state.isLoading)
                Container(
                  color: Colors.black38,
                  child: const Center(child: CircularProgressIndicator()),
                ),

              // Error overlay
              if (widget.enableError && state.errorMessage != null)
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child:
                    widget.errorView ??
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.white, size: 22),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  state.errorMessage ?? 'Have error!!!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

//-------------- StatelessWidget ---------------------//

/// Tracker log firebase screen display time for StatelessWidget
class _StatelessTrackerElement extends StatelessElement {
  _StatelessTrackerElement(BaseViewStateless super.hooks);
}

/// BaseViewStateless:
/// - Hỗ trợ cubit inject hoặc tạo thủ công.
/// - Tích hợp overlay loading + error.
/// - Lấy được state hiện tại từ cubit.
abstract class BaseViewStateless<T extends BaseCubit<S>, S extends BaseState>
    extends StatelessWidget {
  const BaseViewStateless({super.key});

  bool get useInjection => false;

  T createCubit(BuildContext context) => throw UnimplementedError();

  Widget buildView(BuildContext context, S state);

  Widget? get errorView => null;

  bool get enableLoading => true;

  bool get enableError => true;

  T get injectedCubit => getIt<T>();

  String get nameScreen => runtimeType.toString();

  @override
  StatelessElement createElement() {
    return _StatelessTrackerElement(this);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useInjection ? injectedCubit : createCubit(context);

    return BlocProvider<T>(
      create: (_) => cubit,
      child: BlocBuilder<T, S>(
        builder: (context, state) {
          return Stack(
            children: [
              buildView(context, state),

              if (enableLoading && state.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),

              if (enableError && state.errorMessage != null)
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child:
                    errorView ??
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.errorMessage ?? 'Have error!!!',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
