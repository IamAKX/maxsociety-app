import 'package:flutter/material.dart';
import 'package:maxsociety/model/flat_model.dart';
import 'package:maxsociety/model/operation_detail_model.dart';
import 'package:maxsociety/screen/admin_controls/community_member_list.dart';
import 'package:maxsociety/screen/admin_controls/create_community_member.dart';
import 'package:maxsociety/screen/admin_controls/create_flat.dart';
import 'package:maxsociety/screen/admin_controls/create_mom_screen.dart';
import 'package:maxsociety/screen/admin_controls/create_rule_screen.dart';
import 'package:maxsociety/screen/admin_controls/create_society_member.dart';
import 'package:maxsociety/screen/admin_controls/flat_screen.dart';
import 'package:maxsociety/screen/admin_controls/flat_summary.dart';
import 'package:maxsociety/screen/admin_controls/society_details.dart';
import 'package:maxsociety/screen/admin_controls/society_member_list.dart';
import 'package:maxsociety/screen/admin_controls/user_detail_screen.dart';
import 'package:maxsociety/screen/event/create_event.dart';
import 'package:maxsociety/screen/event/event_detail.dart';
import 'package:maxsociety/screen/forgot_password/forgot_password_screen.dart';
import 'package:maxsociety/screen/login/login_screen.dart';
import 'package:maxsociety/screen/profile/add_family_screen.dart';
import 'package:maxsociety/screen/profile/add_vehicle_screen.dart';
import 'package:maxsociety/screen/profile/edit_vehicle_screen.dart';
import 'package:maxsociety/screen/profile/family_screen.dart';
import 'package:maxsociety/screen/profile/profile_detail_update.dart';
import 'package:maxsociety/screen/profile/vehicle_screen.dart';
import 'package:maxsociety/screen/report/report_screen.dart';
import 'package:maxsociety/screen/service_request/service_request_details.dart';
import 'package:maxsociety/screen/society/about_society.dart';
import 'package:maxsociety/screen/admin_controls/admin_controls_screen.dart';
import 'package:maxsociety/screen/society/emergency_contact.dart';
import 'package:maxsociety/screen/society/govt_circular.dart';
import 'package:maxsociety/screen/society/mom_details.dart';
import 'package:maxsociety/screen/society/mom_screen.dart';
import 'package:maxsociety/screen/society/society_rule_detail.dart';
import 'package:maxsociety/widget/image_viewer.dart';
import 'package:maxsociety/widget/main_container.dart';
import 'package:maxsociety/widget/pdf_viewer.dart';
import 'package:maxsociety/widget/video_viewer.dart';

import '../screen/admin_controls/update_flat.dart';
import '../screen/appintro/app_intro_screen.dart';
import '../screen/profile/change_password_screen.dart';
import '../screen/service_request/all_service_request.dart';
import '../screen/service_request/create_service_request.dart';
import '../screen/society/society_rule_screen.dart';

class NavRoute {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppIntroScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AppIntroScreen());
      case LoginScreen.routePath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case ForgotPasswordScreen.routePath:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case ChangePasswordScreen.routePath:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case MainContainer.routePath:
        return MaterialPageRoute(builder: (_) => const MainContainer());
      case EventDetail.routePath:
        return MaterialPageRoute(
          builder: (_) => EventDetail(
            circularId: settings.arguments as String,
          ),
        );
      case ProfileDetailUpdateScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => const ProfileDetailUpdateScreen());
      case VehicleScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => VehicleScreen(
                  operationDetail: settings.arguments as OperationDetailModel,
                ));
      case AddVehicleScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AddVehicleScreen());
      case FamilyScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => FamilyScreen(
                  operationDetail: settings.arguments as OperationDetailModel,
                ));
      case AddFamilyMemberScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AddFamilyMemberScreen());
      case AboutSocietyScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AboutSocietyScreen());
      case SocietyRuleScreen.routePath:
        return MaterialPageRoute(builder: (_) => const SocietyRuleScreen());
      case SocietyRuleDetailsScreen.routePath:
        return MaterialPageRoute(
            builder: (_) =>
                SocietyRuleDetailsScreen(ruleId: settings.arguments as int));
      case MomScreen.routePath:
        return MaterialPageRoute(builder: (_) => const MomScreen());
      case MomDetailScreen.routePath:
        return MaterialPageRoute(
            builder: (_) =>
                MomDetailScreen(meetingId: settings.arguments as int));
      case GovermentCircularScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => const GovermentCircularScreen());
      case EmergencyContact.routePath:
        return MaterialPageRoute(builder: (_) => const EmergencyContact());
      case CreateServiceScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => CreateServiceScreen(
            category: settings.arguments as String,
          ),
        );
      case ServiceRequestDetail.routePath:
        return MaterialPageRoute(
          builder: (_) => ServiceRequestDetail(
            reqId: settings.arguments as int,
          ),
        );
      case AllServiceRequest.routePath:
        return MaterialPageRoute(builder: (_) => const AllServiceRequest());
      case AdminControlsScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AdminControlsScreen());
      case SocietyMemberScreen.routePath:
        return MaterialPageRoute(builder: (_) => const SocietyMemberScreen());
      case CreateSocietyMemberScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => const CreateSocietyMemberScreen());
      case CreateFlat.routePath:
        return MaterialPageRoute(builder: (_) => const CreateFlat());
      case FlatSummary.routePath:
        return MaterialPageRoute(
          builder: (_) => FlatSummary(
            flatList: settings.arguments as List<FlatModel>,
          ),
        );
      case FlatScreen.routePath:
        return MaterialPageRoute(builder: (_) => const FlatScreen());
      case SocietyDetails.routePath:
        return MaterialPageRoute(builder: (_) => const SocietyDetails());
      case CommunityMemberListScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => const CommunityMemberListScreen());
      case CreateCommitteeMember.routePath:
        return MaterialPageRoute(builder: (_) => const CreateCommitteeMember());
      case CreateEventScreen.routePath:
        return MaterialPageRoute(builder: (_) => const CreateEventScreen());
      case CreateRuleScreen.routePath:
        return MaterialPageRoute(builder: (_) => const CreateRuleScreen());
      case CreateMomScreen.routePath:
        return MaterialPageRoute(builder: (_) => const CreateMomScreen());
      case EditVehicleScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => EditVehicleScreen(
            vehicleNumber: settings.arguments as String,
          ),
        );
      case ImageViewer.routePath:
        return MaterialPageRoute(
          builder: (_) => ImageViewer(
            imageUrl: settings.arguments as String,
          ),
        );
      case VideoViewer.routePath:
        return MaterialPageRoute(
          builder: (_) => VideoViewer(
            videoUrl: settings.arguments as String,
          ),
        );
      case PDFViewer.routePath:
        return MaterialPageRoute(
          builder: (_) => PDFViewer(
            fileUrl: settings.arguments as String,
          ),
        );
      case UserDetail.routePath:
        return MaterialPageRoute(
          builder: (_) => UserDetail(
            userId: settings.arguments as String,
          ),
        );
      case UpdateFlat.routePath:
        return MaterialPageRoute(
          builder: (_) => UpdateFlat(
            flat: settings.arguments as FlatModel,
          ),
        );
      case ReportScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => const ReportScreen(),
        );
      default:
        return errorRoute();
    }
  }
}

errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  });
}
