import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/dialogs/create_group.dart';
import 'package:nylo/components/textfields/rounded_textfield.dart';
import 'package:nylo/components/textfields/rounded_textfield_dropdown.dart';
import 'package:nylo/error/login_response.dart';
import 'package:nylo/structure/auth/auth_service.dart';
import 'package:nylo/structure/providers/register_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RegisterPage extends ConsumerWidget {
  final void Function()? onTap;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  RegisterPage({
    super.key,
    required this.onTap,
  });

  // register

  Future<void> register(
    BuildContext context,
    String universityName,
    String universityId,
    String emailDomain,
    List<String> domains,
  ) async {
    // get auth service
    final auth = AuthService();
    if (_pwController.text.isNotEmpty &&
        _confirmPwController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        universityName.isNotEmpty &&
        universityId.isNotEmpty) {
      // password match => create user
      if (_pwController.text == _confirmPwController.text) {
        LoginResponse response = await auth.signUpWithEmailPassword(
          context,
          _emailController.text,
          _pwController.text,
          _firstNameController.text,
          _lastNameController.text,
          universityName,
          universityId,
          emailDomain,
          domains,
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
            content: "Password does not match.",
            title: "Failed",
            type: "Okay",
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const CreateGroupChatDialog(
          confirm: null,
          content: "Incomplete information.",
          title: "Failed",
          type: "Okay",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchUniversity = ref.watch(searchUniversityProvier);
    final controller = PageController();
    final lastPage = ref.watch(lastPageProvider);
    final firstPage = ref.watch(firstPageProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final domains = ref.watch(universityDomainNamesProvider).value;
    print("DOMAINS: $domains");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
        ),
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            if (value == 2) {
              ref.read(lastPageProvider.notifier).update((state) => true);
            } else {
              ref.read(lastPageProvider.notifier).update((state) => false);
            }
            if (value == 0) {
              ref.read(firstPageProvider.notifier).update((state) => true);
            } else {
              ref.read(firstPageProvider.notifier).update((state) => false);
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "What university are you from?",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: (value) {
                        ref
                            .read(uniSearchQueryProvider.notifier)
                            .update((state) => value);
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          filled: true,
                          hintText: "Search",
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  searchUniversity.when(
                    data: (university) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: university.length,
                          itemBuilder: (context, index) {
                            final universityItem = university[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedIndexProvider.notifier)
                                    .update((state) => index);
                                ref.read(emailDomainProvider.notifier).state =
                                    universityItem.emailIndicator;

                                ref
                                    .read(universityNameProvider.notifier)
                                    .state = universityItem.uniName;

                                ref.read(universityIdProvider.notifier).state =
                                    universityItem.uniId;

                                ref.read(dropDownListProvider.notifier).state =
                                    universityItem.domains
                                        .map((domain) => domain.toString())
                                        .toList();
                                print(
                                    "dropDownListProvider: ${universityItem.domains}");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(universityItem.logo),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(universityItem.uniName),
                                    ),
                                    Radio(
                                        value: index,
                                        groupValue: selectedIndex,
                                        focusColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        onChanged: (number) {
                                          ref
                                              .read(selectedIndexProvider
                                                  .notifier)
                                              .update((state) => number as int);

                                          ref
                                                  .read(emailDomainProvider
                                                      .notifier)
                                                  .state =
                                              universityItem.emailIndicator;
                                          ref
                                              .read(universityNameProvider
                                                  .notifier)
                                              .state = universityItem.uniName;

                                          ref
                                              .read(
                                                  universityIdProvider.notifier)
                                              .state = universityItem.uniId;
                                          ref
                                                  .read(dropDownListProvider
                                                      .notifier)
                                                  .state =
                                              universityItem.domains
                                                  .map((domain) =>
                                                      domain.toString())
                                                  .toList();
                                        })
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('Error: $error'),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "What is your name?",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        hintText: "First Name",
                        obscureText: false,
                        controller: _firstNameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        hintText: "Last Name",
                        obscureText: false,
                        controller: _lastNameController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What is your email?",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedTextFieldDropDown(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    hintText: "Email",
                    obscureText: false,
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "How about your password?",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      hintText: "Password",
                      obscureText: true,
                      controller: _pwController),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      hintText: "Confirm password",
                      obscureText: true,
                      controller: _confirmPwController),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Stack(
          children: [
            SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        dotColor: Theme.of(context).colorScheme.secondary,
                        activeDotColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: firstPage
                          ? null
                          : () {
                              controller.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                              ref.read(dropDownValueProvider.notifier).state =
                                  '';
                            },
                      child: firstPage
                          ? const Text('')
                          : const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                    ),
                    TextButton(
                      onPressed: lastPage
                          ? () async {
                              register(
                                context,
                                ref.watch(universityNameProvider),
                                ref.watch(universityIdProvider),
                                ref.watch(dropDownValueProvider),
                                //ref.watch(emailDomainProvider),
                                ref.watch(dropDownListProvider), //domains!,
                              );
                            }
                          : () {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                              ref.read(dropDownValueProvider.notifier).state =
                                  ref.watch(dropDownListProvider).first;
                            },
                      child: lastPage
                          ? Text(
                              "Verify",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                fontSize: 18,
                              ),
                            )
                          : selectedIndex.isNegative
                              ? const Text('')
                              : const Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
