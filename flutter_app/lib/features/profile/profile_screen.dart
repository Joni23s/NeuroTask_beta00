import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/user_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_badge.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../data/repositories/providers.dart';
import '../achievements/achievements_vault_screen.dart';
import '../auth/login_register_screen.dart';
import '../settings/settings_screen.dart';

/// Pantalla de Perfil de Usuario con nivel de foco, métricas dinámicas, logros y edición activa.
///
/// Integrada con Riverpod y la Capa de Datos ([UserRepository] y [AchievementRepository])
/// eliminando todas las métricas ficticias hardcodeadas. Cumple con el Tema 1 (DAM).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _buildLevelProgressCard(BuildContext context, UserProfile profile) {
    int nextLevelTarget = 10;
    int currentLevelBase = 0;
    if (profile.level == 2) {
      currentLevelBase = 10;
      nextLevelTarget = 20;
    } else if (profile.level == 3) {
      currentLevelBase = 20;
      nextLevelTarget = 30;
    } else if (profile.level >= 4) {
      currentLevelBase = 30;
      nextLevelTarget = 30;
    }

    final tasksInLevel = profile.totalTasksCompleted - currentLevelBase;
    final tasksNeeded = nextLevelTarget - currentLevelBase;
    final levelProgress = profile.level >= 4
        ? 1.0
        : (tasksInLevel / (tasksNeeded > 0 ? tasksNeeded : 1)).clamp(0.0, 1.0);
    final tasksRemaining = profile.level >= 4
        ? 0
        : (nextLevelTarget - profile.totalTasksCompleted).clamp(0, 30);

    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.subtleElevation,
        border: Border.all(color: context.borderLight),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                profile.level >= 4 ? 'Rango Máximo' : 'Próximo Nivel',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondaryColor,
                ),
              ),
              Text(
                profile.level >= 4
                    ? '100%'
                    : '${profile.totalTasksCompleted} / $nextLevelTarget tareas',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandGlowCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: levelProgress,
              minHeight: 6,
              backgroundColor: context.isDarkMode
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.brandGlowCyan,
              ),
            ),
          ),
          if (profile.level < 4) ...[
            const SizedBox(height: 5),
            Text(
              'Faltan $tasksRemaining tareas para Nivel ${profile.level + 1}',
              style: TextStyle(
                fontSize: 10,
                color: context.textMutedColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditProfileModal(
      BuildContext context, WidgetRef ref, UserProfile profile) {
    HapticHelper.lightTap();
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    String? localError;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: modalContext.surfaceColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: modalContext.textMutedColor
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Editar Datos Personales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: modalContext.textMainColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: modalContext.textMutedColor),
                          onPressed: () => Navigator.pop(modalContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (localError != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFEF4444)
                                  .withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          localError!,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      'Nombre completo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: modalContext.textMainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeuroInsetContainer(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      borderRadius: 14,
                      child: Center(
                        child: TextField(
                          controller: nameController,
                          onChanged: (_) {
                            if (localError != null) {
                              setModalState(() => localError = null);
                            }
                          },
                          style: TextStyle(
                              color: modalContext.textMainColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Tu nombre o apodo',
                            hintStyle: TextStyle(
                                color: modalContext.textMutedColor,
                                fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Correo Electrónico',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: modalContext.textMainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeuroInsetContainer(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      borderRadius: 14,
                      child: Center(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            if (localError != null) {
                              setModalState(() => localError = null);
                            }
                          },
                          style: TextStyle(
                              color: modalContext.textMainColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'ejemplo@correo.com',
                            hintStyle: TextStyle(
                                color: modalContext.textMutedColor,
                                fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: NeumorphicButton(
                              onPressed: () => Navigator.pop(modalContext),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: modalContext.textSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: NeumorphicButton(
                              variant: NeumorphicButtonVariant.primary,
                              onPressed: isSaving
                                  ? () {}
                                  : () async {
                                      final newName =
                                          nameController.text.trim();
                                      final newEmail =
                                          emailController.text.trim();

                                      if (newName.isEmpty) {
                                        setModalState(() => localError =
                                            'El nombre no puede estar vacío.');
                                        return;
                                      }
                                      final emailRegex = RegExp(
                                          r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
                                      if (!emailRegex.hasMatch(newEmail)) {
                                        setModalState(() => localError =
                                            'Ingresá un correo electrónico válido.');
                                        return;
                                      }

                                      setModalState(() => isSaving = true);
                                      HapticHelper.mediumImpact();

                                      final updated = profile.copyWith(
                                        name: newName,
                                        email: newEmail,
                                      );

                                      await ref
                                          .read(userRepositoryProvider)
                                          .updateProfile(updated);
                                      ref.invalidate(
                                          currentUserProfileProvider);

                                      if (modalContext.mounted) {
                                        Navigator.pop(modalContext);
                                      }
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Datos personales actualizados correctamente'),
                                            backgroundColor:
                                                AppColors.successEmeraldDark,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              child: isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Guardar Cambios',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final achievementsAsync = ref.watch(userAchievementsListProvider);

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.textMainColor),
          onPressed: () {
            HapticHelper.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Perfil de Usuario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textMainColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: context.textMainColor),
            onPressed: () {
              HapticHelper.lightTap();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryIndigo),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error al cargar el perfil de usuario',
            style: TextStyle(color: context.textMainColor),
          ),
        ),
        data: (profile) {
          final initials = profile.name.trim().isNotEmpty
              ? profile.name
                  .trim()
                  .split(RegExp(r'\s+'))
                  .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
                  .take(2)
                  .join()
              : 'NT';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Header de Perfil Dinámico
                Center(
                  child: Column(
                    children: [
                      NeumorphicCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 60,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryIndigo,
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.textMainColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      NeuroBadge(
                        label: 'Nivel ${profile.level} — ${profile.levelTitle}',
                        icon: Icons.workspace_premium_rounded,
                        textColor: AppColors.brandGlowCyan,
                      ),
                      const SizedBox(height: 12),
                      _buildLevelProgressCard(context, profile),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Tarjetas de Métricas Dinámicas desde UserRepository
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppColors.successEmerald,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${profile.totalTasksCompleted}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.textMainColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Micro-tareas listas',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: AppColors.amberWarning,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${profile.currentStreak} días',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.textMainColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Racha actual',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeumorphicCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: AppColors.primaryIndigo,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              profile.formattedFocusHours,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.textMainColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tiempo en Foco',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Acceso dinámico a Logros (conectado con AchievementRepository)
                achievementsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (achievements) {
                    final unlocked =
                        achievements.where((a) => a.isUnlocked).length;
                    final total = achievements.length;

                    return NeumorphicCard(
                      padding: const EdgeInsets.all(18),
                      borderRadius: 20,
                      onTap: () {
                        HapticHelper.lightTap();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AchievementsVaultScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.amberWarning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.emoji_events_rounded,
                              color: AppColors.amberWarning,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bóveda de Logros',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.textMainColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$unlocked trofeos desbloqueados de $total',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: context.textMutedColor,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Acciones de Perfil
                NeumorphicCard(
                  padding: const EdgeInsets.all(8),
                  borderRadius: 20,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person_outline_rounded,
                          color: context.textMainColor,
                        ),
                        title: Text(
                          'Editar datos personales',
                          style: TextStyle(color: context.textMainColor),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: context.textMutedColor,
                        ),
                        onTap: () =>
                            _showEditProfileModal(context, ref, profile),
                      ),
                      Divider(
                        height: 1,
                        color: context.textMutedColor.withValues(alpha: 0.15),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.notifications_none_rounded,
                          color: context.textMainColor,
                        ),
                        title: Text(
                          'Preferencias de notificación',
                          style: TextStyle(color: context.textMainColor),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: context.textMutedColor,
                        ),
                        onTap: () {
                          HapticHelper.lightTap();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Botón de Cerrar Sesión (conectado al UserRepository)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: NeumorphicButton(
                    onPressed: () async {
                      HapticHelper.mediumImpact();
                      await ref.read(userRepositoryProvider).logout();
                      ref.invalidate(currentUserProfileProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sesión cerrada correctamente'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginRegisterScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            color: Colors.redAccent, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
