import 'dart:developer';

import '../../Constants/api_routes.dart';

import '../../Pages/Individual Bill/SocietyResidents/Model/Resident.dart';
import '../../Services/Network Services/network_services.dart';

class SocietyResidentsRepository {
  final networkServices = NetworkServices();

  Future<SocietyResident> residentsApi({
    required bearerToken,
    required subAdminId,
    //required type
  }) async {
    var response = await networkServices.getReq(
        "${Api.societyresidents}/$subAdminId",
        bearerToken: bearerToken);

    return SocietyResident.fromJson(response);
  }

  Future<SocietyResident> searchApi(
      {required query, required subAdminId, required bearerToken}) async {
    var response = await networkServices.getReq(
        "${Api.searchresident}/$subAdminId/$query",
        bearerToken: bearerToken);

    log(response.toString());

    return SocietyResident.fromJson(response);
  }

 
  Future<SocietyResident> filterResidentsApi(
      {required bearerToken, required subAdminId, required type}) async {
    var response = await networkServices.getReq(
        "${Api.filterResident}/$subAdminId/$type",
        bearerToken: bearerToken);

    return SocietyResident.fromJson(response);
  }
}
