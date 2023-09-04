import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/utils/custom_input.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import 'package:smooth_study/widget/material_record_screen.dart';

Future<bool> showPassword(BuildContext context, String materialFolder,
    {required Function() callback}) async {
  await showDialog(
      context: context,
      builder: (context) => ClipRRect(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Dialog(
                // shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(24),
                child: ShowPasswordDialog()),
          ))).then((value) async {
    if (value) {
      await showDialog(
          context: context,
          builder: (context) => ClipRRect(
                  child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Dialog(
                    // shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(24),
                    child: QuickAction(
                      materialFolder: materialFolder,
                    )),
              )));
      callback();
    }
  });

  return false;
}

class QuickAction extends StatelessWidget {
  final String materialFolder;
  const QuickAction({Key? key, required this.materialFolder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? const Color.fromARGB(255, 7, 7, 19)
              : Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MaterialRecordScreen(materialFolder:materialFolder)));
              },
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffF9818E),
                    borderRadius: BorderRadius.circular(10)),
                constraints: const BoxConstraints(maxHeight: 130),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 28 28"><path fill="white" d="M8.5 6.5a4.5 4.5 0 1 1 9 0v7.124a7.513 7.513 0 0 0-4.35 5.373L13 19a4.5 4.5 0 0 1-4.5-4.5v-8ZM13.016 21H13a6.5 6.5 0 0 1-6.5-6.5v-.75a.75.75 0 1 0-1.5 0v.75a8 8 0 0 0 7.25 7.965v2.785a.75.75 0 0 0 1.5 0v-1.477A7.457 7.457 0 0 1 13.016 21Zm7.484 4.5a5 5 0 1 1 0-10a5 5 0 0 1 0 10Zm0 1.5a6.5 6.5 0 1 0 0-13a6.5 6.5 0 0 0 0 13Zm0-3a3.5 3.5 0 1 0 0-7a3.5 3.5 0 0 0 0 7Z"/></svg>',
                      width: 52,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Record Note",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      "pdf",
                      "mp3",
                      "m4a"
                    ]).then((value) async {
                  if (value == null) {
                    return;
                  }
                  await Provider.of<AppProvider>(context, listen: false)
                      .uploadMaterial(context,
                          materialFolder: materialFolder,
                          file: File(value.files.first.path ?? ""))
                      .then((value) => Navigator.pop(context));
                });
              },
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0xff6259FF),
                    borderRadius: BorderRadius.circular(10)),
                constraints: const BoxConstraints(maxHeight: 130),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="none"><path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 16v3m0 3v-3m0 0h3m-3 0h-3"/><path fill="white" fill-rule="evenodd" d="M6 2a3 3 0 0 0-3 3v14a3 3 0 0 0 3 3h7.803A6 6 0 0 1 21 13.341V5a3 3 0 0 0-3-3H6zm2 10V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v7l-2.293-2.293a1 1 0 0 0-1.414 0L8 12z" clip-rule="evenodd"/></g></svg>',
                      width: 52,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 80,
                            maxWidth:
                                (MediaQuery.of(context).size.width * 0.5) - 50),
                        child: Text(
                          "Upload material",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 16, color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ShowPasswordDialog extends StatefulWidget {
  const ShowPasswordDialog({super.key});

  @override
  State<ShowPasswordDialog> createState() => _ShowPasswordDialogState();
}

class _ShowPasswordDialogState extends State<ShowPasswordDialog> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(
          maxHeight: 260,
        ),
        decoration: BoxDecoration(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? const Color.fromARGB(255, 7, 7, 19)
                : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Authorization",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(
              label: "Admin Password",
              controller: controller,
              isPassword: true,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                print(controller.text.trim());
                if (controller.text.trim().isEmpty) {
                  return;
                }
                if (controller.text.trim() == "Admin@123") {
                  Navigator.pop(context, true);
                  return;
                }
                Navigator.pop(context, false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Incorrect Password",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor),
                )));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff6259FF),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "Authorize",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Proxima Nova"),
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
