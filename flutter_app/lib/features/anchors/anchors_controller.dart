import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../data/repositories/providers.dart';

class AnchorsState {
  final List<TimeAnchor> anchors;
  final bool isLoading;
  final int selectedWeekday; // 1 = Lunes ... 7 = Domingo

  const AnchorsState({
    required this.anchors,
    this.isLoading = false,
    required this.selectedWeekday,
  });

  /// Anclas que aplican específicamente al día seleccionado
  List<TimeAnchor> get anchorsForSelectedDay {
    return anchors.where((a) => a.appliesToWeekday(selectedWeekday)).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
  }

  /// Total de minutos bloqueados por anclas en el día seleccionado
  int get totalOccupiedMinutesToday {
    return anchorsForSelectedDay.fold(0, (sum, a) => sum + a.durationMinutes);
  }

  AnchorsState copyWith({
    List<TimeAnchor>? anchors,
    bool? isLoading,
    int? selectedWeekday,
  }) {
    return AnchorsState(
      anchors: anchors ?? this.anchors,
      isLoading: isLoading ?? this.isLoading,
      selectedWeekday: selectedWeekday ?? this.selectedWeekday,
    );
  }
}

class AnchorsNotifier extends Notifier<AnchorsState> {
  @override
  AnchorsState build() {
    final today = DateTime.now().weekday;
    Future.microtask(() => loadAnchors());
    return AnchorsState(
      anchors: const [],
      isLoading: true,
      selectedWeekday: today,
    );
  }

  /// Carga las anclas y actividades dinámicamente desde el AnchorRepository
  Future<void> loadAnchors() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(anchorRepositoryProvider);
    final list = await repo.getAllAnchors();
    state = state.copyWith(anchors: list, isLoading: false);
  }

  /// Inserta una nueva ancla a través del repositorio
  Future<void> addAnchor(TimeAnchor anchor) async {
    final repo = ref.read(anchorRepositoryProvider);
    await repo.insertAnchor(anchor);
    await loadAnchors();
  }

  /// Actualiza un ancla a través del repositorio
  Future<void> updateAnchor(TimeAnchor updatedAnchor) async {
    final repo = ref.read(anchorRepositoryProvider);
    await repo.updateAnchor(updatedAnchor);
    await loadAnchors();
  }

  /// Elimina un ancla a través del repositorio
  Future<void> deleteAnchor(String id) async {
    final repo = ref.read(anchorRepositoryProvider);
    await repo.deleteAnchor(id);
    await loadAnchors();
  }

  /// Conmuta estado activo/inactivo a través del repositorio
  Future<void> toggleActive(String id) async {
    final repo = ref.read(anchorRepositoryProvider);
    await repo.toggleActive(id);
    await loadAnchors();
  }

  void selectWeekday(int weekday) {
    state = state.copyWith(selectedWeekday: weekday);
  }

  /// Restaura los valores por defecto desde el repositorio
  Future<void> resetToDefaults() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(anchorRepositoryProvider);
    final defaults = await repo.resetToDefaults();
    state = state.copyWith(anchors: defaults, isLoading: false);
  }
}

final anchorsProvider = NotifierProvider<AnchorsNotifier, AnchorsState>(
  AnchorsNotifier.new,
);
