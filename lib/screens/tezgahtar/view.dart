import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/edit.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';
import 'package:flutter_my_bakery/services/crud.dart';

class ViewNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel currentNote;
  ViewNotePage({Key key, Function() triggerRefetch, NotesModel currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 40.0, bottom: 16),
              child: AnimatedOpacity(
                opacity: headerShouldShow ? 1 : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Text(
                  widget.currentNote.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: headerShouldShow ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  DateFormat.yMd().add_jm().format(widget.currentNote.date),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 36, bottom: 24, right: 24),
              child: Text(
                widget.currentNote.content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                        icon: Icon(widget.currentNote.isImportant
                            ? Icons.flag
                            : Icons.outlined_flag),
                        onPressed: () {
                          markImportantAsDirty();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: handleDelete,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.share),
                        onPressed: handleShare,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.edit),
                        onPressed: handleEdit,
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
    print("save state: " + widget.currentNote.toMap().toString());
    service.updateNote(widget.currentNote.id, widget.currentNote.toMap());
    widget.triggerRefetch();
  }

  void markImportantAsDirty() {
    setState(() {
      widget.currentNote.isImportant = !widget.currentNote.isImportant;
    });
    handleSave();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditNotePage(
                  existingNote: widget.currentNote,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  void handleShare() {
    Share.share(
        '${widget.currentNote.title.trim()}\n(On: ${widget.currentNote.date.toIso8601String().substring(0, 10)})\n\n${widget.currentNote.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Notu Sil'),
            content: Text('Bu not kalıcı olarak silinecektir.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Sil',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  service.deleteNote(widget.currentNote.id);
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

class ViewExpensePage extends StatefulWidget {
  Function() triggerRefetch;
  ExpensesModel currentExpense;
  ViewExpensePage(
      {Key key, Function() triggerRefetch, ExpensesModel currentExpense})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentExpense = currentExpense;
  }
  @override
  _ViewExpensePageState createState() => _ViewExpensePageState();
}

class _ViewExpensePageState extends State<ViewExpensePage> {
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 40.0, bottom: 16),
              child: AnimatedOpacity(
                opacity: headerShouldShow ? 1 : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Text(
                  widget.currentExpense.title + " ₺",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: headerShouldShow ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  DateFormat.yMd().add_jm().format(widget.currentExpense.date),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 36, bottom: 24, right: 24),
              child: Text(
                widget.currentExpense.content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                        onPressed: handleDelete,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.share),
                        onPressed: handleShare,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.edit),
                        onPressed: handleEdit,
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
    print(
        "handleSave : -----------------------------------------------------------------------------------");
    var temp = widget.currentExpense.id;
    print("uid: " + temp + "-----------------------");
    service.updateExpense(
        widget.currentExpense.id, widget.currentExpense.toMap());
    widget.triggerRefetch();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditExpensePage(
                  existingExpense: widget.currentExpense,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  void handleShare() {
    Share.share(
        '${widget.currentExpense.title.trim()}\n(On: ${widget.currentExpense.date.toIso8601String().substring(0, 10)})\n\n${widget.currentExpense.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Gideri Sil'),
            content: Text('Bu gider kalıcı olarak silinecektir.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Sil',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  // await NotesDatabaseService.db
                  //     .deleteExpenseInDB(widget.currentExpense);
                  service.deleteExpense(widget.currentExpense.id);
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

class ViewVeresiyePage extends StatefulWidget {
  Function() triggerRefetch;
  VeresiyeModel currentVeresiye;
  ViewVeresiyePage(
      {Key key, Function() triggerRefetch, VeresiyeModel currentVeresiye})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentVeresiye = currentVeresiye;
  }
  @override
  _ViewVeresiyePageState createState() => _ViewVeresiyePageState();
}

class _ViewVeresiyePageState extends State<ViewVeresiyePage> {
  DatabaseService service = DatabaseService();
  @override
  void initState() {
    super.initState();
    showHeader();
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 40.0, bottom: 16),
              child: AnimatedOpacity(
                opacity: headerShouldShow ? 1 : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Text(
                  widget.currentVeresiye.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: headerShouldShow ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  DateFormat.yMd().add_jm().format(widget.currentVeresiye.date),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 36, bottom: 24, right: 24),
              child: Text(
                widget.currentVeresiye.content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                        onPressed: handleDelete,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.share),
                        onPressed: handleShare,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.edit),
                        onPressed: handleEdit,
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
    // await NotesDatabaseService.db.updateVeresiyeInDB(widget.currentVeresiye);
    service.updateVeresiye(widget.currentVeresiye.title, widget.currentVeresiye.toMap());
    widget.triggerRefetch();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditVeresiyePage(
                  existingVeresiye: widget.currentVeresiye,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  void handleShare() {
    Share.share(
        '${widget.currentVeresiye.title.trim()}\n(On: ${widget.currentVeresiye.date.toIso8601String().substring(0, 10)})\n\n${widget.currentVeresiye.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Veresiye hesabını Sil'),
            content: Text('Bu veresiye hesabı kalıcı olarak silinecektir.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Sil',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  // await NotesDatabaseService.db
                  //     .deleteVeresiyeInDB(widget.currentVeresiye);
                  service.deleteVeresiye(widget.currentVeresiye.title);
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
