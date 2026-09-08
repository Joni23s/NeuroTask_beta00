import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/services/anchors_storage_service.dart';

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
      anchors: TimeAnchor.initialPresets(),
      isLoading: true,
      selectedWeekday: today,
    );
  }

  Future<void> loadAnchors() async {
    state = state.copyWith(isLoading: true);
    final list = await AnchorsStorageService.loadAnchors();
    state = state.copyWith(anchors: list, isLoading: false);
  }

  Future<void> addAnchor(TimeAnchor anchor) async {
    final updated = List<TimeAnchor>.from(state.anchors)..add(anchor);
    state = state.copyWith(anchors: updated);
    await AnchorsStorageService.saveAnchors(updated);
  }

  Future<void> updateAnchor(TimeAnchor updatedAnchor) async {
    final updated = state.anchors.map((a) => a.id == updatedAnchor.id ? updatedAnchor : a).toList();
    state = state.copyWith(anchors: updated);
    await AnchorsStorageService.saveAnchors(updated);
  }

  Future<void> deleteAnchor(String id) async {
    final updated = state.anchors.where((a) => a.id != id).toList();
    state = state.copyWith(anchors: updated);
    await AnchorsStorageService.saveAnchors(updated);
  }

  Future<void> toggleActive(String id) async {
    final updated = state.anchors.map((a) {
      if (a.id == id) {
        return a.copyWith(isActive: !a.isActive);
      }
      return a;
    }).toList();
    state = state.copyWith(anchors: updated);
    await AnchorsStorageService.saveAnchors(updated);
  }

  void selectWeekday(int weekday) {
    state = state.copyWith(selectedWeekday: weekday);
  }

  Future<void> resetToDefaults() async {
    state = state.copyWith(isLoading: true);
    final defaults = await AnchorsStorageService.resetToDefaults();
    state = state.copyWith(anchors: defaults, isLoading: false);
  }
}

final anchorsProvider = NotifierProvider<AnchorsNotifier, AnchorsState>(AnchorsNotifier.new);
