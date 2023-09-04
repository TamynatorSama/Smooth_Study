import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smooth_study/widget/loader.dart';

class UploadMaterial extends StatefulWidget {
  final UploadTask taskUpdate;
  const UploadMaterial({Key? key, required this.taskUpdate}) : super(key: key);

  @override
  State<UploadMaterial> createState() => _UploadMaterialState();
}

class _UploadMaterialState extends State<UploadMaterial> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Loader(
                    processing: processing,
                  ),
                  Text(processing ? "Upload in Progress" : "Upload Successful",
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.9),
              child: InkWell(
                onTap: () {
                  if (processing) return;
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                      color:
                          processing ? const Color(0xff6259FF).withOpacity(0.7) : const Color(0xff6259FF),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Proxima Nova"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
