import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viminsk_assistent/service/background/data/repositories/background_repositories_impl.dart';
import 'package:viminsk_assistent/service/background/domain/repositories/background_repositories.dart';

final backgroundRepositoriesProvider = Provider<BackgroundRepositories>((ref) {
  return BackgroundRepositoriesImpl();
});
