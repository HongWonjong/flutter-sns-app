class PostSettings {
  final String filterName;

  const PostSettings({
    this.filterName = 'default',
  });

  PostSettings copyWith({
    String? filterName,
  }) {
    return PostSettings(
      filterName: filterName ?? this.filterName,
    );
  }
}