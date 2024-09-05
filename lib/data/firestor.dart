import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreCartDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> addCartItem(String productId, String title, double price, int quantity) async {
    try {
      var uuid = Uuid().v4();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(uuid)
          .set({
        'id': uuid,
        'productId': productId,
        'title': title,
        'price': price,
        'quantity': quantity,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> updateCartItem(String uuid, int quantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(uuid)
          .update({
        'quantity': quantity,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCartItem(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
