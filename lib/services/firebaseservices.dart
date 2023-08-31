import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> createRequisitionsMap(
    List<String> reqNumbers) async {
  Map<String, dynamic> requisitions = {};

  for (String reqNumber in reqNumbers) {
    requisitions[reqNumber] = false;
  }

  return requisitions;
}

Future<void> createOrUpdateCollection(
    String companyId,
    String email,
    String username,
    String department,
    String grade,
    String maxAmount,
    List<String> reqNumbers) async {
  // Créer le champ requisitions avec des valeurs par défaut
  final Map<String, dynamic> requisitions =
      await createRequisitionsMap(reqNumbers);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference companyCollection =
      firestore.collection(companyId.trim());

  final DocumentReference documentRef = companyCollection.doc(email);

  final DocumentSnapshot snapshot = await documentRef.get();
  if (snapshot.exists) {
    // Le document existe déjà, récupérer les données existantes
    final Map<String, dynamic>? existingData =
        snapshot.data() as Map<String, dynamic>?;

    if (existingData != null && existingData.containsKey('requisitions')) {
      // Les requêtes existent déjà, mettre à jour seulement les valeurs spécifiées
      final Map<String, dynamic> existingRequisitions =
          existingData['requisitions'];

      requisitions.forEach((reqNumber, value) {
        if (existingRequisitions.containsKey(reqNumber)) {
        } else {
          existingRequisitions.addAll({"$reqNumber": "$value"});
        }
      });

      await documentRef.update({
        'email': email,
        'username': username,
        'department': department,
        'grade': grade,
        'maxAmount': int.parse(maxAmount),
        'requisitions': existingRequisitions,
      });
    } else {
      // Les requêtes n'existent pas, les ajouter entièrement
      await documentRef.set({
        'email': email,
        'username': username,
        'department': department,
        'grade': grade,
        'maxAmount': int.parse(maxAmount),
        'requisitions': requisitions,
      });
    }
  } else {
    // Le document n'existe pas, le créer avec les nouvelles données
    await documentRef.set({
      'email': email,
      'username': username,
      'department': department,
      'grade': grade,
      'maxAmount': int.parse(maxAmount),
      'requisitions': requisitions,
    });
  }
}
