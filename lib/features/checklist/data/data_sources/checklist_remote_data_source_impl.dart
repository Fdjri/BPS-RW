import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/checklist_model.dart';
import 'checklist_remote_data_source.dart';

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final http.Client client;

  ChecklistRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ChecklistModel>> getInputChecklist() async {
    // URL API Testing
    final uri = Uri.parse('https://bpsrw.dinaslhdki.id/api/rw/input-checklist-rumah/test');

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedJson = json.decode(response.body);
        List<dynamic> dataList;
        if (decodedJson is List) {
          dataList = decodedJson;
        } else if (decodedJson is Map<String, dynamic> && decodedJson.containsKey('data')) {
          dataList = decodedJson['data'];
        } else {
          throw ServerException(); 
        }
        return dataList
            .map((jsonItem) => ChecklistModel.fromJson(jsonItem))
            .toList();
      } else {
        throw ServerException(); 
      }
    } catch (e) {
      throw ServerException(); 
    }
  }
}