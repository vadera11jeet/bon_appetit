import 'package:bon_appetit/models/category.dart';
import 'package:bon_appetit/services/database_service.dart';
import 'package:bon_appetit/widgets/alert_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_category_screen.dart';
import 'package:bon_appetit/shared/constants.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile({this.category});

  @override
  Widget build(BuildContext context) {
    Future<bool> showAlertBox() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialogBox(
          textMessage: 'Do you really want to delete this category?',
        ),
      );
    }

    return Card(
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
        title: Text(
          category.categoryName ?? '',
          style: kTileTextStyle,
        ),
        trailing: Wrap(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.teal[400],
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => AddCategory(
                    isAdded: true,
                    category: category,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.teal[400],
              ),
              onPressed: () async {
                bool result = await showAlertBox();

                if (result ?? false) {
                  await DatabaseService(
                          uid: Provider.of<FirebaseUser>(context, listen: false)
                              .uid)
                      .deleteFoodItemCategory(category.categoryName);
                  await DatabaseService(
                          uid: Provider.of<FirebaseUser>(context, listen: false)
                              .uid)
                      .deleteCategory(category.categoryId);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
