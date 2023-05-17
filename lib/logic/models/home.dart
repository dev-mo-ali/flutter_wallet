class HomeState {
  bool loading;
  bool loaded;
  List? promotions;
  HomeState({
    this.loading = true,
    this.loaded = false,
    this.promotions,
  });

  HomeState copyWith({
    bool? loading,
    bool? loaded,
    List? promotions,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      promotions: promotions ?? this.promotions,
    );
  }
}
