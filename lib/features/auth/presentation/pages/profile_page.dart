import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polytalk/features/progress/presentation/widgets/progress_widget.dart';
import 'login_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';
import '../../../language/presentation/pages/language_selection_page.dart';
import '../../../subscription/presentation/pages/subscription_page.dart';
import '../../../ads/widgets/rewarded_ad_widget.dart';
import '../../../ads/widgets/banner_ad_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final user = state.user;
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 900;
                  final avatarRadius = isWide ? 70.0 : isTablet ? 56.0 : 44.0;
                  final cardPad = isWide ? 48.0 : isTablet ? 32.0 : 16.0;
                  final cardWidth = isWide ? 600.0 : isTablet ? 420.0 : double.infinity;
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.10),
                          Theme.of(context).colorScheme.surfaceVariant,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Hero header with blurred background and floating avatar
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: isWide ? 220 : isTablet ? 160 : 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.25),
                                        Theme.of(context).colorScheme.secondary.withOpacity(0.10),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -avatarRadius/2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(source: ImageSource.gallery);
                                      if (picked != null) {
                                        // TODO: Implement upload and update logic
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Profile picture update not implemented.')),
                                        );
                                      }
                                    },
                                    child: Tooltip(
                                      message: 'Tap to change profile picture',
                                      child: Material(
                                        elevation: 8,
                                        shape: const CircleBorder(),
                                        child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                                            ? CircleAvatar(
                                                radius: avatarRadius,
                                                backgroundImage: NetworkImage(user.photoUrl!),
                                              )
                                            : CircleAvatar(
                                                radius: avatarRadius,
                                                child: Icon(Icons.person, size: avatarRadius),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: avatarRadius/1.2),
                            // Profile Card
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                              margin: EdgeInsets.symmetric(horizontal: cardPad, vertical: 8),
                              child: Container(
                                width: cardWidth,
                                padding: EdgeInsets.symmetric(vertical: cardPad, horizontal: cardPad),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(user.name ?? 'No Name', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: isWide ? 28 : isTablet ? 22 : 18)),
                                    const SizedBox(height: 6),
                                    Text(user.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: isWide ? 18 : isTablet ? 16 : 14)),
                                    const SizedBox(height: 24),
                                    Divider(thickness: 1.2, color: Theme.of(context).dividerColor.withOpacity(0.2)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text('Account Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_camera, color: Theme.of(context).colorScheme.primary),
                                      title: const Text('Change Profile Picture'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final picked = await picker.pickImage(source: ImageSource.gallery);
                                        if (picked != null) {
                                          // TODO: Implement upload and update logic
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Profile picture update not implemented.')),
                                          );
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                                      title: const Text('Choose Language'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const LanguageSelectionPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                                      title: const Text('Subscription'),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        RewardedAdWidget.load(
                                          adUnitId: 'ca-app-pub-3940256099942544/5224354917',
                                          onRewarded: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const SubscriptionPage(),
                                              ),
                                            );
                                          },
                                          onAdClosed: () {},
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Divider(thickness: 1.2, color: Theme.of(context).dividerColor.withOpacity(0.2)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text('Your Progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    ),
                                    ProgressWidget(isProUser: true, userId: user.id),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            BannerAdWidget(adUnitId: 'ca-app-pub-3940256099942544/6300978111'),
                            const SizedBox(height: 24),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: cardPad),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.read<AuthBloc>().add(LogoutRequested());
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  foregroundColor: Theme.of(context).colorScheme.onError,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: isWide ? 20 : 16),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Not logged in.'));
            }
          },
        ),
      ),
    );
  }
}
