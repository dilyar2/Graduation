import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:graduation2/Features/authentication/presentation/pages/manager/bloc/auth_bloc.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/theme/theme_toggle_button.dart';
import 'package:graduation2/core/theme/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(GetProfileEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.login,
              (route) => false,
            );
          }
        },
        child: const _ProfileView(),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return _ProfileError(
              message: state.message,
              onRetry: () {
                context.read<ProfileBloc>().add(GetProfileEvent());
              },
            );
          }

          if (state is! ProfileLoaded) {
            return const SizedBox.shrink();
          }

          final profile = state.profileModel;
          final name = '${profile.firstName ?? ''} ${profile.lastName ?? ''}'
              .trim();
          final displayName = name.isEmpty ? 'Student' : name;
          final initials = _initials(displayName);
          final imageUrl = profile.imageUrl?.trim() ?? '';

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(GetProfileEvent());
              await Future<void>.delayed(
                const Duration(milliseconds: 350),
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              children: [
                _ProfileHeader(
                  displayName: displayName,
                  email: profile.email,
                  initials: initials,
                  imageUrl: imageUrl,
                ),
                const SizedBox(height: 20),
                Text(
                  'Account information',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _ProfileCard(
                  icon: Icons.person_outline_rounded,
                  title: 'Full name',
                  value: displayName,
                ),
                const SizedBox(height: 10),
                _ProfileCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: profile.email ?? '-',
                ),
                const SizedBox(height: 10),
                _ProfileCard(
                  icon: Icons.phone_outlined,
                  title: 'Phone number',
                  value: profile.phoneNumber ?? '-',
                ),
                const SizedBox(height: 20),
                Text(
                  'Preferences',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _ThemePreferenceCard(),
                const SizedBox(height: 20),
                Text(
                  'Account',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: colors.error,
                      ),
                    ),
                    title: const Text('Logout'),
                    subtitle: const Text('Sign out from this device'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _confirmLogout(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String value) {
    final parts = value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();

    if (parts.isEmpty) return '?';
    return parts.map((part) => part[0].toUpperCase()).join();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text(
            'You will need to sign in again to access your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String? email;
  final String initials;
  final String imageUrl;

  const _ProfileHeader({
    required this.displayName,
    required this.email,
    required this.initials,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .7),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: colors.primary.withValues(alpha: .14),
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isNotEmpty
                ? null
                : Text(
                    initials,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall,
                ),
                if (email?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 5),
                  Text(
                    email!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Student',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePreferenceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.secondary.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: colors.secondary,
          ),
        ),
        title: const Text('Appearance'),
        subtitle: Text(
          isDark ? 'Dark mode' : 'Light mode',
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (_) {
            final controller = ThemeControllerScope.of(context);
            controller.toggle(currentlyDark: isDark);
          },
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => _ProfileCard(
        icon: Icons.info_outline_rounded,
        title: title,
        value: value,
      );
}

class _ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 52,
              color: colors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
