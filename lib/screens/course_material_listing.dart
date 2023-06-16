import 'package:flutter/material.dart';
import 'package:smooth_study/utils/theme.dart';

class CourseMaterialListing extends StatelessWidget {
  const CourseMaterialListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top, horizontal: 24),
            width: double.maxFinite,
            height: 250,
            decoration: const BoxDecoration(
                color: Color(0xff383838),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                image: DecorationImage(
                    alignment: Alignment.centerRight,
                    image: AssetImage('assets/back.png'),
                    fit: BoxFit.fitHeight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Text(
                            "CSC 401",
                            style: primaryTextStyle.copyWith(fontSize: 32,color: Colors.white,fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: (){
                      print("object");
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: "Search Course",
                filled: true,
                fillColor: const Color.fromARGB(255, 233, 233, 233),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16)
                
              ),
              
              style: primaryTextStyle,
            ),
          ),
          // const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: 5, itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 228, 228, 228),
                          // child: Icon(Icons.docu),
                        ),
                        title: Text("The intro to lorem ipsum",style:primaryTextStyle),
                        subtitle: Text('Jun 12',style:primaryTextStyle.copyWith(fontSize: 14,color: Colors.grey)),
                        trailing: IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 4,
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}