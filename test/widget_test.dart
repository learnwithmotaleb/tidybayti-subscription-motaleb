// // test/controllers/employee_home_controller_test.dart

// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
// import 'package:tidybayte/app/data/service/api_client.dart'; 
// import 'package:http/http.dart' as http;
 

// // GenerateMocks annotation
// @GenerateMocks([ApiClient])
// void main() {
//   late EmployeeHomeController controller;
//   late MockApiClient mockApiClient;

//   setUp(() {
//     mockApiClient = MockApiClient();
//     controller = EmployeeHomeController();
//     controller.apiClient = mockApiClient; // inject mock
//   });

//   group('EmployeeHomeController Tests', () {
//     test('getPending sets pendingTask on success', () async {
//       // Arrange: fake API response
//       final fakeResponse = http.Response('''
//         {
//           "data": {
//             "meta": {"count": 1},
//             "result": {
//               "2023-09-01": [
//                 {
//                   "id": "task1",
//                   "assignedTo": {"id": "emp1", "name": "John"},
//                   "status": "pending"
//                 }
//               ]
//             }
//           }
//         }
//       ''', 200);

//       when(mockApiClient.get(
//         url: anyNamed('url'),
//         showResult: anyNamed('showResult'),
//       )).thenAnswer((_) async => fakeResponse);

//       // Act
//       await controller.getPending();

//       // Assert
//       expect(controller.pendingTask.value.result?.length, 1);
//       expect(controller.pendingTask.value.result?.first.status, "pending");
//     });

//     test('getPending handles API failure', () async {
//       // Arrange
//       final fakeResponse = http.Response('{"message": "Not Found"}', 404);
//       when(mockApiClient.get(
//         url: anyNamed('url'),
//         showResult: anyNamed('showResult'),
//       )).thenAnswer((_) async => fakeResponse);

//       // Act
//       await controller.getPending();

//       // Assert: expect no tasks
//       expect(controller.pendingTask.value.result, isNull);
//     });
//   });
// }
