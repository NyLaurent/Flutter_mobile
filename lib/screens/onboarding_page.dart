import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _pages = [
    _OnboardingContent(
      image: 'assets/images/onboarding/onboarding1.png',
      title: 'Scan QR to see menu instantly',
      description:
          'Simply scan the QR code at your table and browse our full menu with photos and details',
    ),
    _OnboardingContent(
      image: 'assets/images/onboarding/onboarding2.png',
      title: 'Order & track your meal easily',
      description:
          'Place your order directly from your phone and get real-time updates on your meal status',
    ),
    _OnboardingContent(
      image: 'assets/images/onboarding/onboarding3.png',
      title: 'Reserve your table anytime',
      description:
          'Book your favorite spot ahead of time and enjoy a seamless dining experience',
    ),
  ];

  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    Navigator.of(context).pushReplacementNamed('/signup');
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Center(
                      child: Image.asset(
                        page.image,
                        fit: BoxFit.contain,
                        semanticLabel: page.title,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_pages.length, (index) {
                    final isCurrent = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isCurrent ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  key: ValueKey(_currentPage),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _pages[_currentPage].title,
                      style: const TextStyle(
                        color: Color(0xFF171B2A),
                        fontSize: 23,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _pages[_currentPage].description,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.72),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 58,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: OutlinedButton(
                        onPressed: _currentPage == 0 ? null : _previousPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: _currentPage == 0
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.primary,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Prev',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: FilledButton(
                        onPressed: _nextPage,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.button,
                          foregroundColor: Colors.white,
                          elevation: 7,
                          shadowColor: AppColors.primary.withOpacity(0.18),
                          side: const BorderSide(
                            color: Color(0xFFD7C39F),
                            width: 2,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
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

class _OnboardingContent {
  const _OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
