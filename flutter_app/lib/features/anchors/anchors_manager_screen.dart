import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neuro_badge.dart';
import '../../core/widgets/neuro_modal_sheet.dart';
import '../../util/date_time_formatter.dart';
import 'anchors_controller.dart';

class AnchorsManagerScreen extends ConsumerStatefulWidget {
  const AnchorsManagerScreen({super.key});

  @override
  ConsumerState<AnchorsManagerScreen> createState() => _AnchorsManagerScreenState();
}

class _AnchorsManagerScreenState extends ConsumerState<AnchorsManagerScreen> {
  final List<String> _weekdaysShort = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  final List<String> _weekdaysFull = [
    'LUNES',
    'MARTES',
    'MIÉRCOLES',
    'JUEVES',
    'VIERNES',
    'SÁBADO',
    'DOMINGO'
  ];

  static const double _hourHeight = 94.0;
  static const int _startHour = 9;
  static const int _endHour = 22;
  static const double _axisX = 66.0;


  void _onOpenAddAnchorSheet({String? initialStartTime}) {
    HapticHelper.lightTap();
    showNeuroModalSheet(
      context: context,
      builder: (ctx) => NeuroModalSheet(
        title: 'Nueva Actividad / Ancla',
        subtitle: 'Bloqueá un espacio en tu Malla Temporal de hoy',
        child: _AddAnchorForm(
          initialStartTime: initialStartTime,
          onSave: (anchor) {
            ref.read(anchorsProvider.notifier).addAnchor(anchor);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Actividad "${anchor.title}" agendada en la Malla')),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF45A59E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onDeleteAnchor(TimeAnchor anchor) {
    HapticHelper.warning();
    ref.read(anchorsProvider.notifier).deleteAnchor(anchor.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Actividad "${anchor.title}" eliminada'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShowItemDetails({
    required String title,
    required String startTime,
    required String endTime,
    required String category,
    TimeAnchor? realAnchor,
  }) {
    HapticHelper.lightTap();
    showNeuroModalSheet(
      context: context,
      builder: (ctx) => NeuroModalSheet(
        title: title.replaceAll('\n', ' '),
        subtitle: 'Detalle de actividad en la Malla Temporal',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  NeuroBadge(
                    label: category,
                    textColor: const Color(0xFF45A59E),
                    backgroundColor: const Color(0xFF45A59E).withValues(alpha: 0.15),
                  ),
                  const SizedBox(width: 8),
                  const NeuroBadge.status(
                    label: 'En Malla Temporal',
                    dotColor: Color(0xFF72B8B0),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Horario asignado:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '$startTime — $endTime',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: context.textMain),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (realAnchor != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _onDeleteAnchor(realAnchor);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: NeumorphicButton(
                      variant: NeumorphicButtonVariant.primary,
                      borderRadius: 16,
                      height: 48,
                      onPressed: () => Navigator.pop(ctx),
                      child: const Center(
                        child: Text('Cerrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anchorsState = ref.watch(anchorsProvider);
    final userAnchors = anchorsState.anchorsForSelectedDay;
    final selectedDay = anchorsState.selectedWeekday;

    // Calcular día del mes simulado para mantener consistencia con "LUNES 24 OCT"
    final dayNumber = 24 + (selectedDay - 1);
    final dayName = _weekdaysFull[(selectedDay - 1).clamp(0, 6)];

    // Unificar items dinámicos de la Malla provenientes del AnchorRepository
    final List<_MallaCardItem> displayedItems = [];
    for (int i = 0; i < userAnchors.length; i++) {
      final a = userAnchors[i];
      displayedItems.add(
        _MallaCardItem(
          id: a.id,
          title: a.title,
          startMinutes: a.startMinutes,
          durationMinutes: a.durationMinutes,
          isRightLane: i % 2 == 1,
          isLavender: i % 2 == 1,
          category: a.category,
          anchorRef: a,
        ),
      );
    }

    // Color base navy oscuro extraído fielmente del diseño de referencia
    const backgroundColor = Color(0xFF0F2E49);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Superior: Botón Volver, Logo Neurotask Centrado y Botón Agregar (+)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Botón de Volver a la izquierda
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      button: true,
                      label: 'Volver a la pantalla anterior',
                      child: InkWell(
                        onTap: () {
                          HapticHelper.lightTap();
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),

                  // Logo Neurotask (Foco con cerebro) y Título MALLA TEMPORAL
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Isotipo de la bombilla / cerebro Neurotask
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/brain_logo_transparent.png',
                            width: 52,
                            height: 52,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Text('💡', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'MALLA TEMPORAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),

                  // Botón flotante para agregar (+) a la derecha
                  Align(
                    alignment: Alignment.centerRight,
                    child: Semantics(
                      button: true,
                      label: 'Agregar actividad o ancla horaria',
                      child: InkWell(
                        onTap: () => _onOpenAddAnchorSheet(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF45A59E).withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF45A59E).withValues(alpha: 0.6)),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Selector horizontal sutil de días de la semana
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(7, (index) {
                  final dayNum = index + 1;
                  final isSelected = selectedDay == dayNum;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: () {
                        HapticHelper.selectionClick();
                        ref.read(anchorsProvider.notifier).selectWeekday(dayNum);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF45A59E)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF72B8B0)
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          _weekdaysShort[index],
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            // Contenedor principal de la Malla Temporal Scrollable
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalHours = (_endHour - _startHour + 1);
                  final timelineContentHeight = totalHours * _hourHeight + 80.0;
                  final availableWidth = constraints.maxWidth;
                  final rightAreaWidth = availableWidth - _axisX - 20;
                  final cardWidth = (rightAreaWidth - 14) / 2;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: timelineContentHeight,
                      width: availableWidth,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 1. Bloque de Fecha en la esquina superior izquierda
                          Positioned(
                            top: 4,
                            left: 12,
                            width: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: const TextStyle(
                                    color: Color(0xFF7CBDB5),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$dayNumber',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                  ),
                                ),
                                const Text(
                                  'OCT',
                                  style: TextStyle(
                                    color: Color(0xFF7CBDB5),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 2. Línea de eje vertical Teal / Cyan
                          Positioned(
                            top: 60,
                            left: _axisX,
                            bottom: 20,
                            child: Container(
                              width: 2.5,
                              decoration: BoxDecoration(
                                color: const Color(0xFF45A59E),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // 3. Horas a la izquierda y Líneas Guía Horizontales a la derecha
                          ...List.generate(totalHours, (i) {
                            final hour = _startHour + i;
                            final yPos = 60.0 + (i * _hourHeight);
                            final hourText = '$hour:00';

                            return Positioned(
                              top: yPos,
                              left: 0,
                              right: 0,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  // Etiqueta de la hora
                                  Positioned(
                                    left: 8,
                                    width: 48,
                                    child: Text(
                                      hourText,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: Color(0xFF6797B0),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),

                                  // Línea guía horizontal cruzando hacia la derecha
                                  Positioned(
                                    left: _axisX,
                                    right: 12,
                                    child: Container(
                                      height: 1.0,
                                      color: const Color(0xFF1B4160).withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // 4. Tarjetas redondeadas de Actividades (Malla Temporal)
                          ...displayedItems.map((item) {
                            final minutesFromStart = item.startMinutes - (_startHour * 60);
                            if (minutesFromStart < -30) return const SizedBox.shrink();

                            final cardTop = 60.0 + (minutesFromStart * (_hourHeight / 60.0));
                            final cardLeft = item.isRightLane
                                ? _axisX + 12.0 + cardWidth + 10.0
                                : _axisX + 10.0;

                            final cardBg = item.isLavender
                                ? const Color(0xFFB48BB6)
                                : const Color(0xFF72B8B0);

                            final textColor = item.isLavender
                                ? const Color(0xFF28182E)
                                : const Color(0xFF132B33);

                            final endMin = item.startMinutes + item.durationMinutes;
                            final startTimeStr = TimeAnchor.minutesToTimeString(item.startMinutes);
                            final endTimeStr = TimeAnchor.minutesToTimeString(endMin);

                            return Positioned(
                              top: cardTop,
                              left: cardLeft,
                              width: cardWidth.clamp(115.0, 150.0),
                              child: Semantics(
                                button: true,
                                label: 'Actividad ${item.title.replaceAll('\n', ' ')}, de $startTimeStr a $endTimeStr',
                                child: InkWell(
                                  onTap: () => _onShowItemDetails(
                                    title: item.title,
                                    startTime: startTimeStr,
                                    endTime: endTimeStr,
                                    category: item.category,
                                    realAnchor: item.anchorRef,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.22),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        height: 1.18,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modelo interno ligero para posicionar tarjetas en la Malla
class _MallaCardItem {
  final String id;
  final String title;
  final int startMinutes;
  final int durationMinutes;
  final bool isRightLane;
  final bool isLavender;
  final String category;
  final TimeAnchor? anchorRef;

  const _MallaCardItem({
    required this.id,
    required this.title,
    required this.startMinutes,
    required this.durationMinutes,
    required this.isRightLane,
    required this.isLavender,
    required this.category,
    this.anchorRef,
  });
}

class _AddAnchorForm extends StatefulWidget {
  final ValueChanged<TimeAnchor> onSave;
  final String? initialStartTime;

  const _AddAnchorForm({required this.onSave, this.initialStartTime});

  @override
  State<_AddAnchorForm> createState() => _AddAnchorFormState();
}

class _AddAnchorFormState extends State<_AddAnchorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  late String _startTime;
  String _endTime = '11:00';
  String _category = 'Proyecto';
  final List<int> _selectedDays = [1, 2, 3, 4, 5];

  final List<String> _categories = ['Proyecto', 'Reunión', 'Foco', 'Facultad', 'Gimnasio', 'General'];

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStartTime ?? '10:00';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      HapticHelper.warning();
      return;
    }

    final title = _titleController.text.trim();
    final anchor = TimeAnchor.withId(
      id: 'anchor_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      startTime: _startTime,
      endTime: _endTime,
      category: _category,
      daysOfWeek: _selectedDays,
      isRecurring: true,
      isActive: true,
    );
    HapticHelper.success();
    widget.onSave(anchor);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nombre de la actividad:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleController,
              style: TextStyle(fontSize: 14, color: context.textMain),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Por favor ingresá el nombre de la actividad';
                }
                if (val.trim().length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Ej: Revisión Proyecto / Llamada Equipo...',
                hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
                filled: true,
                fillColor: isDark ? Colors.white10 : context.cardSurface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.borderLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.borderLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF45A59E), width: 1.5)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                errorStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 16),

            // Horas de Inicio y Fin
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hora Inicio (HH:mm):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.textSecondary)),
                      const SizedBox(height: 6),
                      _TimeSelectorPill(
                        time: _startTime,
                        onChanged: (newVal) => setState(() => _startTime = newVal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hora Fin (HH:mm):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.textSecondary)),
                      const SizedBox(height: 6),
                      _TimeSelectorPill(
                        time: _endTime,
                        onChanged: (newVal) => setState(() => _endTime = newVal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selector de Categoría
            Text('Categoría:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.textSecondary)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _category == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : context.textSecondary)),
                      selected: isSelected,
                      selectedColor: const Color(0xFF45A59E),
                      backgroundColor: context.cardSurface,
                      onSelected: (val) {
                        if (val) setState(() => _category = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Botón Guardar en Malla
            NeumorphicButton(
              variant: NeumorphicButtonVariant.primary,
              borderRadius: 18,
              height: 50,
              onPressed: _onSave,
              child: const Center(
                child: Text('Guardar en Malla Temporal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TimeSelectorPill extends StatelessWidget {
  final String time;
  final ValueChanged<String> onChanged;

  const _TimeSelectorPill({required this.time, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final parts = time.split(':');
        final current = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        final picked = await showTimePicker(
          context: context,
          initialTime: current,
        );
        if (picked != null) {
          final h = picked.hour.toString().padLeft(2, '0');
          final m = picked.minute.toString().padLeft(2, '0');
          onChanged('$h:$m');
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textMain)),
            const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF45A59E)),
          ],
        ),
      ),
    );
  }
}
