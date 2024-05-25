import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/textfields/rounded_textfield.dart';
import 'package:nylo/error/login_response.dart';
import 'package:nylo/pages/account/forgot_password.dart';
import 'package:nylo/structure/auth/auth_service.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class LoginPage extends ConsumerWidget {
  // on Tap
  final void Function()? onTap;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final AuthService _authService = AuthService();
  LoginPage({
    super.key,
    required this.onTap,
  });

  //login with Google
  Future<void> signInWithGoogle(
    BuildContext context,
    List<Map<String, dynamic>> idAndUnis,
    WidgetRef ref,
  ) async {
    await _authService.signInWithGoogle(
      context,
      idAndUnis,
      ref,
    );
  }

  // login method
  Future<void> login(
    BuildContext context,
    List<Map<String, dynamic>> idAndUnis,
  ) async {
    if (_emailController.text.isNotEmpty && _pwController.text.isNotEmpty) {
      LoginResponse response = await _authService.signInWithEmailPassword(
        context,
        _emailController.text,
        _pwController.text,
        idAndUnis,
      );

      if (!response.isSuccess) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(response.message ?? 'Unknown error'),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const CreateGroupChatDialog(
          confirm: null,
          content: "Kindly enter your email and password.",
          title: "Failed",
          type: "Okay",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(listOfDomains);
    final List<Map<String, dynamic>> idAndUnis = [];
    final isLoading = ref.watch(googleSignInLoading);
    if (asyncData is AsyncData) {
      final listDomains = asyncData.value;
      if (listDomains != null && listDomains.isNotEmpty) {
        for (final domain in listDomains) {
          idAndUnis.add({
            'uniId': domain['uniId'],
            'domains': domain['domains'],
            'uniName': domain['uniName'],
          });
        }
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nylo",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 40),
                    ),
                    Text(
                      "Find study groups and tutors easily",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundedTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      hintText: "Email",
                      obscureText: false,
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundedTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      hintText: "Password",
                      controller: _pwController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundedButton(
                        text: "Sign in",
                        onTap: () async {
                          login(
                            context,
                            idAndUnis,
                          );
                        },
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        textcolor: Theme.of(context).colorScheme.background),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
                                thickness: 1,
                              ),
                            ),
                          ),
                          Text(
                            "or continue with",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Divider(
                                color: Theme.of(context).colorScheme.primary,
                                thickness: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: isLoading
                              ? () {}
                              : () async {
                                  final signin =
                                      ref.read(googleSignInLoading.notifier);
                                  signin.update((state) => true);
                                  await signInWithGoogle(
                                    context,
                                    idAndUnis,
                                    ref,
                                  );
                                  signin.update(
                                    (state) => false,
                                  );
                                },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/google-color_svgrepo.com.svg',
                                height: 20,
                                width: 20,
                              ),
                              Expanded(
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const Text(
                                        "Google",
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12)),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final googleSignInLoading = StateProvider<bool>((ref) => false);
