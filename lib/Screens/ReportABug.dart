import 'dart:io';
import 'dart:ui';

import 'package:break_it/Models/Report.dart';
import 'package:break_it/Shared/Shared.dart';
import 'package:break_it/Shared/firebaseDB.dart';
import 'package:flutter/material.dart';

class ReportABug extends StatefulWidget {
  const ReportABug({Key? key}) : super(key: key);

  @override
  _ReportABugState createState() => _ReportABugState();
}

class _ReportABugState extends State<ReportABug> {
  String _description = "";
  String _title = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> _showMyDialog(
      String title, String description, bool error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Shared.darkThemeOn ? Colors.white70 : Colors.black87,
          title: Row(
            children: [
              Icon(
                error ? Icons.error : Icons.done,
                color: Color(Shared.colorPrimaryBackGround),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  description,
                  style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Color(Shared.colorPrimaryBackGround)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Shared.colorPrimaryBackGround),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(Shared.colorUi),
        title: Text(
          SharedData().dictionary[Shared.selectedLanguage]?["Report a bug"] ??
              "Report a bug",
          style: TextStyle(fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        SharedData().dictionary[Shared.selectedLanguage]
                                ?["Report a bug \nOr Request a feature"] ??
                            "Report a bug \nOr Request a feature",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(Shared.colorPrimaryText),
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        style: TextStyle(
                            color: Color(Shared.colorPrimaryText),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText:
                              SharedData().dictionary[Shared.selectedLanguage]
                                      ?["Title"] ??
                                  "Title",
                          focusColor: Color(Shared.colorPrimaryText),
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color(Shared.colorPrimaryText),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (input) => input!.trim().isEmpty
                            ? (SharedData().dictionary[Shared.selectedLanguage]
                                    ?["please enter a valid Title"] ??
                                "please enter a valid Title")
                            : null,
                        onChanged: (input) => _title = input.toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 10,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(Shared.colorPrimaryText),
                        ),
                        decoration: InputDecoration(
                          labelText:
                              (SharedData().dictionary[Shared.selectedLanguage]
                                      ?["Description"] ??
                                  "Description"),
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color(Shared.colorPrimaryText),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color(Shared.colorPrimaryText)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (input) => input!.trim().isEmpty
                            ? (SharedData().dictionary[Shared.selectedLanguage]
                                    ?["please enter a valid Description"] ??
                                "please enter a valid Description")
                            : null,
                        onChanged: (input) => _description = input.toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(Shared.colorPrimaryText)),
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  FirebaseDB().createReport(ReportModel(
                                      title: _title,
                                      description: _description));
                                  await _showMyDialog(
                                      SharedData().dictionary[
                                                  Shared.selectedLanguage]
                                              ?['Thank You!'] ??
                                          'Thank You!',
                                      SharedData().dictionary[
                                                  Shared.selectedLanguage]?[
                                              'Thank you for reporting the bug.\nIt is very helpful for us!'] ??
                                          'Thank you for reporting the bug.\nIt is very helpful for us!',
                                      false);
                                  Navigator.pop(context);
                                }
                              } on SocketException catch (_) {
                                await _showMyDialog(
                                    SharedData().dictionary[Shared
                                            .selectedLanguage]?['Sorry!'] ??
                                        'Sorry!',
                                    SharedData().dictionary[
                                                Shared.selectedLanguage]?[
                                            'It seems like you have some internet problems.'] ??
                                        'It seems like you have some internet problems.',
                                    true);
                              }
                            }
                          },
                          child: Text(
                            SharedData().dictionary[Shared.selectedLanguage]
                                    ?["Submit"] ??
                                "Submit",
                            style: TextStyle(
                                color: Color(Shared.colorPrimaryBackGround),
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
