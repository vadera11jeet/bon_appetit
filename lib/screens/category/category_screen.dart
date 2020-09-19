import 'package:bon_appetit/models/category.dart';
import 'package:bon_appetit/services/auth_service.dart';
import 'package:bon_appetit/services/database_service.dart';
import 'package:bon_appetit/shared/loading.dart';
import 'package:bon_appetit/widgets/image_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_category_screen.dart';
import 'category_list.dart';

class CategoryScreen extends StatefulWidget {
  final Function toggleFunction;

  CategoryScreen({this.toggleFunction});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoading = false;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String qrData = Provider.of<FirebaseUser>(context).uid.toString();
    return isLoading
        ? Loading()
        : StreamProvider<List<Category>>.value(
            value: DatabaseService(uid: Provider.of<FirebaseUser>(context).uid)
                .categories,
            child: Scaffold(
              drawer: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Drawer(
                  child: ListView(
                    children: [
                      Container(
                        color: Color(0xFFc9e3db),
                        padding: EdgeInsets.symmetric(vertical: 30),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'Bon Appetit',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 45),
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        Provider.of<FirebaseUser>(context)
                                            .photoUrl),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                Provider.of<FirebaseUser>(context).displayName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return ImageDialog(
                                  qrData: qrData,
                                );
                              });
                        },
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              FontAwesomeIcons.qrcode,
                              color: Colors.grey[700],
                            ),
                            title: Text('QR code'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.note,
                              color: Colors.grey[700],
                            ),
                            title: Text('About Us'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.contact_mail,
                              color: Colors.grey[700],
                            ),
                            title: Text('Contact Us'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthService().logout();
                            if (!_disposed) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            print(e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Colors.grey[700],
                            ),
                            title: Text('Logout'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                elevation: 1,
                backgroundColor: Color(0xff5ab190),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddCategory(isAdded: false),
                  );
                },
                child: Icon(Icons.add),
              ),
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.grey[700]),
                backgroundColor: Color(0xFFc9e3db),
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Bon Appetit',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: widget.toggleFunction,
                      icon: Icon(Icons.compare_arrows),
                      label: Text('Food Items'))
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFc9e3db),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          "Food Category",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(child: CategoryList()),
                ],
              ),
            ),
          );
  }
}
