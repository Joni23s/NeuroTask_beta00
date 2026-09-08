import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/time_anchor.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neuro_badge.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../core/widgets/neuro_modal_sheet.dart';
import '../../core/widgets/theme_toggle_button.dart';
import 'anchors_controller.dart';

class AnchorsManagerScreen extends ConsumerStatefulWidget {
  const AnchorsManagerScreen({super.key});

  @override
  ConsumerState<AnchorsManagerScreen> createState() => _AnchorsManagerScreenState();
}

class _AnchorsManagerScreenState extends ConsumerState<AnchorsManagerScreen> {
  final List<String> _weekdaysShort = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  void _onOpenAddAnchorSheet() {
    HapticHelper.lightTap();
    showNeuroModalSheet(
      context: context,
      builder: (ctx) => NeuroModalSheet(
        title: 'Nueva Ancla Horaria',
        subtitle: 'Definí un horario fijo que no se negocia hoy ni en tu semana',
        child: _AddAnchorForm(
          onSave: (anchor) {
            ref.read(anchorsProvider.notifier).addAnchor(anchor);
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _onDeleteAnchor(TimeAnchor anchor) {
    HapticHelper.warning();
    ref.read(anchorsProvider.notifier).deleteAnchor(anchor.id);
  }

  @override
  Widget build(BuildContext context) {
    final anchorsState = ref.watch(anchorsProvider);
    final todayAnchors = anchorsState.anchorsForSelectedDay;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con Botón de Regreso, Título y Modo Oscuro
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Volver a la pantalla anterior',
                    child: InkWell(
                      onTap: () {
                        HapticHelper.lightTap();
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: context.cardSurface,
                          shape: BoxShape.circle,
                          boxShadow: context.subtleElevation,
                          border: Border.all(color: context.borderLight),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: context.textMain, size: 20),
                      ),
                    ),
                  ),
                  const NeuroBadge.status(
                    label: 'Anclas Temporales Fijas',
                    dotColor: AppColors.brandSteelBlue,
                  ),
                  const ThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 20),

              // Título y Subtítulo inspirados en el Wireframe 2
              Text(
                '¿Cuáles son tus horarios de hoy?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.textMain,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Establecer anclas fijas ayuda a no solapar tareas con tu facultad o rutinas.',
                style: TextStyle(fontSize: 13, color: context.textSecondary),
              ),
              const SizedBox(height: 16),

              // Selector de Días de la Semana
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(7, (index) {
                    final dayNum = index + 1;
                    final isSelected = anchorsState.selectedWeekday == dayNum;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          HapticHelper.selectionClick();
                          ref.read(anchorsProvider.notifier).selectWeekday(dayNum);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                                : context.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected ? null : context.subtleElevation,
                            border: Border.all(
                              color: isSelected ? Colors.transparent : context.borderLight,
                            ),
                          ),
                          child: Text(
                            _weekdaysShort[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),

              // Neumorphic Inset Container con Lista de Anclas
              Expanded(
                child: NeuroInsetContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  borderRadius: 28,
                  child: Stack(
                    children: [
                      todayAnchors.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.anchor_rounded, size: 48, color: context.textMuted.withValues(alpha: 0.5)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No hay anclas para este día',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textMain),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Agregá horarios como Cursada, Gym o Almuerzo.',
                                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: todayAnchors.length + 1, // +1 para dejar espacio al FAB
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == todayAnchors.length) {
                                  return const SizedBox(height: 64); // Espacio para el botón +
                                }
                                final anchor = todayAnchors[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: context.cardSurface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: context.subtleElevation,
                                    border: Border.all(color: context.borderLight),
                                  ),
                                  child: Row(
                                    children: [
                                      // Rango Horario
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.white10 : AppColors.primaryIndigo.withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              anchor.startTime,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              height: 6,
                                              color: context.textMuted.withValues(alpha: 0.4),
                                              margin: const EdgeInsets.symmetric(vertical: 2),
                                            ),
                                            Text(
                                              anchor.endTime,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: context.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),

                                      // Nombre y categoría
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              anchor.title,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: context.textMain,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${anchor.category} • ${anchor.durationMinutes} min',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: context.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Botón de Borrar (✕) sutil
                                      Semantics(
                                        button: true,
                                        label: 'Eliminar ancla ${anchor.title}',
                                        child: InkWell(
                                          onTap: () => _onDeleteAnchor(anchor),
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 18,
                                              color: context.textMuted,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                      // Botón (+) Flotante Neumórfico centrado abajo del contenedor
                      Positioned(
                        bottom: 4,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Semantics(
                            button: true,
                            label: 'Agregar nueva ancla horaria',
                            child: InkWell(
                              onTap: _onOpenAddAnchorSheet,
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: context.cardSurface,
                                  shape: BoxShape.circle,
                                  boxShadow: context.subtleElevation,
                                  border: Border.all(
                                    color: (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo)
                                        .withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Botón de Acción Inferior: "Listo / Guardar"
              NeumorphicButton(
                variant: NeumorphicButtonVariant.primary,
                borderRadius: 20,
                height: 54,
                onPressed: () {
                  HapticHelper.lightTap();
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Listo, Horarios Guardados',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAnchorForm extends StatefulWidget {
  final ValueChanged<TimeAnchor> onSave;

  const _AddAnchorForm({required this.onSave});

  @override
  State<_AddAnchorForm> createState() => _AddAnchorFormState();
}

class _AddAnchorFormState extends State<_AddAnchorForm> {
  final TextEditingController _titleController = TextEditingController();
  String _startTime = '17:30';
  String _endTime = '19:30';
  String _category = 'Facultad';
  final List<int> _selectedDays = [1, 2, 3, 4, 5];

  final List<String> _categories = ['Facultad', 'Gimnasio', 'Trabajo', 'Cena', 'Salud', 'General'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final anchor = TimeAnchor(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título del compromiso
          Text('Nombre de la actividad:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            style: TextStyle(fontSize: 14, color: context.textMain),
            decoration: InputDecoration(
              hintText: 'Ej: Clases de DAM / Entrenamiento...',
              hintStyle: TextStyle(fontSize: 13, color: context.textMuted),
              filled: true,
              fillColor: isDark ? Colors.white10 : context.cardSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.borderLight)),
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
                    selectedColor: AppColors.primaryIndigo,
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

          // Botón Crear
          NeumorphicButton(
            variant: NeumorphicButtonVariant.primary,
            borderRadius: 18,
            height: 50,
            onPressed: _onSave,
            child: const Center(
              child: Text('Guardar Ancla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 16),
        ],
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
            const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryIndigo),
          ],
        ),
      ),
    );
  }
}
