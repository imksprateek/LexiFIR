
import 'package:app_client/services/functions/Transciption%20service.dart';

bool SigninSuccessfull  = false;
bool LoginSuccessfull = false ;

String username = "";
final String serverUrl = "ws://eng.ksprateek.studio/TranscribeStreaming";
String transcription='' ;
String conversation = '' ;
final Transcription_service = TranscriptionService() ;