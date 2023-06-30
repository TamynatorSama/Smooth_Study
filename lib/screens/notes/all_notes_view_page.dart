import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/notes_model.dart';
import 'package:smooth_study/screens/notes/single_note_view_page.dart';
import 'package:smooth_study/utils/theme_provider.dart';
import 'package:smooth_study/widget/music_notes_widget.dart';
import 'package:uuid/uuid.dart';

class AllNotesViewPage extends StatefulWidget {
  final String courseCode;
  final String materialName;
  const AllNotesViewPage({
    super.key,
    required this.courseCode,
    required this.materialName,
  });

  @override
  State<AllNotesViewPage> createState() => _AllNotesViewPageState();
}

class _AllNotesViewPageState extends State<AllNotesViewPage> {
  late TextEditingController searchController;
  late AppProvider _appProvider;
  // List<NoteModel> notes=[];
  late final FocusNode _focusNode;

  @override
  initState() {
    searchController = TextEditingController();
    _focusNode = FocusNode();
    _appProvider = Provider.of<AppProvider>(
      context,
      listen: false,
    );
    _appProvider.getNotes(widget.materialName);
    // notes = Provider.of<AppProvider>(context,listen: false).notes;
    setState(() {});
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        _appProvider.clearNotesSearch();
        return;
      }
      _appProvider.searchNotes(searchController.text);
    });
    super.initState();
  }

  @override
  void deactivate() {
  print("""object ASADSDASDAS""");
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // PersonalNotesBox().clearNotes();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SingleNoteViewPage(
                note: NoteModel.newNote(
                  materialName: widget.materialName,
                  uid: const Uuid().v4(),
                ),
                courseCode: widget.courseCode,
              ),
            ),
          );
          _appProvider.getNotes(widget.materialName);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).padding.top,
              horizontal: 24,
            ),
            width: double.maxFinite,
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: const DecorationImage(
                  alignment: Alignment.centerRight,
                  image: AssetImage('assets/back.png'),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Text(
                          '${widget.materialName} Notes',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: Navigator.of(context).pop,
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
            child: Consumer<ThemeProvider>(
              builder: (context, themeCtrl, _) => TextFormField(
                focusNode: _focusNode,
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color:
                          themeCtrl.isDarkMode ? null : const Color(0xAAFFFFFF),
                    ),
                    suffixIcon: AnimatedCrossFade(
                      firstChild: const SizedBox(),
                      secondChild: IconButton(
                        onPressed: () {
                          _focusNode.unfocus();
                          searchController.clear();
                          _appProvider.clearNotesSearch();
                        },
                        icon: const Icon(Icons.cancel),
                      ),
                      crossFadeState: _focusNode.hasPrimaryFocus
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 500),
                    ),
                    hintText: "Search Notes",
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xAAFFFFFF),
                        ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(54),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(54),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(54),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(54),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(54),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16)),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeCtrl.isDarkMode ? null : Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child:
                    Consumer<AppProvider>(builder: (context, appProvider, _) {
                  return Column(
                    children: appProvider.noteSearchResult.isEmpty
                        ? _appProvider.notesSearched
                            ? [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LottieBuilder.asset('assets/empty1.json'),
                                    const Center(
                                      child: Text('No Results'),
                                    ),
                                  ],
                                ),
                              ] // Search is Empty
                            : appProvider.notes.isEmpty
                                ? [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LottieBuilder.asset(
                                            'assets/98121-empty-state.json'),
                                        const Center(
                                          child: Text('No Notes ...yet'),
                                        ),
                                      ],
                                    ),
                                  ]
                                : List.generate(
                                    appProvider.notes.length,
                                    (index) => GestureDetector(
                                      onTap: () async{
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => SingleNoteViewPage(
                                              note: appProvider.notes[index],
                                              courseCode: widget.courseCode,
                                            ),
                                          ),
                                        );
                                        _appProvider.getNotes(widget.materialName);
                                      },
                                      child: NoteWidget(
                                        callback:(){
                                          _appProvider.getNotes(widget.materialName);
                                        },
                                        size: size,
                                        note: appProvider.notes[index],
                                        courseCode: widget.courseCode,
                                      ),
                                    ),
                                  )
                        : List.generate(
                            _appProvider.noteSearchResult.length,
                            (index) => GestureDetector(
                              onTap: _appProvider.noteSearchResult[index] !=
                                      null
                                  ? () async{
                                      await Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => SingleNoteViewPage(
                                            note: _appProvider
                                                .noteSearchResult[index]!,
                                            courseCode: widget.courseCode,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                      _appProvider.getNotes(widget.materialName);
                                    }
                                  : null,
                              child: NoteWidget(
                                callback: (){
                                  _appProvider.getNotes(widget.materialName);
                                },
                                size: size,
                                courseCode: widget.courseCode,
                                note: _appProvider.noteSearchResult[index]!,
                              ),
                            ),
                          ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
