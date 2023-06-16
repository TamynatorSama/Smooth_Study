import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_study/utils/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({super.key});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {

  Timer? _removeAppBar;
  bool hideAppBar = false;





  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _removeAppBar = getTimer();
    super.initState();
  }


  getTimer(){
    return Timer(const Duration(seconds: 5),(){
      setState(() {
        hideAppBar = true;
      });
    });
  }

  @override
  void dispose() {
    _removeAppBar!.cancel();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event){
        setState(() {
          hideAppBar = false;
        });
        if(_removeAppBar != null){
          _removeAppBar!.cancel();
          _removeAppBar = getTimer();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite,80),
          child: AnimatedContainer(
            height: hideAppBar ? 0:80,
          duration: const Duration(milliseconds: 300),
          child: AppBar(
          title: Text("KOLAWOLE_SAMUEL_OLUWASEGUN",style: primaryTextStyle.copyWith(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 49, 49, 49),
          leadingWidth: 40,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_rounded,size: 18,)),
          actions: [
            IconButton(onPressed: (){
          }, icon: const Icon(Icons.cloud_download_rounded,size: 20,)),
          IconButton(onPressed: (){
          }, icon: const Icon(Icons.add,size: 20,)),
          ],
        ),
        ), ),
        // AppBar(
        //   title: Text("KOLAWOLE_SAMUEL_OLUWASEGUN",style: primaryTextStyle.copyWith(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
        //   backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        //   leadingWidth: 40,
        //   leading: IconButton(onPressed: (){
        //     Navigator.pop(context);
        //   }, icon: const Icon(Icons.arrow_back_ios_rounded,size: 18,)),
        //   actions: [
        //     IconButton(onPressed: (){
        //   }, icon: const Icon(Icons.cloud_download_rounded,size: 20,)),
        //   IconButton(onPressed: (){
        //   }, icon: const Icon(Icons.add,size: 20,)),
        //   ],
        // ),
        body: SfPdfViewer.asset(
          "assets/KOLAWOLE_SAMUEL_OLUWASEGUN.pdf",
          key: _pdfViewerKey,
          pageLayoutMode: PdfPageLayoutMode.continuous
          ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff6259FF),
          child: const Icon(Icons.bookmark),
          onPressed: (){
          _pdfViewerKey.currentState!.openBookmarkView();
        }),
      ),
    );
  }
}