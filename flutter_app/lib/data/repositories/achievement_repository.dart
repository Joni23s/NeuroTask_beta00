import 'dart:async';
import '../../core/domain/models/achievement.dart';
import '../../core/services/achievements_storage_service.dart';

/// Repositorio de Logros y Progresión Cognitiva (Capa de Datos).
///
/// Separa el catálogo de logros y el estado de desbloqueo de la capa visual y de modelos.
/// Cumple con los requerimientos de la Unidad 3.1.1 de la cátedra DAM (Tema 1).
class AchievementRepository {
  // Catálogo maestro de logros neuro-adaptativos (Capa de Datos)
  static final List<Achievement> _catalog = [
    const Achievement(
      id: 'first_brain_dump',
      title: 'Descompresión Inicial',
      description: 'Vaciá tu mente y estructurá tu primer volcado de ideas en un camino lógico.',
      iconEmoji: '🧠',
      category: AchievementCategory.exploracion,
      rewardInsight: 'Venciste la inercia mental: sacar las ideas de la cabeza es el 50% de la victoria.',
    ),
    const Achievement(
      id: 'first_flow_completed',
      title: 'Paso a Paso',
      description: 'Completá una sesión de foco entera de inicio a fin al 100%.',
      iconEmoji: '🏆',
      category: AchievementCategory.foco,
      rewardInsight: 'Demostraste que aislando las tareas 1 a 1, la parálisis desaparece.',
    ),
    const Achievement(
      id: 'hyperfocus_ray',
      title: 'Rayo de Hiperfoco',
      description: 'Terminá un flujo antes del tiempo estimado y ganá minutos de libertad.',
      iconEmoji: '⚡',
      category: AchievementCategory.foco,
      rewardInsight: '¡Modo hiperfoco activo! Rompiste la creencia de que la tarea era pesada.',
    ),
    const Achievement(
      id: 'resilience_champion',
      title: 'Campeón de Resiliencia',
      description: 'Persistí y completá un flujo aunque requiera más tiempo de lo previsto.',
      iconEmoji: '🌱',
      category: AchievementCategory.resiliencia,
      rewardInsight: 'No abandonaste ante la fricción. La constancia serena vale el doble.',
    ),
    const Achievement(
      id: 'rescue_master',
      title: 'Rescate Inteligente',
      description: 'Activá el modo rescate de micro-pasos o baja energía para destrabarte.',
      iconEmoji: '🛡️',
      category: AchievementCategory.resiliencia,
      rewardInsight: 'Pedir ayuda o bajar la exigencia a micro-pasos de 3m es una estrategia de genios.',
    ),
    const Achievement(
      id: 'night_guardian',
      title: 'Guardián Nocturno',
      description: 'Completá una sesión utilizando el Modo Oscuro (Dark Soft Slate).',
      iconEmoji: '🌙',
      category: AchievementCategory.calma,
      rewardInsight: 'Protegiste tu energía visual con un entorno sereno y sin deslumbramiento.',
    ),
    const Achievement(
      id: 'sensory_bubble',
      title: 'Burbuja Sensorial',
      description: 'Enfocate en tus tareas escuchando Ruido Marrón ambiental.',
      iconEmoji: '🌧️',
      category: AchievementCategory.calma,
      rewardInsight: 'El ruido marrón enmascara el caos auditivo externo y calma la inquietud interna.',
    ),
    const Achievement(
      id: 'voice_thinker',
      title: 'Voz y Pensamiento',
      description: 'Realizá un volcado de ideas utilizando el dictado por voz.',
      iconEmoji: '🎙️',
      category: AchievementCategory.exploracion,
      rewardInsight: 'Fluidez sin teclado: hablar en voz alta desbloquea la función ejecutiva.',
    ),
    const Achievement(
      id: 'trilogy_flow',
      title: 'Trilogía Serena',
      description: 'Conquistá 3 sesiones completas de tareas sin sobrecarga.',
      iconEmoji: '💎',
      category: AchievementCategory.maestria,
      rewardInsight: 'Construiste un hábito de foco sostenible y respetuoso con tu cerebro.',
    ),
    const Achievement(
      id: 'neuro_master',
      title: 'Cerebro NeuroTask',
      description: 'Desbloqueá 5 o más logros cognitivos en la aplicación.',
      iconEmoji: '👑',
      category: AchievementCategory.maestria,
      rewardInsight: 'Sos un maestro de tu atención: dominás la descompresión y el flujo sereno.',
    ),
  ];

  /// Obtiene todos los logros hidratados con su estado de desbloqueo actual
  Future<List<Achievement>> getAllAchievements() async {
    final unlockedMap = await AchievementsStorageService.loadUnlockedAchievements();

    return _catalog.map((base) {
      final timestampStr = unlockedMap[base.id];
      if (timestampStr != null) {
        return base.copyWith(
          unlockedAt: DateTime.tryParse(timestampStr) ?? DateTime.now(),
        );
      }
      return base;
    }).toList();
  }

  /// Retorna la cantidad de logros desbloqueados
  Future<int> getUnlockedCount() async {
    final map = await AchievementsStorageService.loadUnlockedAchievements();
    return map.length;
  }

  /// Desbloquea un logro específico por su clave
  Future<bool> unlockAchievement(String id) async {
    final current = await AchievementsStorageService.loadUnlockedAchievements();
    if (current.containsKey(id)) return false; // Ya estaba desbloqueado

    current[id] = DateTime.now().toIso8601String();
    await AchievementsStorageService.saveUnlockedAchievements(current);
    return true;
  }

  /// Registra un flujo completado y retorna la cantidad total acumulada
  Future<int> recordFlowCompleted() async {
    return AchievementsStorageService.incrementCompletedFlows();
  }

  /// Obtiene el total de flujos completados
  Future<int> getTotalCompletedFlows() async {
    return AchievementsStorageService.getCompletedFlowsCount();
  }
}

