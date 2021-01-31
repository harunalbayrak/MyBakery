import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:flutter_my_bakery/services/crud.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/field_test.dart';

class EditNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel existingNote;
  EditNotePage({Key key, Function() triggerRefetch, NotesModel existingNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  bool isDirtyTitle = false;
  bool isDirtyContent = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  DatabaseService service = DatabaseService();

  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote == null) {
      currentNote = NotesModel(
          id: Uuid().v1(),
          content: '',
          title: '',
          date: DateTime.now(),
          isImportant: false);
      isNoteNew = true;
      print(currentNote.id);
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(contentFocus);
                },
                onChanged: (value) {
                  markTitleAsDirty(value);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Başlık',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: contentFocus,
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  markContentAsDirty(value);
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration.collapsed(
                  hintText: 'Yazmaya başlayın...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),
                      IconButton(
                        tooltip: 'Önemli olarak işaretleyin!',
                        icon: Icon(currentNote.isImportant
                            ? Icons.flag
                            : Icons.outlined_flag),
                        onPressed: titleController.text.trim().isNotEmpty &&
                                contentController.text.trim().isNotEmpty
                            ? markImportantAsDirty
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          handleDelete();
                        },
                      ),
                      AnimatedContainer(
                        margin: EdgeInsets.only(left: 10),
                        duration: Duration(milliseconds: 200),
                        width: (isNoteNew && isDirtyTitle && isDirtyContent) ||
                                (!isNoteNew &&
                                    (isDirtyContent || isDirtyTitle) &&
                                    titleController.text.isNotEmpty)
                            ? 120
                            : 0,
                        height: 42,
                        curve: Curves.decelerate,
                        child: RaisedButton.icon(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(120),
                                  bottomLeft: Radius.circular(120))),
                          icon: Icon(Icons.done),
                          label: Text(
                            'Kaydet',
                          ),
                          onPressed: handleSave,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  void handleSave() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      print('Hey there ${currentNote.content}');
    });
    if (isNoteNew) {
      var latestNote = currentNote;
      print("uid: " + currentNote.id);
      service.addNote(currentNote.id, currentNote.toMap());
      setState(() {
        currentNote = latestNote;
      });
    } else {
      service.updateNote(currentNote.id, currentNote.toMap());
    }
    setState(() {
      isNoteNew = false;
      isDirtyTitle = false;
      isDirtyContent = false;
    });
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void markTitleAsDirty(String title) {
    if (fieldTest.noteValidator(title) == null)
      setState(() {
        isDirtyTitle = true;
      });
    else
      setState(() {
        isDirtyTitle = false;
      });
  }

  void markContentAsDirty(String content) {
    if (fieldTest.noteValidator(content) == null)
      setState(() {
        isDirtyContent = true;
      });
    else
      setState(() {
        isDirtyContent = false;
      });
  }

  void markImportantAsDirty() {
    setState(() {
      currentNote.isImportant = !currentNote.isImportant;
    });
    handleSave();
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Notu sil'),
              content: Text('Bu not kalıcı olarak silinecektir.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sil',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    service.deleteNote(currentNote.id);
                    widget.triggerRefetch();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('İptal',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}

class EditExpensePage extends StatefulWidget {
  Function() triggerRefetch;
  ExpensesModel existingExpense;
  EditExpensePage(
      {Key key, Function() triggerRefetch, ExpensesModel existingExpense})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingExpense = existingExpense;
  }
  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  bool isDirtyTitle = false;
  bool isDirtyContent = false;
  bool isExpenseNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  ExpensesModel currentExpense;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense == null) {
      currentExpense =
          ExpensesModel(content: '', title: '', date: DateTime.now());
      isExpenseNew = true;
    } else {
      currentExpense = widget.existingExpense;
      isExpenseNew = false;
    }
    titleController.text = currentExpense.title;
    contentController.text = currentExpense.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.number,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(contentFocus);
                },
                onChanged: (value) {
                  markTitleAsDirty(value);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Gider tutarını girin',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: contentFocus,
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  markContentAsDirty(value);
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration.collapsed(
                  hintText: 'Açıklama girin...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          handleDelete();
                        },
                      ),
                      AnimatedContainer(
                        margin: EdgeInsets.only(left: 20),
                        duration: Duration(milliseconds: 200),
                        width:
                            (isExpenseNew && isDirtyTitle && isDirtyContent) ||
                                    (!isExpenseNew &&
                                        (isDirtyTitle || isDirtyContent))
                                ? 150
                                : 0,
                        height: 42,
                        curve: Curves.decelerate,
                        child: RaisedButton.icon(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(120),
                                  bottomLeft: Radius.circular(120))),
                          icon: Icon(Icons.done),
                          label: Text(
                            'Kaydet',
                            style: TextStyle(letterSpacing: 0),
                          ),
                          onPressed: handleSave,
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  void handleSave() async {
    setState(() {
      currentExpense.title = titleController.text;
      currentExpense.content = contentController.text;
      print('Hey there ${currentExpense.content}');
    });
    if (isExpenseNew) {
      var latestNote = currentExpense;
      // await NotesDatabaseService.db.addExpenseInDB(currentExpense);
      service.addExpense(currentExpense.id, currentExpense.toMap());
      setState(() {
        currentExpense = latestNote;
      });
    } else {
      service.updateExpense(currentExpense.id, currentExpense.toMap());
    }
    setState(() {
      isExpenseNew = false;
      isDirtyTitle = false;
      isDirtyContent = false;
    });
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void markTitleAsDirty(String title) {
    if (fieldTest.expenseTitleValidator(title) == null)
      setState(() {
        isDirtyTitle = true;
      });
    else
      setState(() {
        isDirtyTitle = false;
      });
  }

  void markContentAsDirty(String content) {
    if (fieldTest.expenseContentValidator(content) == null)
      setState(() {
        isDirtyContent = true;
      });
    else
      setState(() {
        isDirtyContent = false;
      });
  }

  void handleDelete() async {
    if (isExpenseNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Gideri sil'),
              content: Text('Bu gider kalıcı olarak silinecektir.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sil',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    service.deleteExpense(currentExpense.id);
                    // await NotesDatabaseService.db
                    // .deleteExpenseInDB(currentExpense);
                    widget.triggerRefetch();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('İptal',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}

class EditVeresiyePage extends StatefulWidget {
  Function() triggerRefetch;
  VeresiyeModel existingVeresiye;
  EditVeresiyePage(
      {Key key, Function() triggerRefetch, VeresiyeModel existingVeresiye})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingVeresiye = existingVeresiye;
  }
  @override
  _EditVeresiyePageState createState() => _EditVeresiyePageState();
}

class _EditVeresiyePageState extends State<EditVeresiyePage> {
  bool titleIsDirty = false;
  bool contentIsDirty = false;
  bool isVeresiyeNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  VeresiyeModel currentVeresiye;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DatabaseService service = DatabaseService();
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.existingVeresiye == null) {
      currentVeresiye =
          VeresiyeModel(content: '', title: '', date: DateTime.now());
      isVeresiyeNew = true;
    } else {
      currentVeresiye = widget.existingVeresiye;
      isVeresiyeNew = false;
    }
    titleController.text = currentVeresiye.title;
    contentController.text = currentVeresiye.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                  FocusScope.of(context).requestFocus(contentFocus);
                },
                onChanged: (value) {
                  markTitleAsDirty(value);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Veresiye Sahibi',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: contentFocus,
                controller: contentController,
                keyboardType: TextInputType.number,
                maxLines: null,
                onChanged: (value) {
                  markContentAsDirty(value);
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration.collapsed(
                  hintText: 'Veresiye Tutarı',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          handleDelete();
                        },
                      ),
                      AnimatedContainer(
                        margin: EdgeInsets.only(left: 10),
                        duration: Duration(milliseconds: 200),
                        width: (titleIsDirty && contentIsDirty) ? 130 : 0,
                        height: 42,
                        curve: Curves.decelerate,
                        child: RaisedButton.icon(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(120),
                                  bottomLeft: Radius.circular(120))),
                          icon: Icon(Icons.done),
                          label: Text(
                            'Kaydet',
                            style: TextStyle(letterSpacing: 0),
                          ),
                          onPressed: () {
                            handleSave();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  void handleSave() async {
    setState(() {
      currentVeresiye.title = titleController.text;
      currentVeresiye.content = contentController.text;
      print('Hey there ${currentVeresiye.content}');
    });
    if (isVeresiyeNew) {
      service.addVeresiye(currentVeresiye.title, currentVeresiye.toMap());
      // var latestVeresiye =
      // await NotesDatabaseService.db.addVeresiyeInDB(currentVeresiye);

      setState(() {
        // currentVeresiye ;
      });
    } else {
      // await NotesDatabaseService.db.updateVeresiyeInDB(currentVeresiye);
      service.updateVeresiye(currentVeresiye.title, currentVeresiye.toMap());
    }
    setState(() {
      isVeresiyeNew = false;
      contentIsDirty = false;
      titleIsDirty = false;
    });
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void markTitleAsDirty(String title) {
    if (fieldTest.veresiyeTitleValidator(title) == null)
      setState(() {
        titleIsDirty = true;
      });
    else
      setState(() {
        titleIsDirty = false;
      });
  }

  void markContentAsDirty(String content) {
    if (fieldTest.veresiyeContentValidator(content) == null)
      setState(() {
        contentIsDirty = true;
      });
    else
      setState(() {
        contentIsDirty = false;
      });
  }

  void handleDelete() async {
    if (isVeresiyeNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Veresiye hesabını sil'),
              content: Text('Bu veresiye hesabı kalıcı olarak silinecektir.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text('Sil',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                ),
                FlatButton(
                  child: Text('İptal',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
