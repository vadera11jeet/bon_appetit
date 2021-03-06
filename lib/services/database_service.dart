import 'package:bon_appetit/models/category.dart';
import 'package:bon_appetit/models/food_item.dart';
import 'package:bon_appetit/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference restaurantCollection =
      Firestore.instance.collection('restaurants');

  //insert the data of restaurant
  Future updateUserData(String restaurantName, String restaurantOwnerName,
      String phoneNumber, String restaurantAddress, String city) async {
    return await restaurantCollection.document(uid).setData({
      'restaurant_name': restaurantName,
      'restaurant_owner_name': restaurantOwnerName,
      'phone_number': phoneNumber,
      'restaurant_address': restaurantAddress,
      'city': city,
      'is_registered': 'true',
    });
  }

  // to get the status of restaurant registered or not
  Future<String> get getRegisterStatus async {
    return await restaurantCollection.document(uid).get().then((value) {
      if (value.exists) {
        return value.data['is_registered'];
      }
      return null;
    });
  }

  // to insert and update the category info.
  Future<void> insertCategoryData(String id, String name) async {
    String categoryCollectionName = uid + 'category';
    final CollectionReference categoryCollection =
        Firestore.instance.collection(categoryCollectionName);
    return await categoryCollection.document(id).setData({
      'category_id': id,
      'category_name': name,
    });
  }

  //mapping of data from firestore to category modal
  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Category(
          categoryId: doc.data['category_id'],
          categoryName: doc.data['category_name']);
    }).toList();
  }

  //stream of category
  Stream<List<Category>> get categories {
    String categoryCollectionName = uid + 'category';
    final CollectionReference categoryCollection =
        Firestore.instance.collection(categoryCollectionName);
    return categoryCollection.snapshots().map(_categoryListFromSnapshot);
  }

  // delete category
  Future<void> deleteCategory(String documentId) async {
    String categoryCollectionName = uid + 'category';
    final CollectionReference categoryCollection =
        Firestore.instance.collection(categoryCollectionName);
    await categoryCollection.document(documentId).delete();
  }

  // to insert or update the data of food item to firestore
  Future<void> insertFoodItemData(String id, String name, String price,
      String category, String description, String type) async {
    String foodItemCollectionName = uid + 'food';
    final CollectionReference foodItemCollection =
        Firestore.instance.collection(foodItemCollectionName);
    return await foodItemCollection.document(id).setData({
      'fooditem_id': id,
      'fooditem_name': name,
      'fooditem_price': price,
      'fooditem_category': category,
      'fooditem_description': description,
      'fooditem_type': type
    });
  }

  //stream of food items
  Stream<List<FoodItem>> get foodItems {
    String foodItemCollectionName = uid + 'food';
    final CollectionReference foodItemCollection =
        Firestore.instance.collection(foodItemCollectionName);
    return foodItemCollection.snapshots().map(_foodItemsListFromSnapshot);
  }

  //to get the data form firestore to fooditem model by mapping
  List<FoodItem> _foodItemsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return FoodItem(
        foodItemId: doc.data['fooditem_id'],
        foodItemName: doc.data['fooditem_name'],
        foodItemPrice: doc.data['fooditem_price'],
        foodItemCategory: doc.data['fooditem_category'],
        foodItemDescription: doc.data['fooditem_description'],
        foodItemType: doc.data['fooditem_type'],
      );
    }).toList();
  }

  //delete food item
  Future<void> deleteFoodItem(String documentId) async {
    String foodItemCollectionName = uid + 'food';
    final CollectionReference foodItemCollection =
        Firestore.instance.collection(foodItemCollectionName);
    await foodItemCollection.document(documentId).delete();
  }

  //Edit food item category in fooditem when category name is changed
  Future<void> editFoodItemCategory(
      String oldCategoryName, String newCategoryName) async {
    String foodItemCollectionName = uid + 'food';
    final CollectionReference foodItemCollection =
        Firestore.instance.collection(foodItemCollectionName);
    foodItemCollection
        .where('fooditem_category', isEqualTo: oldCategoryName)
        .getDocuments()
        .then((value) async {
      value.documents.forEach((element) async {
        await foodItemCollection
            .document(element.documentID)
            .updateData({'fooditem_category': newCategoryName});
      });
    });
  }

  //delete all the fooditem when food item category deleted
  Future<void> deleteFoodItemCategory(String categoryName) async {
    String foodItemCollectionName = uid + 'food';
    final CollectionReference foodItemCollection =
        Firestore.instance.collection(foodItemCollectionName);
    foodItemCollection
        .where('fooditem_category', isEqualTo: categoryName)
        .getDocuments()
        .then((value) async {
      value.documents.forEach((element) async {
        await foodItemCollection.document(element.documentID).delete();
      });
    });
  }

  //get the name of restaurant
  Future<String> get getRestaurantName async {
    return await restaurantCollection.document(uid).get().then((value) {
      if (value.exists) {
        return value.data['restaurant_name'];
      }
      return null;
    });
  }

  Stream<Restaurant> get restaurantData {
    return Firestore.instance
        .collection('restaurants')
        .document(uid)
        .snapshots()
        .map(_restaurantDataFromSnapshot);
  }

  Restaurant _restaurantDataFromSnapshot(DocumentSnapshot snapshot) {
    return Restaurant(
        restaurantName: snapshot.data['restaurant_name'],
        restaurantPhoneNumber: snapshot.data['phone_number']);
  }
}
