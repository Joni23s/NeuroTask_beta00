import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_graph.dart';
import '../models/task_node.dart';
import 'topological_sorter.dart';

enum _SegmentRelation {
  initial,
  sequential,
  additive,
}

class _ParsedSegment {
  final String text;
  final _SegmentRelation relation;

  const _ParsedSegment({
    required this.text,
    required this.relation,
  });
}

class _SemanticClassification {
  final String category;
  final int defaultMinutes;
  final EnergyLevel energyLevel;

  const _SemanticClassification({
    required this.category,
    required this.defaultMinutes,
    required this.energyLevel,
  });
}

/// Motor Real de Descompresión Cognitiva Híbrido.
///
/// Convierte volcados mentales crudos (texto o dictado por voz) en un Grafo
/// Acíclico Dirigido ([TaskGraph]) accionable sin fricción cognitiva:
/// 1. Modo IA Híbrido (opcional): usa Google Gemini API si el usuario configuró
///    una API key válida en Ajustes, con fallback transparente y seguro.
/// 2. Modo NLP Heurístico Local (100% offline): aplica inversión causal,
///    segmentación lingüística multi-nivel, limpieza de muletillas, extracción
///    de tiempos explícitos, clasificación semántica y descomposición atómica
///    automática cuando el usuario ingresa una única macro-tarea.
class CognitiveDecompressionEngine {
  static const int _maxGeneratedNodes = 8;
  static const Duration _aiTimeout = Duration(seconds: 7);

  static const String _actionVerbsPattern =
      r'(?:armar|programar|redactar|diseñar|estudiar|enviar|mandar|crear|hacer|'
      r'preparar|revisar|corregir|subir|entregar|configurar|llamar|escribir|'
      r'leer|repasar|resolver|terminar|completar|validar|probar|testear|'
      r'definir|organizar|limpiar|comprar|pagar|ordenar|practicar|investigar|'
      r'buscar|verificar|publicar|actualizar|desplegar|instalar|documentar|'
      r'resumir|esquematizar|agendar|responder|maquetar|renderizar)';

  static final List<RegExp> _fillerPrefixPatterns = [
    RegExp(
      r'^(?:hoy|ahora|mañana)\s+(?:tengo\s+que|tendría\s+que|debo|debería|necesito|voy\s+a|quiero)\s+',
      caseSensitive: false,
    ),
    RegExp(
      r'^(?:no\s+(?:me\s+puedo\s+)?olvidarme\s+de(?:\s+que)?|acordarme\s+de(?:\s+que)?)\s+',
      caseSensitive: false,
    ),
    RegExp(
      r'^(?:estoy\s+(?:muy\s+)?(?:bloqueado|trabado|atrasado)\s+con(?:\s+el|\s+la)?)\s+',
      caseSensitive: false,
    ),
    RegExp(
      r'^(?:tengo\s+que|tendría\s+que|debo|debería|necesito|hay\s+que|me\s+falta(?:\s+hacer)?|quiero|voy\s+a|toca)\s+',
      caseSensitive: false,
    ),
    RegExp(
      r'^(?:urgente\s*:?\s*|para\s+empezar\s*,?\s*|antes\s+que\s+nada\s*,?\s*|en\s+primer\s+lugar\s*,?\s*)',
      caseSensitive: false,
    ),
    RegExp(
      r'^(?:por\s+último|por\s+ultimo|finalmente|a\s+continuación|a\s+continuacion|además(?:\s+de\s+eso)?|ademas|también|tambien|después|despues|luego|primero)\s*,?\s*',
      caseSensitive: false,
    ),
  ];

  /// Punto de entrada híbrido: intenta Gemini API si está habilitado y hay
  /// API key; ante cualquier fallo o en modo offline utiliza [decompressLocal].
  static Future<TaskGraph> decompress(
    String rawText, {
    String? geminiApiKey,
    bool useAiIfAvailable = true,
    http.Client? client,
  }) async {
    final clean = rawText.trim();
    if (clean.isEmpty) {
      return TopologicalSorter.defaultSampleGraph();
    }

    final trimmedKey = geminiApiKey?.trim() ?? '';
    if (useAiIfAvailable && trimmedKey.isNotEmpty) {
      final aiGraph = await _tryGeminiDecompression(
        clean,
        trimmedKey,
        client: client,
      );
      if (aiGraph != null && aiGraph.nodes.isNotEmpty) {
        return aiGraph;
      }
    }

    return decompressLocal(clean);
  }

  /// Motor NLP Heurístico Avanzado Local (100% offline y determinista).
  static TaskGraph decompressLocal(String rawText) {
    final clean = rawText.trim();
    if (clean.isEmpty) {
      return TopologicalSorter.defaultSampleGraph();
    }

    // 1. Pre-procesamiento de inversión causal ("A pero antes B" -> B luego A)
    final causallyNormalized = _reorderCausalInversions(clean);

    // 2. Segmentación multi-nivel preservando relación secuencial vs aditiva
    final segments = _segmentClauses(causallyNormalized);
    if (segments.isEmpty) {
      return TopologicalSorter.defaultSampleGraph();
    }

    // 3. Limpieza lingüística de muletillas y extracción de tiempo explícito
    final List<_ParsedSegment> cleanedSegments = [];
    for (final seg in segments) {
      final title = cleanActionTitle(seg.text);
      if (title.length > 3) {
        cleanedSegments.add(_ParsedSegment(
          text: title,
          relation: seg.relation,
        ));
      }
    }

    if (cleanedSegments.isEmpty) {
      return TopologicalSorter.defaultSampleGraph();
    }

    // 4. Descomposición atómica automática si se ingresó 1 única macro-tarea
    if (cleanedSegments.length == 1) {
      final singleText = cleanedSegments.first.text;
      final explicitMins = extractExplicitMinutes(singleText);
      if (explicitMins == null || explicitMins > 10) {
        return _decomposeMacroTask(
          singleText,
          explicitMinutes: explicitMins,
        );
      }

      final classification = _classifyClause(
        singleText,
        estimatedMinutes: explicitMins,
      );
      return TaskGraph(
        nodes: [
          TaskNode(
            id: 'node_1',
            title: _stripTrailingDurationTag(singleText),
            category: classification.category,
            subtext: 'Micro-paso puntual listo para completar sin fricción.',
            estimatedMinutes: explicitMins,
            energyLevel: classification.energyLevel,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
        ],
        edges: const [],
      );
    }

    // 5. Construcción de nodos y aristas DAG coherentes para múltiples cláusulas
    final limitedCount = cleanedSegments.length > _maxGeneratedNodes
        ? _maxGeneratedNodes
        : cleanedSegments.length;

    final List<TaskNode> rawNodes = [];
    final List<_SegmentRelation> relations = [];

    for (int i = 0; i < limitedCount; i++) {
      final seg = cleanedSegments[i];
      final explicitMins = extractExplicitMinutes(seg.text);
      final classification = _classifyClause(
        seg.text,
        estimatedMinutes: explicitMins,
      );
      final duration = explicitMins ?? classification.defaultMinutes;
      final displayTitle = _stripTrailingDurationTag(seg.text);

      rawNodes.add(
        TaskNode(
          id: 'node_${i + 1}',
          title: displayTitle,
          category: classification.category,
          subtext: i == 0
              ? 'Paso inicial sugerido sin dependencias previas.'
              : seg.relation == _SegmentRelation.sequential
                  ? 'Bloque secuencial dependiente del paso anterior.'
                  : 'Rama paralela desbloqueada para avanzar con flexibilidad.',
          estimatedMinutes: duration,
          energyLevel: classification.energyLevel,
          dependencies: const [],
        ),
      );
      relations.add(seg.relation);
    }

    return _buildConsistentDag(rawNodes, relations);
  }

  /// Limpia muletillas coloquiales / de ansiedad al inicio y formatea el título.
  static String cleanActionTitle(String raw) {
    var text = raw.trim();
    text = text.replaceAll(RegExp(r'^[-*•\d\.\)\s]+'), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    bool changed = true;
    int guard = 0;
    while (changed && guard < 6) {
      changed = false;
      guard++;
      for (final pattern in _fillerPrefixPatterns) {
        final match = pattern.firstMatch(text);
        if (match != null) {
          final candidate = text.substring(match.end).trim();
          if (candidate.length >= 4) {
            text = candidate;
            changed = true;
          }
        }
      }
    }

    text = text.replaceAll(RegExp(r'^[,;:\.\-\s]+|[,;:\.\-\s]+$'), '').trim();
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Detecta duraciones explícitas en español ("25 min", "media hora", "1.5 h").
  static int? extractExplicitMinutes(String text) {
    final lower = text.toLowerCase();

    if (RegExp(r'\bhora\s+y\s+media\b').hasMatch(lower)) {
      return 90;
    }
    if (RegExp(r'\bmedia\s+hora\b').hasMatch(lower)) {
      return 30;
    }
    if (RegExp(r'\bun\s+cuarto\s+de\s+hora\b').hasMatch(lower)) {
      return 15;
    }
    if (RegExp(r'\buna\s+hora\b').hasMatch(lower)) {
      return 60;
    }

    final hourMatch = RegExp(
      r'\b(\d+(?:[.,]\d+)?)\s*(?:h|hs|hr|hrs|hora|horas)\b',
    ).firstMatch(lower);
    if (hourMatch != null) {
      final rawNum = hourMatch.group(1)!.replaceAll(',', '.');
      final hours = double.tryParse(rawNum);
      if (hours != null && hours > 0) {
        return (hours * 60).round().clamp(5, 180);
      }
    }

    final minMatch = RegExp(
      r'\b(\d+)\s*(?:min|mins|minuto|minutos|m)\b',
    ).firstMatch(lower);
    if (minMatch != null) {
      final mins = int.tryParse(minMatch.group(1)!);
      if (mins != null && mins > 0) {
        return mins.clamp(3, 180);
      }
    }

    return null;
  }

  static String _stripTrailingDurationTag(String text) {
    final stripped = text
        .replaceAll(
          RegExp(
            r'\s*\(\s*(?:\d+(?:[.,]\d+)?\s*(?:min|mins|minutos?|h|hs|horas?|m)|media\s+hora)\s*\)\s*$',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
    return stripped.isEmpty ? text : stripped;
  }

  /// Invierte dependencias causales tipo "A pero antes B" o "Antes de A, B".
  static String _reorderCausalInversions(String text) {
    var result = text;

    // Patrón 1: "Antes de <A>, <B>" o "Antes de <A> tengo que/debo/hay que <B>"
    final leadingBefore = RegExp(
      r'antes\s+de\s+([^,.;\n]+?)(?:\s*,\s*|\s+(?:hay\s+que|tengo\s+que|debo|necesito)\s+)([^.;\n]+)',
      caseSensitive: false,
    );
    result = result.replaceAllMapped(leadingBefore, (m) {
      final targetA = m.group(1)?.trim() ?? '';
      final prereqB = m.group(2)?.trim() ?? '';
      if (targetA.length < 3 || prereqB.length < 3) return m.group(0)!;
      return '$prereqB, luego $targetA';
    });

    // Patrón 2: "<A> pero antes / antes de eso / aunque primero <B>"
    final inlineBefore = RegExp(
      r'([^,.;\n]+?)\s+(?:pero\s+antes(?:\s+de\s+eso)?|antes\s+de\s+eso|aunque\s+primero|previo\s+a\s+eso)\s+([^.;\n]+)',
      caseSensitive: false,
    );
    result = result.replaceAllMapped(inlineBefore, (m) {
      final targetA = m.group(1)?.trim() ?? '';
      final prereqB = m.group(2)?.trim() ?? '';
      if (targetA.length < 3 || prereqB.length < 3) return m.group(0)!;
      return '$prereqB, luego $targetA';
    });

    return result;
  }

  /// Divide el texto conservando si el delimitador implica secuencia o adición.
  static List<_ParsedSegment> _segmentClauses(String text) {
    final normalizedLines = text
        .split('\n')
        .map((line) => line.replaceFirst(RegExp(r'^\s*(?:[-*•]|\d+[\.\)])\s+'), ''))
        .join('\n');

    final separatorPattern = RegExp(
      r'(?:\s*\n+\s*|'
      r'\s*;\s*|'
      r'\s*\.(?=\s|$)\s*|'
      r'\s*,?\s*(?:y\s+)?(?:luego|para\s+luego|para\s+después|por\s+último|por\s+ultimo|finalmente|a\s+continuación|a\s+continuacion|después|despues)\s+|'
      r'\s*,?\s*(?:además|ademas|también|tambien|y\s+tengo\s+que|y\s+debo|y\s+necesito)\s+|'
      r'\s*,\s*(?:y\s+)?|'
      '\\s+y\\s+(?=(?:después\\s+|luego\\s+|también\\s+)?$_actionVerbsPattern\\b))',
      caseSensitive: false,
    );

    final matches = separatorPattern.allMatches(normalizedLines).toList();
    if (matches.isEmpty) {
      final trimmed = normalizedLines.trim();
      return trimmed.length > 3
          ? [_ParsedSegment(text: trimmed, relation: _SegmentRelation.initial)]
          : const [];
    }

    final List<_ParsedSegment> segments = [];
    int cursor = 0;
    _SegmentRelation nextRelation = _SegmentRelation.initial;

    for (final match in matches) {
      final chunk = normalizedLines.substring(cursor, match.start).trim();
      if (chunk.length > 3) {
        segments.add(_ParsedSegment(text: chunk, relation: nextRelation));
      }
      final sep = match.group(0)!.toLowerCase();
      nextRelation = _classifySeparator(sep);
      cursor = match.end;
    }

    final tail = normalizedLines.substring(cursor).trim();
    if (tail.length > 3) {
      segments.add(_ParsedSegment(text: tail, relation: nextRelation));
    }

    return segments;
  }

  static _SegmentRelation _classifySeparator(String separator) {
    if (separator.contains('luego') ||
        separator.contains('despu') ||
        separator.contains('último') ||
        separator.contains('ultimo') ||
        separator.contains('finalmente') ||
        separator.contains('continuaci') ||
        separator.contains('para ')) {
      return _SegmentRelation.sequential;
    }
    if (separator.contains('adem') ||
        separator.contains('tambi') ||
        separator.contains('\n') ||
        separator.contains(';')) {
      return _SegmentRelation.additive;
    }
    // Coma o "y + verbo": secuencial ligero salvo que las categorías difieran
    return _SegmentRelation.additive;
  }

  static _SemanticClassification _classifyClause(
    String clause, {
    int? estimatedMinutes,
  }) {
    final lower = clause.toLowerCase();

    String category = 'Ejecución';
    int defaultMins = 15;
    EnergyLevel energy = EnergyLevel.medium;

    if (RegExp(
      r'\b(inglés|ingles|estudiar|leer|lectura|vocabulario|repasar|parcial|examen|final|materia|apunte|apuntes|teoría|teoria|práctica|practica|ejercicio|ejercicios|libro|clase|cátedra|catedra|facultad)\b',
    ).hasMatch(lower)) {
      category = 'Estudio & Idiomas';
      defaultMins = 20;
      energy = EnergyLevel.medium;
    } else if (RegExp(
      r'\b(test|testear|postman|endpoint|endpoints|api|back|backend|código|codigo|programar|flutter|dart|bug|fix|deploy|server|servidor|db|sql|widget|app|pantalla|repositorio|git|commit|compilar)\b',
    ).hasMatch(lower)) {
      category = 'Backend & Dev';
      defaultMins = 15;
      energy = EnergyLevel.medium;
    } else if (RegExp(
      r'\b(informe|resumen|redactar|escribir|doc|documento|documentación|documentacion|notas|egi|texto|paper|ensayo|ortografía|ortografia|memoria)\b',
    ).hasMatch(lower)) {
      category = 'Documentación';
      defaultMins = 20;
      energy = EnergyLevel.high;
    } else if (RegExp(
      r'\b(slide|slides|figma|diapositiva|diapositivas|diseño|diseñar|ui|ux|wireframe|prototipo|stitch|mock|mockup|interfaz|presentación|presentacion|gráfico)\b',
    ).hasMatch(lower)) {
      category = 'Diseño & UI';
      defaultMins = 15;
      energy = EnergyLevel.low;
    } else if (RegExp(
      r'\b(planificar|plan|analizar|estructura|esquema|arquitectura|investigar|definir|mapa|checklist|priorizar|requisito|requisitos|presupuesto)\b',
    ).hasMatch(lower)) {
      category = 'Planificación & Análisis';
      defaultMins = 15;
      energy = EnergyLevel.medium;
    } else if (RegExp(
      r'\b(organizar|limpiar|llamar|mail|correo|email|enviar|mandar|responder|pagar|comprar|agendar|subir|entregar|ordenar|avisar|turno|turnos|trámite|tramite)\b',
    ).hasMatch(lower)) {
      category = 'Gestión Rápida';
      defaultMins = 10;
      energy = EnergyLevel.low;
    }

    final mins = estimatedMinutes ?? defaultMins;
    if (RegExp(
      r'\b(complejo|difícil|dificil|parcial|integrador|extenso|profundo|arquitectura)\b',
    ).hasMatch(lower) ||
        mins >= 35) {
      energy = EnergyLevel.high;
    } else if (RegExp(
      r'\b(rápido|rapido|rápida|rapida|breve|simple|corto|corta|ligero|liviano)\b',
    ).hasMatch(lower) ||
        mins <= 8) {
      energy = EnergyLevel.low;
    }

    return _SemanticClassification(
      category: category,
      defaultMinutes: defaultMins,
      energyLevel: energy,
    );
  }

  /// Descompone una única macro-tarea en 3 o 4 micro-pasos atómicos accionables.
  static TaskGraph _decomposeMacroTask(
    String cleanTitle, {
    int? explicitMinutes,
  }) {
    final topicRaw = _stripTrailingDurationTag(cleanTitle);
    final topic = topicRaw.length > 44
        ? '${topicRaw.substring(0, 41).trimRight()}...'
        : topicRaw;
    final classification = _classifyClause(
      topicRaw,
      estimatedMinutes: explicitMinutes,
    );

    List<int> durations(List<int> base) {
      if (explicitMinutes == null) return base;
      final baseSum = base.fold<int>(0, (acc, v) => acc + v);
      return base
          .map((v) => ((v / baseSum) * explicitMinutes).round().clamp(5, 25))
          .toList();
    }

    late final List<TaskNode> nodes;
    late final List<TaskEdge> edges;

    switch (classification.category) {
      case 'Estudio & Idiomas':
        final mins = durations([5, 15, 15, 10]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Delimitar temario y materiales de: $topic',
            category: classification.category,
            subtext:
                'Preparación (sin leer todo): reuní apuntes y definí los 3 temas clave.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Lectura activa y resumen breve de: $topic',
            category: classification.category,
            subtext:
                'Rama teórica: sintetizá conceptos y fórmulas en tus propias palabras.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Resolver 2 ejercicios prácticos sobre: $topic',
            category: classification.category,
            subtext:
                'Rama práctica: aplicá lo repasado sin mirar la solución hasta terminar.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.high,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_4',
            title: 'Autoevaluación rápida y repaso de dudas',
            category: classification.category,
            subtext:
                'Cierre atómico: verificá qué quedó firme y anotá solo las dudas reales.',
            estimatedMinutes: mins[3],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_2', 'node_3'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_1', toId: 'node_3'),
          TaskEdge(fromId: 'node_2', toId: 'node_4'),
          TaskEdge(fromId: 'node_3', toId: 'node_4'),
        ];
        break;

      case 'Backend & Dev':
        final mins = durations([5, 15, 10, 5]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Definir alcance y archivos para: $topic',
            category: classification.category,
            subtext:
                'Paso 1 sin fricción: abrí únicamente los archivos y contratos implicados.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Implementar núcleo funcional de: $topic',
            category: classification.category,
            subtext:
                'Bloque central: resolvé primero el flujo feliz antes de optimizar detalles.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.high,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Probar casos borde y manejo de errores',
            category: classification.category,
            subtext:
                'Rama de calidad: prepará o ejecutá pruebas sobre los puntos críticos.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_4',
            title: 'Validar análisis estático y guardar cambios',
            category: classification.category,
            subtext:
                'Cierre seguro: verificá compilación limpia sin advertencias pendientes.',
            estimatedMinutes: mins[3],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_2', 'node_3'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_1', toId: 'node_3'),
          TaskEdge(fromId: 'node_2', toId: 'node_4'),
          TaskEdge(fromId: 'node_3', toId: 'node_4'),
        ];
        break;

      case 'Documentación':
        final mins = durations([5, 15, 10, 5]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Armar esquema de títulos para: $topic',
            category: classification.category,
            subtext:
                'Micro-paso 1: listá solo las secciones principales antes de redactar.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Redactar borrador fluido de: $topic',
            category: classification.category,
            subtext:
                'Micro-paso 2: escribí las ideas sin corregir estilo ni perfección todavía.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.high,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Revisar claridad, datos y ortografía',
            category: classification.category,
            subtext:
                'Micro-paso 3: pulí transiciones y verificá que no falte evidencia clave.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_2'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_4',
            title: 'Dar formato final y exportar entrega',
            category: classification.category,
            subtext: 'Cierre listo para enviar o subir sin pasos pendientes.',
            estimatedMinutes: mins[3],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_3'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_2', toId: 'node_3'),
          TaskEdge(fromId: 'node_3', toId: 'node_4'),
        ];
        break;

      case 'Diseño & UI':
        final mins = durations([5, 15, 10]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Reunir referencias y estructura de: $topic',
            category: classification.category,
            subtext:
                'Definí jerarquía visual y elementos mínimos antes de abrir el lienzo.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Maquetar composición principal de: $topic',
            category: classification.category,
            subtext:
                'Armá el bloque protagonista con los componentes principales.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Ajustar contraste, tipografía y espaciado',
            category: classification.category,
            subtext:
                'Pulido visual rápido para asegurar lectura clara y coherencia.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_2'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_2', toId: 'node_3'),
        ];
        break;

      case 'Gestión Rápida':
        final mins = durations([5, 10, 5]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Reunir datos o destinatarios para: $topic',
            category: classification.category,
            subtext:
                'Micro-arranque de 5m: dejá a mano enlaces, archivos o contactos.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Ejecutar gestión principal: $topic',
            category: classification.category,
            subtext: 'Resolvé el envío, pago o llamada en una sola pasada.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Confirmar comprobante o cierre de gestión',
            category: classification.category,
            subtext: 'Verificá confirmación para sacar el pendiente de la mente.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_2'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_2', toId: 'node_3'),
        ];
        break;

      default:
        final mins = durations([5, 15, 10]);
        nodes = [
          TaskNode(
            id: 'node_1',
            title: 'Definir primer micro-objetivo visible de: $topic',
            category: classification.category,
            subtext:
                'Rompé la inercia inicial preparando lo mínimo para arrancar.',
            estimatedMinutes: mins[0],
            energyLevel: EnergyLevel.low,
            dependencies: const [],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_2',
            title: 'Ejecutar bloque central de: $topic',
            category: classification.category,
            subtext: 'Foco sostenido de 15m en la parte nuclear de la tarea.',
            estimatedMinutes: mins[1],
            energyLevel: EnergyLevel.medium,
            dependencies: const ['node_1'],
            isAtomicSubstep: true,
          ),
          TaskNode(
            id: 'node_3',
            title: 'Revisar resultado y cerrar: $topic',
            category: classification.category,
            subtext: 'Validación breve para completar el ciclo con calma.',
            estimatedMinutes: mins[2],
            energyLevel: EnergyLevel.low,
            dependencies: const ['node_2'],
            isAtomicSubstep: true,
          ),
        ];
        edges = const [
          TaskEdge(fromId: 'node_1', toId: 'node_2'),
          TaskEdge(fromId: 'node_2', toId: 'node_3'),
        ];
        break;
    }

    return TaskGraph(nodes: nodes, edges: edges);
  }

  /// Construye aristas dirigidas consistentes y rellena [TaskNode.dependencies].
  static TaskGraph _buildConsistentDag(
    List<TaskNode> rawNodes,
    List<_SegmentRelation> relations,
  ) {
    if (rawNodes.isEmpty) {
      return const TaskGraph(nodes: [], edges: []);
    }
    if (rawNodes.length == 1) {
      return TaskGraph(nodes: rawNodes, edges: const []);
    }

    final List<TaskEdge> edges = [];
    final Map<String, List<String>> depsByNode = {
      for (final node in rawNodes) node.id: <String>[],
    };

    for (int i = 1; i < rawNodes.length; i++) {
      final current = rawNodes[i];
      final prev = rawNodes[i - 1];
      final relation = relations[i];

      String parentId = prev.id;
      if (i >= 2 && relation == _SegmentRelation.additive) {
        final differentCategory = current.category != prev.category;
        if (differentCategory) {
          parentId = rawNodes[i == 2 ? 0 : (i % 2 == 1 ? 1 : 2)].id;
        }
      }

      if (parentId != current.id) {
        edges.add(TaskEdge(fromId: parentId, toId: current.id));
        depsByNode[current.id]!.add(parentId);
      }
    }

    final updatedNodes = rawNodes
        .map((n) => n.copyWith(dependencies: List<String>.unmodifiable(depsByNode[n.id]!)))
        .toList();

    return TaskGraph(nodes: updatedNodes, edges: edges);
  }

  static Future<TaskGraph?> _tryGeminiDecompression(
    String rawText,
    String apiKey, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    final shouldClose = client == null;

    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final body = jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': _buildGeminiPrompt(rawText)},
            ],
          }
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'temperature': 0.2,
        },
      });

      final response = await httpClient
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(_aiTimeout);

      if (response.statusCode != 200) {
        return null;
      }

      final payload = jsonDecode(response.body);
      if (payload is! Map<String, dynamic>) return null;

      final candidates = payload['candidates'];
      if (candidates is! List || candidates.isEmpty) return null;

      final firstCandidate = candidates.first;
      if (firstCandidate is! Map<String, dynamic>) return null;

      final content = firstCandidate['content'];
      if (content is! Map<String, dynamic>) return null;

      final parts = content['parts'];
      if (parts is! List || parts.isEmpty) return null;

      final firstPart = parts.first;
      if (firstPart is! Map<String, dynamic>) return null;

      final rawJsonText = firstPart['text']?.toString().trim() ?? '';
      if (rawJsonText.isEmpty) return null;

      final sanitizedJson = _stripMarkdownFences(rawJsonText);
      final parsed = jsonDecode(sanitizedJson);
      if (parsed is! Map<String, dynamic>) return null;

      return _normalizeAiGraph(parsed);
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    } finally {
      if (shouldClose) {
        httpClient.close();
      }
    }
  }

  static String _buildGeminiPrompt(String rawText) {
    return '''
Actúa como el Motor de Descompresión Cognitiva de NeuroTask (app móvil para estudiantes y personas con TDAH / sobrecarga cognitiva).
Tu tarea es convertir el volcado mental del usuario en español en un Grafo Acíclico Dirigido (DAG) ejecutable paso a paso.

Reglas estrictas:
1. Devuelve ÚNICAMENTE JSON válido con la estructura:
{
  "nodes": [
    {
      "id": "node_1",
      "title": "Acción breve y concreta en español",
      "category": "Una de: Backend & Dev | Documentación | Diseño & UI | Estudio & Idiomas | Gestión Rápida | Planificación & Análisis | Ejecución",
      "subtext": "Indicación empática de 1 línea sobre qué hacer ahora",
      "estimatedMinutes": 15,
      "energyLevel": 1,
      "dependencies": [],
      "isAtomicSubstep": false
    }
  ],
  "edges": [
    {"fromId": "node_1", "toId": "node_2"}
  ]
}
2. Limpia muletillas ("tengo que", "hoy debo") dejando títulos accionables en infinitivo.
3. Si el usuario ingresó una sola macro-tarea (ej. "Estudiar para el parcial"), desglósala en 3 o 4 micro-pasos atómicos (estimatedMinutes entre 5 y 20, con "isAtomicSubstep": true).
4. Si ingresó múltiples tareas, genera entre 2 y 7 nodos respetando el orden causal (ej. "A pero antes B" => B precede a A).
5. energyLevel debe ser entero: 0 (low), 1 (medium) o 2 (high).
6. Nunca generes ciclos en edges ni en dependencies. Mantén edges y dependencies consistentes.

Volcado mental del usuario:
"""
$rawText
"""
''';
  }

  static String _stripMarkdownFences(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```(?:json)?\s*', caseSensitive: false), '');
      cleaned = cleaned.replaceFirst(RegExp(r'\s*```$'), '');
    }
    return cleaned.trim();
  }

  static TaskGraph? _normalizeAiGraph(Map<String, dynamic> rawMap) {
    final rawNodes = rawMap['nodes'];
    if (rawNodes is! List || rawNodes.isEmpty) return null;

    final List<TaskNode> nodes = [];
    final Set<String> validIds = {};

    for (int i = 0; i < rawNodes.length && i < _maxGeneratedNodes; i++) {
      final item = rawNodes[i];
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);

      final rawTitle = (map['title'] ?? '').toString().trim();
      final title = cleanActionTitle(rawTitle);
      if (title.isEmpty) continue;

      var id = (map['id'] ?? 'node_${i + 1}').toString().trim();
      if (id.isEmpty || validIds.contains(id)) {
        id = 'node_${i + 1}';
      }
      validIds.add(id);

      final category = (map['category'] ?? '').toString().trim();
      final subtext = (map['subtext'] ?? '').toString().trim();
      final rawMins = map['estimatedMinutes'];
      final mins = (rawMins is num ? rawMins.toInt() : 15).clamp(3, 45);
      final energy = _parseEnergyLevel(map['energyLevel']);
      final deps = (map['dependencies'] is List)
          ? (map['dependencies'] as List)
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty && e != id)
              .toList()
          : <String>[];
      final isAtomic = map['isAtomicSubstep'] == true;

      nodes.add(
        TaskNode(
          id: id,
          title: title,
          category: category.isNotEmpty
              ? category
              : _classifyClause(title, estimatedMinutes: mins).category,
          subtext: subtext.isNotEmpty
              ? subtext
              : 'Micro-paso accionable dentro de tu camino lógico.',
          estimatedMinutes: mins,
          energyLevel: energy,
          dependencies: deps,
          isAtomicSubstep: isAtomic,
        ),
      );
    }

    if (nodes.isEmpty) return null;

    final nodeIds = {for (final n in nodes) n.id};
    final Map<String, Set<String>> normalizedDeps = {
      for (final n in nodes) n.id: <String>{},
    };

    void addDependencyIfAcyclic(String fromId, String toId) {
      if (!nodeIds.contains(fromId) || !nodeIds.contains(toId)) return;
      if (fromId == toId) return;
      if (!_wouldCreateCycle(normalizedDeps, fromId, toId)) {
        normalizedDeps[toId]!.add(fromId);
      }
    }

    final rawEdges = rawMap['edges'];
    if (rawEdges is List) {
      for (final item in rawEdges) {
        if (item is! Map) continue;
        final fromId = item['fromId']?.toString().trim() ?? '';
        final toId = item['toId']?.toString().trim() ?? '';
        addDependencyIfAcyclic(fromId, toId);
      }
    }

    for (final node in nodes) {
      for (final dep in node.dependencies) {
        addDependencyIfAcyclic(dep, node.id);
      }
    }

    final List<TaskEdge> cleanEdges = [];
    final List<TaskNode> finalNodes = [];
    for (final node in nodes) {
      final deps = normalizedDeps[node.id]!.toList();
      for (final dep in deps) {
        cleanEdges.add(TaskEdge(fromId: dep, toId: node.id));
      }
      finalNodes.add(node.copyWith(dependencies: List<String>.unmodifiable(deps)));
    }

    return TaskGraph(nodes: finalNodes, edges: cleanEdges);
  }

  static bool _wouldCreateCycle(
    Map<String, Set<String>> depsByNode,
    String fromId,
    String toId,
  ) {
    final visited = <String>{};
    final stack = <String>[fromId];
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      if (current == toId) return true;
      if (!visited.add(current)) continue;
      final parents = depsByNode[current];
      if (parents != null) {
        stack.addAll(parents);
      }
    }
    return false;
  }

  static EnergyLevel _parseEnergyLevel(dynamic raw) {
    if (raw is num) {
      final idx = raw.toInt().clamp(0, EnergyLevel.values.length - 1);
      return EnergyLevel.values[idx];
    }
    final str = raw?.toString().toLowerCase().trim() ?? '';
    if (str == 'low' || str == 'baja' || str == '0') return EnergyLevel.low;
    if (str == 'high' || str == 'alta' || str == '2') return EnergyLevel.high;
    return EnergyLevel.medium;
  }
}
