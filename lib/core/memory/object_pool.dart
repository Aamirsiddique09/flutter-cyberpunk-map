class ObjectPool<T> {
  final List<T> _available = [];
  final List<T> _inUse = [];
  final T Function() factory;
  final void Function(T)? reset;
  final int maxSize;

  ObjectPool({
    required this.factory,
    this.reset,
    int initialSize = 5,
    this.maxSize = 20,
  }) {
    for (int i = 0; i < initialSize; i++) {
      _available.add(factory());
    }
  }

  T acquire() {
    if (_available.isNotEmpty) {
      final obj = _available.removeLast();
      _inUse.add(obj);
      reset?.call(obj);
      return obj;
    }

    if (_inUse.length < maxSize) {
      final obj = factory();
      _inUse.add(obj);
      return obj;
    }

    throw Exception('Object pool exhausted');
  }

  void release(T obj) {
    if (_inUse.contains(obj)) {
      _inUse.remove(obj);
      reset?.call(obj);
      _available.add(obj);
    }
  }

  void clear() {
    _available.clear();
    _inUse.clear();
  }

  int get availableCount => _available.length;
  int get inUseCount => _inUse.length;
}
