import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/neumorphic_card.dart';
import '../../core/widgets/neuro_badge.dart';
import '../achievements/achievements_vault_screen.dart';
import '../settings/settings_screen.dart';

/// Pantalla de Perfil de Usuario con nivel de foco, métricas y logros.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Header de Perfil
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
                      child: const Center(
                        child: Text(
                          'NT',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Usuario NeuroTask',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textMainColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const NeuroBadge(
                    label: 'Nivel 3 — Maestro del Foco',
                    icon: Icons.workspace_premium_rounded,
                    color: AppColors.brandGlowCyan,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Tarjetas de Métricas Rápidas
            Row(
              children: [
                Expanded(
                  child: NeumorphicCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: AppColors.successEmerald, size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '24',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textMainColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Micro-tareas listos',
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
                        Icon(Icons.bolt_rounded, color: AppColors.amberWarning, size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '5 días',
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
                        Icon(Icons.timer_outlined, color: AppColors.primaryIndigo, size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '6.2 h',
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

            // Acceso rápido a Logros
            NeumorphicCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 20,
              onTap: () {
                HapticHelper.lightTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AchievementsVaultScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.amberWarning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.emoji_events_rounded, color: AppColors.amberWarning, size: 28),
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
                          '4 trofeos desbloqueados de 8',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: context.textMutedColor, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Acciones de Perfil
            NeumorphicCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 20,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline_rounded, color: context.textMainColor),
                    title: Text('Editar datos personales', style: TextStyle(color: context.textMainColor)),
                    trailing: Icon(Icons.chevron_right_rounded, color: context.textMutedColor),
                    onTap: () => HapticHelper.lightTap(),
                  ),
                  Divider(height: 1, color: context.textMutedColor.withOpacity(0.15)),
                  ListTile(
                    leading: Icon(Icons.notifications_none_rounded, color: context.textMainColor),
                    title: Text('Preferencias de notificación', style: TextStyle(color: context.textMainColor)),
                    trailing: Icon(Icons.chevron_right_rounded, color: context.textMutedColor),
                    onTap: () {
                      HapticHelper.lightTap();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón de Cerrar Sesión
            SizedBox(
              width: double.infinity,
              height: 48,
              child: NeumorphicButton(
                onPressed: () {
                  HapticHelper.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada correctamente')),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
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
      ),
    );
  }
}
