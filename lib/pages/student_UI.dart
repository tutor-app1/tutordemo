import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorapptrials/pages/auth1_model.dart';
import 'tutor_profile.dart';
import 'tutor_UI.dart';
import 'student_UI_model.dart';
export 'student_UI_model.dart';

class StudentUIWidget extends StatefulWidget {
  const StudentUIWidget({super.key});

  @override
  State<StudentUIWidget> createState() => _StudentUIpageWidgetState();
}

class _StudentUIpageWidgetState extends State<StudentUIWidget>
    with TickerProviderStateMixin {
  late StudentUIpageModel _model;

  final username = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.displayName
      : '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser;

  Future<List<DocumentSnapshot>> fetchTutors(String query) async {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tutor')
        .where('lowercase_username', isEqualTo: query.toLowerCase())
        .get();

    QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('tutor')
        .where('lowercase_subject', isEqualTo: query.toLowerCase())
        .get();

    return [
      ...snapshot.docs.where((doc) => doc.id != currentUserUid),
      ...snapshot2.docs.where((doc) => doc.id != currentUserUid),
    ];
  }

  List<DocumentSnapshot> searchResults = [];

  List allTutors = [];
  List resultList = [];

  searchResultsList() {
    var showResults = [];
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    if (_model.textController.text != '') {
      for (var tutorSnapShot in allTutors) {
        // Skip if the tutor is the current user
        if (tutorSnapShot.id == currentUserUid) {
          continue;
        }
        var name = tutorSnapShot['username'].toString().toLowerCase();
        if (name.contains(_model.textController.text.toLowerCase())) {
          showResults.add(tutorSnapShot);
        }
      }
    } else {
      showResults = List.from(allTutors);
    }

    setState(() {
      resultList = showResults;
    });
  }

  getTutorStream() async {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final tutorStream = await FirebaseFirestore.instance
        .collection('tutor')
        .orderBy('username')
        .get();

    setState(() {
      allTutors =
          tutorStream.docs.where((doc) => doc.id != currentUserUid).toList();
    });
    searchResultsList();
  }

  List resultSubList = [];

  void filterResultsBySubject(String subject) {
    var showSubResults = [];

    for (var tutorSnapShot in allTutors) {
      var subjects = List<String>.from(tutorSnapShot['subjects']);
      if (subjects.contains(subject)) {
        showSubResults.add(tutorSnapShot);
      }
    }

    setState(() {
      resultSubList = showSubResults;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //getTutorStream();
    super.initState();
    _model = createModel(context, () => StudentUIpageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getTutorStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0, 0.5, 1],
            begin: const AlignmentDirectional(-1, -1),
            end: const AlignmentDirectional(1, 1),
            colors: [
              FlutterFlowTheme.of(context).primary,
              FlutterFlowTheme.of(context).error,
              FlutterFlowTheme.of(context).tertiary
            ],
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 0, 6),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryText,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fill,
                        items: [
                          PopupMenuItem(
                            child: TextButton(
                              child: const Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 8),
                                  Text('Profile'),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/student_personal_profile');
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              child: const Row(
                                children: [
                                  Icon(Icons.chat),
                                  SizedBox(width: 8),
                                  Text('Chats'),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/chat');
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              child: const Row(
                                children: [
                                  Icon(Icons.swap_horiz),
                                  SizedBox(width: 8),
                                  Text('Switch to Tutor'),
                                ],
                              ),
                              onPressed: () async {
                                try {
                                  if (user == null) {
                                    throw Exception('User is not logged in');
                                  }

                                  // Get a reference to the user's document in the 'students' collection
                                  var userDoc = _firestore
                                      .collection('student')
                                      .doc(user?.uid);

                                  // Retrieve the document
                                  var docSnapshot = await userDoc.get();
                                  if (docSnapshot.exists) {
                                    // If the document exists, get the data
                                    var data = docSnapshot.data();

                                    // Create a new document in the 'tutors' collection with the same data
                                    await _firestore
                                        .collection('tutor')
                                        .doc(user?.uid)
                                        .set(data!);
                                  }
                                  Navigator.pushNamed(context, '/tutor_UI');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Failed to switch to student: $e'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              child: const Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 8),
                                  Text('Sign Out'),
                                ],
                              ),
                              onPressed: () {
                                AuthManager authManager = AuthManager();
                                authManager.signOut();
                                Navigator.pushNamed(context, '/landing_page');
                              },
                            ),
                          ),
                          // Add more PopupMenuItems for more pages later
                        ],
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://picsum.photos/seed/626/600',
                        width: 400,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                '$username',
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                    color: FlutterFlowTheme.of(context).primaryBackground),
              ),
              centerTitle: false,
              elevation: 0,
            ),
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              onChanged: (value) async {
                                searchResults = await fetchTutors(value);
                                searchResultsList();
                                setState(() {});
                              },
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                filled: true,
                                labelText: 'Search tutors...',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).success,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                suffixIcon: Icon(
                                  Icons.search_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                      /*Padding(
                      padding: const EdgeInsets.all(10),
                      child: FFButtonWidget(
                        onPressed: () async {
                          String name = _model.textController.text;
                          searchResults = await fetchTutors(name);
                          setState(() {}); // Call setState to update the UI
                        }, //search button

                        text: '',
                        icon: const Icon(
                          Icons.filter_list_alt,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          width: 52,
                          height: 50,
                          padding: const EdgeInsets.all(14),
                          iconPadding: const EdgeInsets.all(0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).success,
                                  ),
                          elevation: 3,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ), */
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                    child: Text(
                      'Find Tutor',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 44),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: resultList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot tutor = resultList[index];
                      return Container(
                        width: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 12, 16, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              /*Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  tutor['imageUrl'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
                            ),*/

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                    context,
                                    '/tutor_profile',
                                        arguments: tutor,
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tutor['username'],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .copyWith(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 4, 0),
                                              child: Icon(
                                                Icons.tab,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                size: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 16, 0),
                                              child: Text(
                                                tutor['subject'],
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelSmall
                                                    .copyWith(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 4, 0),
                                              child: Icon(
                                                Icons.apartment,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                size: 16,
                                              ),
                                            ),
                                            Text(
                                              tutor['educationlevel'],
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelSmall
                                                  .copyWith(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate),
                                            ),
                                          ],
                                        ),
                                      ].divide(const SizedBox(height: 4)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
