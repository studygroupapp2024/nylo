import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/components/buttons/rounded_button_with_progress.dart';
import 'package:nylo/components/information_snackbar.dart';
import 'package:nylo/components/textfields/rounded_textfield_title.dart';
import 'package:nylo/structure/providers/chat_provider.dart';
import 'package:nylo/structure/providers/create_group_chat_providers.dart';
import 'package:nylo/structure/providers/storage_provider.dart';
import 'package:nylo/structure/providers/university_provider.dart';

class SendSpecialMessage extends ConsumerWidget {
  final String groupChatId;
  final String groupChatTitle;

  const SendSpecialMessage({
    super.key,
    required this.groupChatId,
    required this.groupChatTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Compose a content"),
      ),
      body: Column(
        children: [
          RoundedTextFieldTitle(
            title: "Enter a message",
            hinttext: "Name",
            controller: messageController,
            onChange: null,
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 25,
              bottom: 10,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Attach Document",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          if (ref.watch(documentTypeProvider) == '')
            GestureDetector(
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: [
                    'jpg',
                    'png',
                    'pdf',
                    'doc',
                    'docx',
                  ],
                );

                if (result == null) {
                  if (context.mounted) {
                    informationSnackBar(
                      context,
                      Icons.info_outline,
                      "No item has been selected.",
                    );
                  }

                  return;
                } else {
                  final fileSize = result.files.single.size;
                  print("fileSize: $fileSize");
                  if (fileSize > 10 * 1024 * 1024) {
                    if (context.mounted) {
                      informationSnackBar(
                        context,
                        Icons.info_outline,
                        "File size exceeds the limit of 10MB.",
                      );
                      return;
                    }
                  } else {
                    final filename = result.files.single.name;

                    ref.read(pathNameProvider.notifier).state =
                        result.files.single.path.toString();
                    ref.read(fileNameProvider.notifier).state =
                        result.files.single.name;
                    print("filename: $filename");

                    if (filename.toLowerCase().endsWith('.jpg') ||
                        filename.toLowerCase().endsWith('.jpeg') ||
                        filename.toLowerCase().endsWith('.png')) {
                      ref.read(documentTypeProvider.notifier).state = 'image';
                    } else if (filename.toLowerCase().endsWith('.pdf') ||
                        filename.toLowerCase().endsWith('.doc') ||
                        filename.toLowerCase().endsWith('.docx')) {
                      ref.read(documentTypeProvider.notifier).state =
                          'document';
                    } else {
                      if (context.mounted) {
                        informationSnackBar(
                            context, Icons.warning, "Unknown file type");
                      }
                    }
                  }
                }
              },
              child: Container(
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.edit_document),
                      Expanded(
                        child: Text(
                          "Upload",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (ref.watch(documentTypeProvider).isNotEmpty)
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    ref.watch(fileNameProvider),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          RoundedButtonWithProgress(
            text: "Send",
            onTap: () async {
              ref.watch(isLoadingProvider.notifier).state = true;
              final isSuccess = await ref.read(chatProvider).sendContentMessage(
                    ref.watch(pathNameProvider),
                    ref.watch(fileNameProvider),
                    groupChatId,
                    messageController.text,
                    'chat',
                    ref.watch(documentTypeProvider),
                    groupChatTitle,
                    ref.watch(setGlobalUniversityId),
                    true,
                  );

              ref.watch(isLoadingProvider.notifier).state = false;
              if (isSuccess) {
                ref.watch(documentTypeProvider.notifier).state = '';
                ref.read(pathNameProvider.notifier).state = '';
                ref.read(fileNameProvider.notifier).state = '';
                messageController.clear();
              }
            },
            margin: const EdgeInsets.symmetric(horizontal: 25),
            color: const Color(0xff939cc4),
            textcolor: Theme.of(context).colorScheme.background,
          ),
        ],
      ),
    );
  }
}


// 